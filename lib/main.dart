import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_project/app.dart';
import 'package:flutter_social_project/config/firebase_options.dart';


void main() async {
  // firebase setup
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // GetIt.instance.registerLazySingleton(() => FirebaseAuth.instance);
  runApp(MyApp());
}
