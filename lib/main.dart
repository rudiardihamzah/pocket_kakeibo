import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pocket_kakeibo/pages/root.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('localBox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const RootScreen(),
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
    );
  }
}
