import 'dart:math';
import 'package:flutter/material.dart';

class NebulaBackgroundPainter extends CustomPainter {
  final Animation<double> animation;

  NebulaBackgroundPainter(this.animation) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.blue.withOpacity(0.1); // Light nebula color

    // Draw multiple nebula clouds with slight variations
    _drawNebula(canvas, size, paint, offset: Offset(animation.value * 20, 0), radius: 300);
    _drawNebula(canvas, size, paint, offset: Offset(-animation.value * 30, 50), radius: 250);
    _drawNebula(canvas, size, paint, offset: Offset(animation.value * 10, 100), radius: 350);
  }

  void _drawNebula(Canvas canvas, Size size, Paint paint, {required Offset offset, required double radius}) {
    final double fade = 0.5 + sin(animation.value * 2 * pi * 0.1) * 0.5; // Nebula flicker effect
    paint.color = paint.color.withOpacity(fade);
    canvas.drawCircle(size.center(offset), radius, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class NebulaBackground extends StatefulWidget {
  const NebulaBackground({super.key});

  @override
  _NebulaBackgroundState createState() => _NebulaBackgroundState();
}

class _NebulaBackgroundState extends State<NebulaBackground> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat(); // Loop the animation
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomPaint(
          painter: NebulaBackgroundPainter(_animationController),
          size: Size(constraints.maxWidth, constraints.maxHeight),
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

