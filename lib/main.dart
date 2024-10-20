import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_project/app.dart';
import 'package:flutter_social_project/firebase_options.dart';
import 'package:get_it/get_it.dart';

/*
APP – Root Level
---------------------------------------------------

Repositories: for the database
  - firebase

Bloc Providers: for state management
  - auth
  - profile
  - post
  - search
  - theme

Check Auth State
  - unauthenticated -> auth page (login/register)
  - authenticated -> home page
*/


void main() async {
  // firebase setup
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // GetIt.instance.registerLazySingleton(() => FirebaseAuth.instance);
  runApp(MyApp());
}
