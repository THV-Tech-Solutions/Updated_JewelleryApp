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
    apiKey: 'AIzaSyBRPlOnwEoGYyZUd8CVdLR3Dw7FuwCuuQI',
    appId: '1:479124155805:web:33094b658b11b5ee3e5374',
    messagingSenderId: '479124155805',
    projectId: 'jewelleryapp-9e127',
    authDomain: 'jewelleryapp-9e127.firebaseapp.com',
    databaseURL: 'https://jewelleryapp-9e127-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'jewelleryapp-9e127.appspot.com',
    measurementId: 'G-PCYQJMBYY7',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBe-D3YJ7VXffpGMQbIUts3OOnNyNotNo0',
    appId: '1:479124155805:android:cd66e3fcf5dd8b323e5374',
    messagingSenderId: '479124155805',
    projectId: 'jewelleryapp-9e127',
    databaseURL: 'https://jewelleryapp-9e127-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'jewelleryapp-9e127.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCrcQksD93ySt_psRjKeUros3clIA_tnQE',
    appId: '1:479124155805:ios:a6e11081068702663e5374',
    messagingSenderId: '479124155805',
    projectId: 'jewelleryapp-9e127',
    databaseURL: 'https://jewelleryapp-9e127-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'jewelleryapp-9e127.appspot.com',
    iosBundleId: 'com.thvfuturistai.jewellery',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCrcQksD93ySt_psRjKeUros3clIA_tnQE',
    appId: '1:479124155805:ios:a6e11081068702663e5374',
    messagingSenderId: '479124155805',
    projectId: 'jewelleryapp-9e127',
    databaseURL: 'https://jewelleryapp-9e127-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'jewelleryapp-9e127.appspot.com',
    iosBundleId: 'com.thvfuturistai.jewellery',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBRPlOnwEoGYyZUd8CVdLR3Dw7FuwCuuQI',
    appId: '1:479124155805:web:e081083651d3329e3e5374',
    messagingSenderId: '479124155805',
    projectId: 'jewelleryapp-9e127',
    authDomain: 'jewelleryapp-9e127.firebaseapp.com',
    databaseURL: 'https://jewelleryapp-9e127-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'jewelleryapp-9e127.appspot.com',
    measurementId: 'G-P3CK023T7N',
  );
}