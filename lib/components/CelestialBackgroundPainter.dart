import 'dart:math';
import 'package:flutter/material.dart';

class CelestialBackgroundPainter extends CustomPainter {
  final Animation<double> animation;
  final List<Star> stars;

  CelestialBackgroundPainter(this.animation, this.stars) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..style = PaintingStyle.fill;

    for (final star in stars) {
      // Calculate perspective for 3D depth effect
      double perspective = 1 / star.z; // Simulates depth
      double x = size.width / 2 + (star.position.dx - size.width / 2) * perspective;
      double y = size.height / 2 + (star.position.dy - size.height / 2) * perspective;

      // Cap star size to prevent excessively large stars when close
      double starSize = (star.size * perspective).clamp(0.3, 2.0); // Reduced max size

      // Twinkling effect using sine wave for opacity
      double opacity = 0.5 + sin(animation.value * 2 * pi * star.flickerSpeed) * 0.5;

      paint.color = Colors.white.withOpacity(opacity);

      // Draw the star
      canvas.drawCircle(Offset(x, y), starSize, paint);

      // Move the star closer to the viewer
      star.z -= star.speed;

      // Reset the star when it moves past the viewer
      if (star.z <= 0.1) {
        star.reset(size);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true; // Repaint whenever the animation changes
  }
}

class Star {
  Offset position;
  double size;
  double flickerSpeed;
  double z; // Depth coordinate
  double speed; // Movement speed toward the viewer

  Star({
    required this.position,
    required this.size,
    required this.flickerSpeed,
    required this.z,
    required this.speed,
  });

  // Reset star to a random position and depth
  void reset(Size size) {
    final Random random = Random();
    position = Offset(random.nextDouble() * size.width, random.nextDouble() * size.height);
    this.size = 0.3 + random.nextDouble() * 1.2; // Smaller initial size
    flickerSpeed = 0.5 + random.nextDouble(); // Random flicker speed
    z = 2 + random.nextDouble() * 3; // Start closer to the viewer
    speed = 0.003 + random.nextDouble() * 0.004; // Adjusted speed
  }
}

class CelestialBackground extends StatefulWidget {
  const CelestialBackground({super.key});

  @override
  _CelestialBackgroundState createState() => _CelestialBackgroundState();
}

class _CelestialBackgroundState extends State<CelestialBackground> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Star> stars;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();

    // Generate fewer stars for reduced density
    stars = _generateStars(100); // Reduced star count
  }

  // Generate a fixed number of stars
  List<Star> _generateStars(int count) {
    final Random random = Random();
    return List.generate(count, (_) {
      return Star(
        position: Offset(random.nextDouble() * 500, random.nextDouble() * 500),
        size: 0.3 + random.nextDouble() * 1.2, // Smaller initial size
        flickerSpeed: 0.5 + random.nextDouble(), // Random flicker speed
        z: 10 + random.nextDouble() * 4, // Increased starting depth
        speed: 0.003 + random.nextDouble() * 0.004, // Adjusted speed
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        for (var star in stars) {
          star.reset(Size(constraints.maxWidth, constraints.maxHeight));
        }
        return CustomPaint(
          painter: CelestialBackgroundPainter(_animationController, stars),
          child: Container(),
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

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      body: CelestialBackground(),
    ),
  ));
}
