import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  List<Particle> particles = [];
  late Animation<double> animation;
  late AnimationController animationController;

  Color getRandomColor(Random random) {
    var a = random.nextInt(255);
    var r = random.nextInt(255);
    var g = random.nextInt(255);
    var b = random.nextInt(255);

    return Color.fromARGB(a, r, g, b);
  }

  final random = Random(100);
  final maxRadius = 6;
  final maxSpeed = 0.2;
  final maxTheta = 2.0 * pi;

  @override
  void initState() {
    super.initState();

    particles = List.generate(100, (index) {
      var p = Particle(const Offset(-1, -1), getRandomColor(random), random.nextDouble() * maxSpeed,
          random.nextDouble() * maxTheta, random.nextDouble() * maxRadius);

      return p;
    });

    animationController = AnimationController(vsync: this, duration: const Duration(seconds: 10));
    animation = Tween<double>(begin: 0, end: 300).animate(animationController)
      ..addListener(() {
        setState(() {});
      })
    ..addStatusListener((status) {
      if(status == AnimationStatus.completed) {
        animationController.repeat();
      } else if(status == AnimationStatus.dismissed) {
        animationController.forward();
      }
    });

    animationController.forward();

    // for (int i = 0; i < 100; i++) {
    //   particles.add(Particle(const Offset(0, 0), getRandomColor(), Random(100).nextDouble() * maxSpeed,
    //       Random(100).nextDouble() * maxTheta, Random(100).nextDouble() * maxRadius));
    // }
  }

  @override
  void dispose() {
    super.dispose();

    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomPaint(
      painter: PainterCanvas(particles: particles),
      child: Container(),
    ));
  }
}

class Particle {
  Offset position;
  Color color;
  double speed;
  double theta;
  double radius;

  Particle(this.position, this.color, this.speed, this.theta, this.radius);
}

class PainterCanvas extends CustomPainter {
  List<Particle> particles;

  PainterCanvas({required this.particles});

  Offset polarToCartesian(double speed, double theta) {
    return Offset(speed * cos(theta), speed * sin(theta));
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (var element in particles) {
      var velocity = polarToCartesian(element.speed, element.theta);
      var dy = element.position.dy + velocity.dx;
      var dx = element.position.dx + velocity.dy;

      if (element.position.dx < 0 || element.position.dx > size.width) {
        dx = Random(100).nextDouble() * size.width;
      }

      if (element.position.dy < 0 || element.position.dy > size.height) {
        dy = Random(100).nextDouble() * size.height;
      }

      element.position = Offset(dx, dy);
    }

    for (var element in particles) {
      var paint = Paint()..color = Colors.red;
      canvas.drawCircle(element.position, element.radius, paint);
    }

    // var dx = size.width / 2;
    // var dy = size.height / 2;
    //
    // Offset c = Offset(dx, dy);
    // var radius = 100.0;
    // var paint = Paint()..color = Colors.red;
    //
    // canvas.drawCircle(c, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
