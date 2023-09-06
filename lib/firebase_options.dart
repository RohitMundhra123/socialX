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
    apiKey: 'AIzaSyBn-7AGjW06l7QOPoWjQyJ7WUofUpulgKk',
    appId: '1:180280236952:web:e064428e0bf972715469ed',
    messagingSenderId: '180280236952',
    projectId: 'socialx-65ae5',
    authDomain: 'socialx-65ae5.firebaseapp.com',
    storageBucket: 'socialx-65ae5.appspot.com',
    measurementId: 'G-YFMPEK39PY',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDdJoiy2NttxhGtqXlQ2gLDfw5rl_ntWHM',
    appId: '1:180280236952:android:69fd192b9ca095d05469ed',
    messagingSenderId: '180280236952',
    projectId: 'socialx-65ae5',
    storageBucket: 'socialx-65ae5.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDTI2n9vAQOScg1ts0-Cben_PlErqrMjk0',
    appId: '1:180280236952:ios:306e21a0a182604f5469ed',
    messagingSenderId: '180280236952',
    projectId: 'socialx-65ae5',
    storageBucket: 'socialx-65ae5.appspot.com',
    androidClientId: '180280236952-f21vhlvabpd8cfsm5pqhshql2f08lde0.apps.googleusercontent.com',
    iosClientId: '180280236952-2shhe93ilskhce38nrf47ir8j1pgr4e9.apps.googleusercontent.com',
    iosBundleId: 'com.example.socialx',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDTI2n9vAQOScg1ts0-Cben_PlErqrMjk0',
    appId: '1:180280236952:ios:105f379d5e4d729f5469ed',
    messagingSenderId: '180280236952',
    projectId: 'socialx-65ae5',
    storageBucket: 'socialx-65ae5.appspot.com',
    androidClientId: '180280236952-f21vhlvabpd8cfsm5pqhshql2f08lde0.apps.googleusercontent.com',
    iosClientId: '180280236952-13fgfqcqi0515cceur32rib4stfbd6js.apps.googleusercontent.com',
    iosBundleId: 'com.example.socialx.RunnerTests',
  );
}