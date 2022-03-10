import 'package:example/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:neumorphism_decoration/neumorphism_decoration.dart';

/// 示例 Create by zxliu on 2022/3/8

class SimpleExamplePage extends StatefulWidget {
  const SimpleExamplePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SimpleExampleState();
  }
}

class _SimpleExampleState extends State<SimpleExamplePage> {
  @override
  Widget build(BuildContext context) {
    const backgroundColorDark = Color(0xFF2E333B);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colours.backgroundColor,
        foregroundColor: Colours.textDeep,
        title: const Text('示例'),
      ),
      body: Column(
        children: [
          Expanded(
              flex: 1,
              child: Container(
                color: Colours.backgroundColor,
                alignment: Alignment.center,
                child: const NeumorphismDecoration(
                  bevel: 6,
                  child: SizedBox(
                    width: 120,
                    height: 120,
                  ),
                ),
              )),
          Expanded(
              flex: 1,
              child: Container(
                color: backgroundColorDark,
                alignment: Alignment.center,
                child: NeumorphismDecoration(
                  bevel: 6,
                  neumorphismColors: NeumorphismColors(
                    backgroundColor: backgroundColorDark,
                    outerLightColor: Color.lerp(Colors.grey[600], backgroundColorDark, 0.8)!,
                    outerShadowColor: Color.lerp(Colors.black45, backgroundColorDark, 0.8)!,
                  ),
                  child: const SizedBox(width: 120, height: 120),
                ),
              )),
        ],
      ),
    );
  }
}
