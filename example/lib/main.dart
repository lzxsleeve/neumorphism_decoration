import 'dart:io';

import 'package:example/page/home_page.dart';
import 'package:example/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  //沉浸式状态栏
  if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  }

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
