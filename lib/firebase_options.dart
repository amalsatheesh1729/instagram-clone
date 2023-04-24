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
    apiKey: 'AIzaSyBcNA8kgAnAc3GCjdG3SJDNCQcrSn_aBAE',
    appId: '1:1042127817804:web:7faf48ac978aae41bfb8e9',
    messagingSenderId: '1042127817804',
    projectId: 'instagram-clone-43bb4',
    authDomain: 'instagram-clone-43bb4.firebaseapp.com',
    storageBucket: 'instagram-clone-43bb4.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA_0d7JUZCm0PMAC7mh5mnFS8UiA2pk3fs',
    appId: '1:1042127817804:android:7568ddb4429d73eebfb8e9',
    messagingSenderId: '1042127817804',
    projectId: 'instagram-clone-43bb4',
    storageBucket: 'instagram-clone-43bb4.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyANVhUPbQCVirTOTp4qdxaTint_T-YPNG0',
    appId: '1:1042127817804:ios:523d2073bc6733bbbfb8e9',
    messagingSenderId: '1042127817804',
    projectId: 'instagram-clone-43bb4',
    storageBucket: 'instagram-clone-43bb4.appspot.com',
    iosClientId: '1042127817804-oaa9qbd6gnhqmplrdk83em2ihhjnbf9n.apps.googleusercontent.com',
    iosBundleId: 'com.example.instagramClone',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyANVhUPbQCVirTOTp4qdxaTint_T-YPNG0',
    appId: '1:1042127817804:ios:523d2073bc6733bbbfb8e9',
    messagingSenderId: '1042127817804',
    projectId: 'instagram-clone-43bb4',
    storageBucket: 'instagram-clone-43bb4.appspot.com',
    iosClientId: '1042127817804-oaa9qbd6gnhqmplrdk83em2ihhjnbf9n.apps.googleusercontent.com',
    iosBundleId: 'com.example.instagramClone',
  );
}
