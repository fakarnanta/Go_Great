// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDeWBZzNlRaA61B5vjsM2_d636dIRITfYw',
    appId: '1:382893431102:web:264c26c5f68aac3583746f',
    messagingSenderId: '382893431102',
    projectId: 'go-great-a4850',
    authDomain: 'go-great-a4850.firebaseapp.com',
    storageBucket: 'go-great-a4850.appspot.com',
    measurementId: 'G-RVEKWGND99',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCspjwPbrwOGb4roa_CaJRjPHhSX8l0NY8',
    appId: '1:382893431102:android:7f77f7bc69b0c6d083746f',
    messagingSenderId: '382893431102',
    projectId: 'go-great-a4850',
    storageBucket: 'go-great-a4850.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAv8kEeBBLQCs_LMg8U6fWPqP3s3z8B3t8',
    appId: '1:382893431102:ios:b744faf4581b4c5483746f',
    messagingSenderId: '382893431102',
    projectId: 'go-great-a4850',
    storageBucket: 'go-great-a4850.appspot.com',
    iosBundleId: 'com.example.goGreat',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAv8kEeBBLQCs_LMg8U6fWPqP3s3z8B3t8',
    appId: '1:382893431102:ios:374b3042edf37e1083746f',
    messagingSenderId: '382893431102',
    projectId: 'go-great-a4850',
    storageBucket: 'go-great-a4850.appspot.com',
    iosBundleId: 'com.example.goGreat.RunnerTests',
  );
}