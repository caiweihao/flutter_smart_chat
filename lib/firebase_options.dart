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
    apiKey: 'AIzaSyCoRph3ewxMZraBSZSeoagelhzTwyQzhNE',
    appId: '1:60146773770:web:039b9b8a8873a452e614f3',
    messagingSenderId: '60146773770',
    projectId: 'fir-chat-274f7',
    authDomain: 'fir-chat-274f7.firebaseapp.com',
    storageBucket: 'fir-chat-274f7.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDaumbJpWxmhn2T9jmTpcCMdwe8H1dKVw0',
    appId: '1:60146773770:android:fb30616091a9ee19e614f3',
    messagingSenderId: '60146773770',
    projectId: 'fir-chat-274f7',
    storageBucket: 'fir-chat-274f7.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAFWB5gHMeCWuDjcM7vv02oSHPbvL7c1SI',
    appId: '1:60146773770:ios:23a98d43358cd1aee614f3',
    messagingSenderId: '60146773770',
    projectId: 'fir-chat-274f7',
    storageBucket: 'fir-chat-274f7.firebasestorage.app',
    iosBundleId: 'com.example.flutterSmartChat',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAFWB5gHMeCWuDjcM7vv02oSHPbvL7c1SI',
    appId: '1:60146773770:ios:23a98d43358cd1aee614f3',
    messagingSenderId: '60146773770',
    projectId: 'fir-chat-274f7',
    storageBucket: 'fir-chat-274f7.firebasestorage.app',
    iosBundleId: 'com.example.flutterSmartChat',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCoRph3ewxMZraBSZSeoagelhzTwyQzhNE',
    appId: '1:60146773770:web:edbe33293a4d3fade614f3',
    messagingSenderId: '60146773770',
    projectId: 'fir-chat-274f7',
    authDomain: 'fir-chat-274f7.firebaseapp.com',
    storageBucket: 'fir-chat-274f7.firebasestorage.app',
  );
}
