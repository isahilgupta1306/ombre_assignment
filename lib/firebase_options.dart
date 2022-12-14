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
    apiKey: 'AIzaSyCH8wzQaYTpH_qcTX_tHptORG58L34rtHg',
    appId: '1:635853560635:web:9d021f1679dd96d425751e',
    messagingSenderId: '635853560635',
    projectId: 'ombre-assignment',
    authDomain: 'ombre-assignment.firebaseapp.com',
    storageBucket: 'ombre-assignment.appspot.com',
    measurementId: 'G-NZRG7LMBCB',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCJkDWQ81xKKfIR_1PDfY_WYymV_ykUIiQ',
    appId: '1:635853560635:android:2e3af363720302ea25751e',
    messagingSenderId: '635853560635',
    projectId: 'ombre-assignment',
    storageBucket: 'ombre-assignment.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBhkxKZWay_aWS9iKDdyJcqmjDGriyTtyg',
    appId: '1:635853560635:ios:f132fea18114349a25751e',
    messagingSenderId: '635853560635',
    projectId: 'ombre-assignment',
    storageBucket: 'ombre-assignment.appspot.com',
    androidClientId: '635853560635-las8rio1qboj507k23p7da213pn9rrdg.apps.googleusercontent.com',
    iosClientId: '635853560635-99a74b41g95np09l66b5ietleq9m0a9h.apps.googleusercontent.com',
    iosBundleId: 'com.example.ombreAssignment',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBhkxKZWay_aWS9iKDdyJcqmjDGriyTtyg',
    appId: '1:635853560635:ios:f132fea18114349a25751e',
    messagingSenderId: '635853560635',
    projectId: 'ombre-assignment',
    storageBucket: 'ombre-assignment.appspot.com',
    androidClientId: '635853560635-las8rio1qboj507k23p7da213pn9rrdg.apps.googleusercontent.com',
    iosClientId: '635853560635-99a74b41g95np09l66b5ietleq9m0a9h.apps.googleusercontent.com',
    iosBundleId: 'com.example.ombreAssignment',
  );
}
