import 'package:flutter/material.dart';
import 'package:veritabani_uygulamasi/view/filmler_sayfasi.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 25,
          ),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const FilmlerSayfasi(),
    );
  }
}
