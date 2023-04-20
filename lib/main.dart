import 'package:adv_11am_firebase_app/views/screens/home_page.dart';
import 'package:adv_11am_firebase_app/views/screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'login_page',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.orangeAccent,
      ),
      routes: {
        '/': (context) => const HomePage(),
        'login_page': (context) => const LoginPage(),
      },
    ),
  );
}
