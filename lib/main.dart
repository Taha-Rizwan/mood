import 'package:flutter/material.dart';
import 'package:mood/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mood',
      theme: ThemeData(
        fontFamily: 'Satoshi',
        textTheme: Theme.of(context).textTheme.apply(
            bodyColor: const Color(0xffEEEEEE),
            displayColor: const Color(0xffEEEEEE),
            fontFamily: 'Satoshi'),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
