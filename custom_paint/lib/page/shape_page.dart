import 'package:flutter/material.dart';

class ShapePage extends StatelessWidget {
  const ShapePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width * 0.85,
        height: MediaQuery.of(context).size.width * 0.8,
        child: CustomPaint(
          painter: CustomObjectPainter(const LinearGradient(
              colors: [Color(0xFF92D81A), Color(0xFF66990C)], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        ),
      ),
    );
  }
}

class CustomObjectPainter extends CustomPainter {
  final Gradient gradient;

  CustomObjectPainter(this.gradient);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    final radius = size.width * 0.1;
    final paint = Paint();
    final rect = Rect.fromPoints(size.topLeft(Offset.zero), size.bottomRight(Offset(-size.width * 0.1, 0)));
    paint.shader = gradient.createShader(rect);

    final rrect = RRect.fromRectAndCorners(rect, bottomLeft: Radius.circular(radius), bottomRight: Radius.circular(radius));
    canvas.drawRRect(rrect, paint);

    final width = size.width * 0.2;
    final height = size.height * 0.2;

    final topMargin = size.height * 0.1;
    final smallRect =
        Rect.fromCenter(center: Offset(size.width * 0.9, topMargin + height / 2), width: width, height: height);
    final smallRRect = RRect.fromRectAndRadius(smallRect, Radius.circular(radius / 4));
    canvas.drawRRect(smallRRect, paint);
    paint.style = PaintingStyle.stroke;
    paint.shader = null;
    paint.color = Colors.white;
    paint.strokeWidth = 5;
    canvas.drawRRect(smallRRect, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return !(oldDelegate is CustomObjectPainter && oldDelegate.gradient == gradient);
  }
}
