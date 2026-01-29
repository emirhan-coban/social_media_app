import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:social_media_app/features/auth/data/firebase_auth_repo.dart';
import 'package:social_media_app/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:social_media_app/features/auth/presentation/cubits/auth_states.dart';
import 'package:social_media_app/features/auth/presentation/pages/auth_page.dart';
import 'package:social_media_app/features/home/presentation/pages/home_page.dart';
import 'package:social_media_app/firebase_options.dart';
import 'package:social_media_app/themes/dark_mode.dart';
import 'package:social_media_app/themes/light_mode.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final firebaseAuthRepo = FirebaseAuthRepo();

    return MultiBlocProvider(
      providers: [
        // auth cubit
        BlocProvider(
          create: (context) =>
              AuthCubit(authRepo: firebaseAuthRepo)..checkAuth(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Social Media App',
        theme: lightMode,
        darkTheme: darkMode,
        /*

        BLOC CONSUMER - Auth

        */
        home: BlocConsumer<AuthCubit, AuthState>(
          builder: (context, state) {
            print(state);

            // unauthenticated state
            if (state is AuthUnauthenticated) {
              return const AuthPage();
            }
            // authanticated state
            else if (state is AuthAuthenticated) {
              return const HomePage();
            } else {
              // loading state
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
          },
          // listen for state changes
          listener: (context, state) {
            if (state is AuthError) {
              final snackBar = SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          },
        ),
      ),
    );
  }
}
