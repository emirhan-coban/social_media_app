#!/usr/bin/env python3
"""
Script to generate google-services.json from .env file
Run this script whenever you clone the project or update .env file
"""

import json
import os
from pathlib import Path

def load_env():
    """Load environment variables from .env file"""
    env_vars = {}
    env_path = Path('.env')
    
    if not env_path.exists():
        print("❌ Error: .env file not found!")
        print("   Please copy .env.example to .env and fill in your values")
        return None
    
    with open(env_path, 'r') as f:
        for line in f:
            line = line.strip()
            if line and not line.startswith('#'):
                if '=' in line:
                    key, value = line.split('=', 1)
                    env_vars[key.strip()] = value.strip()
    
    return env_vars

def generate_google_services_json(env_vars):
    """Generate google-services.json from environment variables"""
    google_services = {
        "project_info": {
            "project_number": env_vars.get('FIREBASE_ANDROID_PROJECT_NUMBER', ''),
            "project_id": env_vars.get('FIREBASE_ANDROID_PROJECT_ID', ''),
            "storage_bucket": env_vars.get('FIREBASE_ANDROID_STORAGE_BUCKET', '')
        },
        "client": [
            {
                "client_info": {
                    "mobilesdk_app_id": env_vars.get('FIREBASE_ANDROID_MOBILE_SDK_APP_ID', ''),
                    "android_client_info": {
                        "package_name": "com.example.social_media_app"
                    }
                },
                "oauth_client": [],
                "api_key": [
                    {
                        "current_key": env_vars.get('FIREBASE_ANDROID_API_KEY', '')
                    }
                ],
                "services": {
                    "appinvite_service": {
                        "other_platform_oauth_client": []
                    }
                }
            }
        ],
        "configuration_version": "1"
    }
    
    return google_services

def main():
    env_vars = load_env()
    if not env_vars:
        return
    
    google_services = generate_google_services_json(env_vars)
    output_path = Path('android/app/google-services.json')
    
    with open(output_path, 'w') as f:
        json.dump(google_services, f, indent=2)
    
    print(f"✅ Successfully generated {output_path}")

if __name__ == '__main__':
    main()
