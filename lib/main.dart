import 'package:e_fecta/presentation/common/login/login_screen.dart';
import 'package:e_fecta/presentation/plays/play_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const EfectaApp());
}

class EfectaApp extends StatelessWidget {
  const EfectaApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'e-Fecta',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const LoginScreen(),
    );
  }
}
