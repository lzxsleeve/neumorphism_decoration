import 'package:example/page/home_page.dart';
import 'package:example/res/colors.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: Colours.backgroundColor,
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}
