import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData darkMode = ThemeData(
  fontFamily: GoogleFonts.montserrat().fontFamily,
  colorScheme: ColorScheme.dark(
    primary: Colors.grey.shade500,
    secondary: const Color.fromARGB(255, 48, 48, 48),
    tertiary: const Color.fromARGB(255, 20, 20, 20),
    inversePrimary: const Color.fromARGB(255, 238, 238, 238),
  ),
  scaffoldBackgroundColor: Colors.grey.shade900,
);
