import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class BreathingCircleButton extends StatefulWidget {
  const BreathingCircleButton({Key? key,required this.onTap,required this.size}) : super(key: key);
  final VoidCallback onTap;
  final Size size;

  @override
  State<BreathingCircleButton> createState() => _BreathingCircleButtonState();
}

class _BreathingCircleButtonState extends State<BreathingCircleButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _ctrl.repeat();

  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: widget.onTap,
      child: CustomPaint(
        size: widget.size,
        painter: CircleButtonPainter(_ctrl),
      ),
    );
  }
}

class CircleButtonPainter extends CustomPainter {
  Animation<double> animation;

  CircleButtonPainter(this.animation) : super(repaint: animation);

  final Animatable<double> rotateTween = Tween<double>(begin: 0, end: 2 * pi)
      .chain(CurveTween(curve: Curves.easeIn));

  final Animatable<double> breatheTween = TweenSequence<double>(
    <TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0, end: 4),
        weight: 1,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 4, end: 0),
        weight: 1,
      ),
    ],
  ).chain(CurveTween(curve: Curves.decelerate));

  @override
  void paint(Canvas canvas, Size size) {
    // 将画布的原点移动到画布中心
    canvas.translate(size.width / 2, size.height / 2);

    // 设置绘制圆形的画笔
    final Paint paint = Paint()
      ..strokeWidth = 1  // 边框宽度
      ..style = PaintingStyle.stroke;  // 绘制边框

    // 绘制两个圆形路径并取其差集
    Path circlePath = Path()
      ..addOval(Rect.fromCenter(center: const Offset(0, 0), width: 100, height: 100));
    Path circlePath2 = Path()
      ..addOval(
          Rect.fromCenter(center: const Offset(-1, 0), width: 100, height: 100));
    Path result =
        Path.combine(PathOperation.difference, circlePath, circlePath2);

    // 设置颜色渐变和位置
    List<Color> colors = [
      const Color(0xFFF60C0C), const Color(0xFFF3B913), const Color(0xFFE7F716),
      const Color(0xFF3DF30B), const Color(0xFF0DF6EF), const Color(0xFF0829FB), const Color(0xFFB709F4), 
    ];
    colors.addAll(colors.reversed.toList());  // 将颜色倒序排列
    final List<double> pos =
        List.generate(colors.length, (index) => index / colors.length);  // 生成颜色渐变位置

    // 设置渐变填充
    paint.shader =
        ui.Gradient.sweep(Offset.zero, colors, pos, TileMode.clamp, 0, 2 * pi);

    // 设置边框的遮罩效果
    paint.maskFilter =
        MaskFilter.blur(BlurStyle.solid, breatheTween.evaluate(animation));

    // 绘制圆形边框
    canvas.drawPath(circlePath, paint);

    // 保存画布当前状态并旋转画布
    canvas.save();
    canvas.rotate(animation.value * 2 * pi);

    // 设置填充颜色并绘制差集路径
    paint
      ..style = PaintingStyle.fill  // 绘制填充
      ..color = const Color(0xff00abf2);
    paint.shader=null;
    canvas.drawPath(result, paint);

    // 恢复画布之前的状态
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CircleButtonPainter oldDelegate) =>
      oldDelegate.animation != animation;
}
