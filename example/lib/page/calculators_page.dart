import 'package:example/res/colors.dart';
import 'package:example/res/gaps.dart';
import 'package:flutter/material.dart';
import 'package:neumorphism_decoration/neumorphism_decoration.dart';

/// 计算器页面 Create by zxliu on 2021/1/7

class CalculatorsPage extends StatefulWidget {
  const CalculatorsPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CalculatorsState();
}

class _CalculatorsState extends State<CalculatorsPage> {
  double _btnHeight = 0;

  String _inputText = '0';
  String _resultText = '';
  String _operateText = '';
  bool _isResult = false;

  final TextEditingController _editingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      setState(() {
        final size = MediaQuery.of(context).size;
        final width = size.width;
        _btnHeight = (width - 96) / 4;
      });
      _editingController.text = _inputText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colours.backgroundColor,
        foregroundColor: Colours.textDeep,
        title: const Text('计算器'),
      ),
      body: _btnHeight == 0
          ? Gaps.empty
          : Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    child: NeumorphismDecoration(
                      style: NeumorphismStyle.concave,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        alignment: Alignment.bottomRight,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            TextField(
                              controller: _editingController,
                              textAlign: TextAlign.end,
                              enabled: false,
                              showCursor: true,
                              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 32, color: Color(0xFF5C7AAA)),
                              decoration: const  InputDecoration(
                                counterText: '',
                                contentPadding: EdgeInsets.all(0),
                                isDense: true,
                                border: InputBorder.none,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      _buildButton(
                        text: 'C',
                        onTap: () {
                          _inputText = '0';
                          _resultText = '';
                          _isResult = false;
                          _operateText = '';
                          _refreshInputResult();
                          setState(() {});
                        },
                      ),
                      _buildButton(
                        text: '+/-',
                        onTap: () {
                          if (_inputText.startsWith('-')) {
                            _inputText = _inputText.substring(1);
                          } else {
                            _inputText = '-$_inputText';
                          }
                          _refreshInputResult();
                        },
                      ),
                      _buildButton(
                        text: '%',
                        onTap: () {
                          double d = _value2Double(_inputText);
                          _isResult = true;
                          _inputText = '${d / 100.0}';
                          _refreshInputResult();
                        },
                      ),
                      _buildLightButton(text: '÷', onTap: () => onClickOperator('÷'), isSelect: _operateText == '÷'),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      _buildButton(text: '7', onTap: () => onClickNumber('7')),
                      _buildButton(text: '8', onTap: () => onClickNumber('8')),
                      _buildButton(text: '9', onTap: () => onClickNumber('9')),
                      _buildLightButton(text: '×', onTap: () => onClickOperator('×'), isSelect: _operateText == '×'),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      _buildButton(text: '4', onTap: () => onClickNumber('4')),
                      _buildButton(text: '5', onTap: () => onClickNumber('5')),
                      _buildButton(text: '6', onTap: () => onClickNumber('6')),
                      _buildLightButton(text: '+', onTap: () => onClickOperator('+'), isSelect: _operateText == '+'),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      _buildButton(text: '1', onTap: () => onClickNumber('1')),
                      _buildButton(text: '2', onTap: () => onClickNumber('2')),
                      _buildButton(text: '3', onTap: () => onClickNumber('3')),
                      _buildLightButton(text: '-', onTap: () => onClickOperator('-'), isSelect: _operateText == '-'),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      _buildButton(text: '0', flex: 2, onTap: () => onClickNumber('0')),
                      _buildButton(text: '.', onTap: () => onClickNumber('.')),
                      _buildLightButton(text: '=', onTap: () => _calculationResults()),
                    ],
                  ),
                ),
                Gaps.vGap32
              ],
            ),
    );
  }

  Expanded _buildButton({required String text, Function()? onTap, int flex = 1, Widget? child}) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: NeumorphismDecoration(
          onTap: onTap,
          child: Container(
            height: _btnHeight,
            alignment: Alignment.center,
            child: child ??
                Text(
                  text,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 26,
                    color: Color(0xFF5C7AAA),
                  ),
                ),
          ),
        ),
      ),
    );
  }

  Expanded _buildLightButton({required String text, Function()? onTap, bool isSelect = false}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: NeumorphismDecoration(
          onTap: onTap,
          style: isSelect ? NeumorphismStyle.concave : NeumorphismStyle.auto,
          neumorphismColors: const NeumorphismColors(
            backgroundColor: Color(0xFF76AEFF),
            innerLightColor: Color(0xFF8DBBFF),
            innerShadowColor: Color(0xFF6C9ADE),
            outerLightColor: Color(0xFFF1F7FF),
          ),
          child: Container(
            height: _btnHeight,
            alignment: Alignment.center,
            child: Text(
              text,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 26,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onClickOperator(String str) {
    _isResult = false;
    _operateText = str;

    setState(() {});
  }

  void onClickNumber(String str) {
    if (_isResult) {
      _inputText = str;
    }
    if (_operateText.isNotEmpty && _resultText.isEmpty) {
      _resultText = _inputText;
      _inputText = '';
    }
    _inputText += str;
    if (_inputText.startsWith('0')) {
      _inputText = _inputText.substring(1);
    }

    _refreshInputResult();
  }

  /// 计算结果
  void _calculationResults() {
    print('_calculationResults text=$_inputText, result=$_resultText,operate=$_operateText');
    if (_resultText.isEmpty) return;
    double d = _value2Double(_resultText);
    double d1 = _value2Double(_inputText);
    switch (_operateText) {
      case '+':
        _inputText = '${d + d1}';
        break;
      case '-':
        _inputText = '${d - d1}';
        break;
      case '×':
        _inputText = '${d * d1}';
        break;
      case '÷':
        _inputText = '${d / d1}';
        break;
    }
    _resultText = '';
    _isResult = true;
    _operateText = '';

    if (_inputText.endsWith('.0')) {
      _inputText = _inputText.replaceAll('.0', '');
    }

    _refreshInputResult();
    setState(() {});
  }

  double _value2Double(String value) {
    if (_inputText.startsWith('-')) {
      String s = value.substring(1);
      return double.parse(s) * -1;
    } else {
      return double.parse(value);
    }
  }

  /// 刷新输入结果
  void _refreshInputResult() {
    _editingController.text = _inputText;
    var textSelection = TextSelection.fromPosition(TextPosition(affinity: TextAffinity.downstream, offset: _inputText.length));
    _editingController.selection = textSelection;
  }
}
