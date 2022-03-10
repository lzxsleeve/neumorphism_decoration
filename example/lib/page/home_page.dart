import 'package:example/page/calculators_page.dart';
import 'package:example/page/simple_example_page.dart';
import 'package:example/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:neumorphism_decoration/neumorphism_decoration.dart';

/// 主页 Create by zxliu on 2022/3/8

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colours.backgroundColor,
        foregroundColor: Colours.textDeep,
        title: const Text('Flutter Demo'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: NeumorphismDecoration(
              child: Container(
                height: 64,
                alignment: Alignment.center,
                child: const Text('测试', style: TextStyle(fontSize: 16)),
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const SimpleExamplePage()));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: NeumorphismDecoration(
              child: Container(
                height: 64,
                alignment: Alignment.center,
                child: const Text('计算机', style: TextStyle(fontSize: 16)),
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const CalculatorsPage()));
              },
            ),
          ),
        ],
      ),
    );
  }
}
