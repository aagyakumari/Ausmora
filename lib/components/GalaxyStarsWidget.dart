import 'dart:math';
import 'package:flutter/material.dart';

class GalaxyStarsWidget extends StatefulWidget {
  const GalaxyStarsWidget({super.key});

  @override
  _GalaxyStarsWidgetState createState() => _GalaxyStarsWidgetState();
}

class _GalaxyStarsWidgetState extends State<GalaxyStarsWidget> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  List<Star> stars = [];

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    // Loop the animation
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.linear)
    )..addListener(() {
        setState(() {});
      });

    _animationController.repeat();

    // Generate random stars
    for (int i = 0; i < 100; i++) {
      stars.add(Star(
        position: Offset(
          Random().nextDouble() * MediaQuery.of(context).size.width,
          Random().nextDouble() * MediaQuery.of(context).size.height,
        ),
        size: Random().nextDouble() * 2 + 1, // random star size
        speed: Random().nextDouble() * 2 + 1, // random speed for movement
      ));
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: GalaxyPainter(stars, _animation.value),
    );
  }
}

class Star {
  Offset position;
  double size;
  double speed;

  Star({
    required this.position,
    required this.size,
    required this.speed,
  });

  void move(double progress) {
    // Move stars closer with respect to the progress of animation
    position = Offset(
      position.dx + (progress * speed),
      position.dy + (progress * speed),
    );
  }
}

class GalaxyPainter extends CustomPainter {
  final List<Star> stars;
  final double progress;

  GalaxyPainter(this.stars, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.white.withOpacity(0.7);

    // Draw each star
    for (Star star in stars) {
      star.move(progress);

      // Draw the star as a circle
      canvas.drawCircle(star.position, star.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Keep repainting for the animation
  }
}
