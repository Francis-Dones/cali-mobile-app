import 'package:flutter/material.dart';
import 'view/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cebu Agua Lab',
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 2, 23, 120),
      ),
      home: const Homepage(title: 'CEBU AGUA LAB, INC.'),
    );
  }
}
