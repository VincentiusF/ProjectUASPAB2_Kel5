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
    apiKey: 'AIzaSyCE9wQwbxxFQ15n2KOlrBa9xc27PquKaCQ',
    appId: '1:883280094778:web:364c39150f7ddbba84b703',
    messagingSenderId: '883280094778',
    projectId: 'projectuaspab2kel5',
    authDomain: 'projectuaspab2kel5.firebaseapp.com',
    databaseURL: 'https://projectuaspab2kel5-default-rtdb.firebaseio.com',
    storageBucket: 'projectuaspab2kel5.firebasestorage.app',
    measurementId: 'G-HSY0JFVC3G',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBQLZhabwxuj2flg1h2yh18ZY2eQgiiHfE',
    appId: '1:883280094778:android:d42312ee8e0982ae84b703',
    messagingSenderId: '883280094778',
    projectId: 'projectuaspab2kel5',
    databaseURL: 'https://projectuaspab2kel5-default-rtdb.firebaseio.com',
    storageBucket: 'projectuaspab2kel5.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyABts-BKpegJXMXBcPkQnSo-WUzAyWUYS8',
    appId: '1:883280094778:ios:48ac9e62c3d9996684b703',
    messagingSenderId: '883280094778',
    projectId: 'projectuaspab2kel5',
    databaseURL: 'https://projectuaspab2kel5-default-rtdb.firebaseio.com',
    storageBucket: 'projectuaspab2kel5.firebasestorage.app',
    iosClientId: '883280094778-9mdpis155p1l9tth6unl2ge2gdegn9m3.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterApplication1',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyABts-BKpegJXMXBcPkQnSo-WUzAyWUYS8',
    appId: '1:883280094778:ios:48ac9e62c3d9996684b703',
    messagingSenderId: '883280094778',
    projectId: 'projectuaspab2kel5',
    databaseURL: 'https://projectuaspab2kel5-default-rtdb.firebaseio.com',
    storageBucket: 'projectuaspab2kel5.firebasestorage.app',
    iosClientId: '883280094778-9mdpis155p1l9tth6unl2ge2gdegn9m3.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterApplication1',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCE9wQwbxxFQ15n2KOlrBa9xc27PquKaCQ',
    appId: '1:883280094778:web:8bcc8f334b13204184b703',
    messagingSenderId: '883280094778',
    projectId: 'projectuaspab2kel5',
    authDomain: 'projectuaspab2kel5.firebaseapp.com',
    databaseURL: 'https://projectuaspab2kel5-default-rtdb.firebaseio.com',
    storageBucket: 'projectuaspab2kel5.firebasestorage.app',
    measurementId: 'G-VREFN3WJWD',
  );

}