library neumorphism_decoration;

import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class NeumorphismDecoration extends StatefulWidget {
  final Widget? child;
  final NeumorphismColors neumorphismColors;
  final double radius;
  final double bevel;
  final NeumorphismStyle style;
  final Function()? onTap;

  const NeumorphismDecoration({
    Key? key,
    this.child,
    this.neumorphismColors = const NeumorphismColors(),
    this.radius = 16.0,
    this.bevel = 4.0,
    this.style = NeumorphismStyle.auto,
    this.onTap,
  }) : super(key: key);

  @override
  _NeumorphismDecorationState createState() => _NeumorphismDecorationState();
}

class _NeumorphismDecorationState extends State<NeumorphismDecoration> with SingleTickerProviderStateMixin {
  AnimationController? _aController;
  Animation<double>? _animation;

  void _onPointerDown(PointerDownEvent event) {
    _aController?.forward();
  }

  void _onPointerUp(PointerUpEvent event) {
    _aController?.reverse();
    widget.onTap?.call();
  }

  @override
  void initState() {
    super.initState();
    if (widget.style == NeumorphismStyle.auto) {
      // 创建 AnimationController 对象
      _aController = AnimationController(vsync: this, duration: const Duration(milliseconds: 150));
      // 通过 Tween 对象 创建 Animation 对象
      _animation = Tween(begin: 0.0, end: 1.0).animate(_aController!)
        ..addListener(() {
          setState(() {});
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    Color color = widget.neumorphismColors.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor;
    return Listener(
      onPointerDown: _onPointerDown,
      onPointerUp: _onPointerUp,
      child: CustomPaint(
        painter: NeumorphismPainter(
          color: color,
          neumorphismColors: widget.neumorphismColors,
          animationValue: _getAnimationValue(),
          bevel: widget.bevel,
          radius: widget.radius,
        ),
        child: widget.child,
      ),
    );
  }

  double _getAnimationValue() {
    if (widget.style == NeumorphismStyle.concave) {
      return 1;
    } else if (widget.style == NeumorphismStyle.convex) {
      return 0;
    } else {
      return _animation!.value;
    }
  }
}

class NeumorphismPainter extends CustomPainter {
  final Color color; //填充颜色
  final NeumorphismColors? neumorphismColors; //填充颜色
  final double radius;
  final double animationValue;
  final double bevel;

  late Color _outerShadowColor;
  late Color _outerLightColor;
  late Color _innerShadowColor;
  late Color _innerLightColor;

  NeumorphismPainter({
    required this.color,
    this.radius = 0,
    this.neumorphismColors,
    this.animationValue = 1.0,
    this.bevel = 6,
  }) {
    _outerShadowColor = neumorphismColors?.outerShadowColor ?? color.mix(const Color(0xFFCCCCCC), .6);
    _outerLightColor = neumorphismColors?.outerLightColor ?? color.mix(Colors.white, .9);
    _innerShadowColor = neumorphismColors?.innerShadowColor ?? _outerShadowColor;
    _innerLightColor = neumorphismColors?.innerLightColor ?? _outerLightColor;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width == 0 || size.height == 0) return;

    drawConvex(canvas, size);

    if (animationValue > 0) {
      drawConcave(canvas, size);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  /// 绘制凸起样式
  void drawConvex(Canvas canvas, Size size) {
    var rect1 = Rect.fromLTWH(-bevel, -bevel, size.width, size.height);
    var rect2 = Rect.fromLTWH(bevel, bevel, size.width, size.height);
    var rect3 = Rect.fromLTWH(0, 0, size.width, size.height);

    var lightPaint = Paint()
      ..color = _outerLightColor
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, bevel)
      ..isAntiAlias = true;

    var shadowPaint = Paint()
      ..color = _outerShadowColor
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, bevel)
      ..isAntiAlias = true;

    var bgPaint = Paint()
      ..color = color
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, .5)
      ..isAntiAlias = true;

    // 外层高亮
    canvas.drawRRect(RRect.fromRectAndRadius(rect1, Radius.circular(radius)), lightPaint);
    // 外层阴影
    canvas.drawRRect(RRect.fromRectAndRadius(rect2, Radius.circular(radius)), shadowPaint);
    // 填充背景色
    canvas.drawRRect(RRect.fromRectAndRadius(rect3, Radius.circular(radius)), bgPaint);
  }

  /// 绘制凹陷样式
  void drawConcave(Canvas canvas, Size size) {
    final List<Color> shadowColors = [
      _innerShadowColor,
      _innerShadowColor.withAlpha(0x00),
    ];

    final List<Color> lightColors = [
      _innerLightColor,
      _innerLightColor.withAlpha(0x00),
    ];

    var rect4 = Rect.fromCenter(center: Offset(size.width / 2, size.height / 2), width: size.width - 4, height: size.height - 4);

    var space = (bevel + 2) * animationValue;
    var rect5 = Rect.fromCenter(center: Offset(size.width / 2, size.height / 2), width: size.width - 4 - space, height: size.height - 4 - space);

    var distance = _computeDiagonalDistance(rect4);
    var offset = _computeDiagonalCoordinate(rect4, distance);

    var paint = Paint()
      ..isAntiAlias = true
      ..color = color;

    // 内阴影部分
    paint.shader = ui.Gradient.linear(
      Offset.zero,
      offset,
      shadowColors,
      [0.8, 1.0],
    );
    canvas.drawRRect(RRect.fromRectAndRadius(rect4, Radius.circular(radius)), paint);

    // 内阴影高亮部分
    paint.shader = ui.Gradient.linear(
      Offset(size.width, size.height),
      Offset(size.width - offset.dx, size.height - offset.dy),
      lightColors,
      [0.8, 1.0],
    );
    canvas.drawRRect(RRect.fromRectAndRadius(rect4, Radius.circular(radius)), paint);

    // 居中的模糊背景，与上面的阴影部分组成内阴影样式
    paint.maskFilter = MaskFilter.blur(BlurStyle.normal, bevel * animationValue);
    paint.shader = null;
    canvas.drawRRect(RRect.fromRectAndRadius(rect5, Radius.circular(radius)), paint);
  }

  /// 顶点到对角线的距离
  double _computeDiagonalDistance(Rect rect) {
    double w = rect.width;
    double h = rect.height;
    return w * h / math.sqrt(w * w + h * h);
  }

  /// 顶点到对角线的相交点坐标
  Offset _computeDiagonalCoordinate(Rect rect, double s) {
    double w = rect.width;
    double h = rect.height;
    double x = s * s / w;
    double y = s * s / h;
    return Offset(x, y);
  }
}

/// 由于要适配所有背景色太困难，所以开放给非默认背景色的颜色配置
class NeumorphismColors {
  /// 背景颜色
  final Color? backgroundColor;

  /// 外阴影
  final Color? outerShadowColor;

  /// 外高亮
  final Color? outerLightColor;

  /// 内阴影
  final Color? innerShadowColor;

  /// 内高亮
  final Color? innerLightColor;

  const NeumorphismColors({
    this.backgroundColor,
    this.outerShadowColor,
    this.outerLightColor,
    this.innerShadowColor,
    this.innerLightColor,
  });
}

/// 新拟态类型
enum NeumorphismStyle {
  auto,
  concave,
  convex,
}

extension ColorUtils on Color {
  /// Linearly interpolate between two colors.
  Color mix(Color? another, double amount) {
    return Color.lerp(this, another, amount)!;
  }
}
