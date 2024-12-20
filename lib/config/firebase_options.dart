// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for android - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBd97CWVmQN-rgn3UBLSHy-UEWxGs2MPCo',
    appId: '1:31177213497:ios:1a19afcb5115a87af6afe8',
    messagingSenderId: '31177213497',
    projectId: 'flutter-social-project-aee80',
    storageBucket: 'flutter-social-project-aee80.appspot.com',
    iosBundleId: 'com.wallas.socialmedia.flutterSocialProject',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAYIGN-B6F4vvfCOwn4gqpN8Dh0ag6LACU',
    appId: '1:31177213497:web:46bb4ef0b6e67dc4f6afe8',
    messagingSenderId: '31177213497',
    projectId: 'flutter-social-project-aee80',
    authDomain: 'flutter-social-project-aee80.firebaseapp.com',
    storageBucket: 'flutter-social-project-aee80.appspot.com',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAYIGN-B6F4vvfCOwn4gqpN8Dh0ag6LACU',
    appId: '1:31177213497:web:46bb4ef0b6e67dc4f6afe8',
    messagingSenderId: '31177213497',
    projectId: 'flutter-social-project-aee80',
    authDomain: 'flutter-social-project-aee80.firebaseapp.com',
    storageBucket: 'flutter-social-project-aee80.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBd97CWVmQN-rgn3UBLSHy-UEWxGs2MPCo',
    appId: '1:31177213497:ios:1a19afcb5115a87af6afe8',
    messagingSenderId: '31177213497',
    projectId: 'flutter-social-project-aee80',
    storageBucket: 'flutter-social-project-aee80.appspot.com',
    iosBundleId: 'com.wallas.socialmedia.flutterSocialProject',
  );

}