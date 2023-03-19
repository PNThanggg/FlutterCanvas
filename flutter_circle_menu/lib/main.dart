import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Circle Menu'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int count = 8;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 300,
              height: 300,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: const Size(350, 350),
                    painter: CircleCustomPaint(count),
                  ),
                  Center(child: getWidgets(count, const Size(300, 300)))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CircleCustomPaint extends CustomPainter {
  final int count;

  CircleCustomPaint(this.count);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.color = Colors.red;
    Paint paint1 = Paint();
    paint1.color = Colors.white;
    paint1.strokeWidth = 2;
    paint1.style = PaintingStyle.stroke;
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), size.height / 2, paint);

    Path path = Path();

    path.moveTo(size.width / 2, size.height / 2);
    for (var i = 0; i < count; i++) {
      var o = (2 * i * math.pi) / count;
      var x = 150 * math.cos(o) + (size.width / 2);
      var y = 150 * math.sin(o) + (size.height / 2);
      path.lineTo(x, y);
      path.moveTo(size.width / 2, size.height / 2);
    }

    canvas.drawPath(path, paint1);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

Widget getWidgets(int count, Size size) {
  List<Widget> list = [];

  for (var i = 0; i < count; i++) {
    var o = (2 * i * math.pi) / count;
    o = o + ((360 / count) / 57.2958) / 2;
    var x = (size.width / 3) * math.cos(o) + (size.width / 2);
    var y = (size.width / 3) * math.sin(o) + (size.height / 2);

    list.add(Positioned.fromRect(
      rect: Rect.fromCenter(center: Offset(x, y), height: 60, width: 60),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              if (kDebugMode) {
                print("Index $i");
              }
            },
            child: const SizedBox(
              width: 60,
              height: 60,
              child: Icon(Icons.man, size: 60),
            ),
          ),
        ],
      ),
    ));
  }

  return Container(
    width: 300,
    height: 300,
    alignment: Alignment.center,
    child: Stack(
      children: list,
    ),
  );
}
