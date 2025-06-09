import 'package:flutter/foundation.dart'; // untuk BindingBase.debugZoneErrorsAreFatal
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_1/pages/login.dart';
import 'package:flutter_application_1/firebase_options.dart';

void main() async {
  BindingBase.debugZoneErrorsAreFatal = true; // aktifkan pengecekan zona fatal

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wine App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: const LoginPage(),
    );
  }
}
