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
        return android;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAz8nxggux4Qxi1MWPYAiz2beNDl-LJyqU',
    appId: '1:1058340257066:web:f38f7aff498030e77fb253',
    messagingSenderId: '1058340257066',
    projectId: 'eproject-28abb',
    authDomain: 'eproject-28abb.firebaseapp.com',
    storageBucket: 'eproject-28abb.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD74I76_oGBuajWQ7BEHdggH8uk9oAM-rE',
    appId: '1:1058340257066:android:d7de6f396d3f0fbf7fb253',
    messagingSenderId: '1058340257066',
    projectId: 'eproject-28abb',
    storageBucket: 'eproject-28abb.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDZBqPO6VENyjinUE7-GOqwxLaN0C7URcs',
    appId: '1:1058340257066:ios:44f470bef0474a267fb253',
    messagingSenderId: '1058340257066',
    projectId: 'eproject-28abb',
    storageBucket: 'eproject-28abb.firebasestorage.app',
    iosBundleId: 'com.example.bookstore',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDZBqPO6VENyjinUE7-GOqwxLaN0C7URcs',
    appId: '1:1058340257066:ios:44f470bef0474a267fb253',
    messagingSenderId: '1058340257066',
    projectId: 'eproject-28abb',
    storageBucket: 'eproject-28abb.firebasestorage.app',
    iosBundleId: 'com.example.bookstore',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAz8nxggux4Qxi1MWPYAiz2beNDl-LJyqU',
    appId: '1:1058340257066:web:56380d4def9ecf907fb253',
    messagingSenderId: '1058340257066',
    projectId: 'eproject-28abb',
    authDomain: 'eproject-28abb.firebaseapp.com',
    storageBucket: 'eproject-28abb.firebasestorage.app',
  );
}