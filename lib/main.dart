import 'package:flutter/material.dart';
import 'package:strivio/screens/menu.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:strivio/screens/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => CookieRequest(),
      child: MaterialApp(
        title: 'Strivio',                     
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.pink,     
          ).copyWith(
            secondary: Colors.pinkAccent[100],
          ),
        ),
        home: LoginPage(),                   
      ),
    );
  }
}
