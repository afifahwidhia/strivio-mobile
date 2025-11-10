import 'package:flutter/material.dart';
import 'package:strivio/screens/menu.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Strivio',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.pink,
        ).copyWith(
          secondary: Colors.pinkAccent[100],
        ),
        useMaterial3: true, 
      ),
      home: MyHomePage(),
    );
  }
}
