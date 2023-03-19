import 'package:flutter/material.dart';

class ProgressChart extends StatefulWidget {
  final List<Score> scores;

  const ProgressChart({Key? key, required this.scores}) : super(key: key);

  @override
  State<ProgressChart> createState() => _ProgressChartState();
}

class Score {
  late double value;
  late DateTime time;

  Score(this.value, this.time);
}

const weekDays = ["", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

class _ProgressChartState extends State<ProgressChart> {
  late double _min, _max;
  late List<double> _y;
  late List<String> _x;

  @override
  void initState() {
    super.initState();

    var min = double.maxFinite;
    var max = -double.maxFinite;

    for (var element in widget.scores) {
      min = min < element.value ? min : element.value;
      max = max > element.value ? max : element.value;
    }

    setState(() {
      _min = min;
      _max = max;
      _y = widget.scores.map((e) => e.value).toList();
      _x = widget.scores.map((e) => "${weekDays[e.time.weekday]}\n${e.time.day}").toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ChartPainter(_x, _y, _min, _max),
      child: Container(),
    );
  }
}

class ChartPainter extends CustomPainter {
  static double border = 10.0;
  static double radius = 5.0;

  final List<String> x;
  final List<double> y;
  final double min, max;

  ChartPainter(this.x, this.y, this.min, this.max);

  // final Color backgroundColor = Colors.black;
  final Color backgroundColor = const Color(0xFF1A1E23);

  final linePaint = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.0;

  final dotPaintFill = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.0;

  final Paint outlinePaint = Paint()
    ..strokeWidth = 1.0
    ..color = Colors.white
    ..style = PaintingStyle.stroke;

  final labelStyle = const TextStyle(
    color: Colors.white38,
    fontSize: 14,
  );

  final xLabelStyle = const TextStyle(color: Colors.white38, fontSize: 16, fontWeight: FontWeight.bold);

  @override
  void paint(Canvas canvas, Size size) {
    final clipRect = Rect.fromLTWH(0, 0, size.width, size.height);

    canvas.clipRect(clipRect);
    canvas.drawPaint(Paint()..color = backgroundColor);

    final drawableHeight = size.height - 2.0 * border;
    final drawableWidth = size.width - 2.0 * border;

    final hd = drawableHeight / 5.0;
    final wd = drawableWidth / x.length.toDouble();

    final height = hd * 3.5;
    final width = drawableWidth;

    if (height <= 0.0 || width <= 0.0) return;

    if (max - min < 1.0e-6) return;

    final hr = height / (max - min);

    final left = border;
    final top = border;
    final c = Offset(left + wd / 2.0, top + height / 2.0);

    // _drawOutline(canvas, c, wd, height);

    final points = _computePoints(c, wd, height, hr);
    final path = _computePath(points);
    final labels = _computeLabels();

    canvas.drawPath(path, linePaint);

    _drawLabels(canvas, labels, points, wd, top);
    _drawDataPoint(points, canvas, c, wd);

    final c1 = Offset(c.dx, top + 4.5 * hd);
    _drawXLabel(canvas, c1, wd);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  void _drawOutline(Canvas canvas, Offset c, double width, double height) {
    for (var _ in y) {
      final rect = Rect.fromCenter(center: c, width: width, height: height);

      canvas.drawRect(rect, outlinePaint);
      c += Offset(width, 0);
    }
  }

  List<Offset> _computePoints(Offset c, double width, double height, double hr) {
    List<Offset> points = [];

    for (var element in y) {
      final yy = height - (element - min) * hr;
      final dp = Offset(c.dx, c.dy - height / 2.0 + yy);

      points.add(dp);
      c += Offset(width, 0);
    }

    return points;
  }

  _computePath(List<Offset> points) {
    final path = Path();
    for (int i = 0; i < points.length; i++) {
      final point = points[i];

      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }

    return path;
  }

  List<String> _computeLabels() {
    return y.map((e) => e.toStringAsFixed(1)).toList();
  }

  TextPainter measureText(String text, TextStyle style, double maxWidth, TextAlign textAlign) {
    final span = TextSpan(text: text, style: style);
    final tp = TextPainter(text: span, textAlign: textAlign, textDirection: TextDirection.ltr);

    tp.layout(minWidth: 0, maxWidth: maxWidth);

    return tp;
  }

  Size drawTextCentered(Canvas canvas, Offset c, String text, TextStyle style, double maxWidth) {
    final tp = measureText(text, style, maxWidth, TextAlign.center);
    final offset = c + Offset(-tp.width / 2.0, -tp.height / 2.0);

    tp.paint(canvas, offset);
    return tp.size;
  }

  void _drawDataPoint(List<Offset> points, Canvas canvas, Offset c, double wd) {
    for (var element in points) {
      canvas.drawCircle(element, radius, dotPaintFill);
      canvas.drawCircle(element, radius, linePaint);
    }
  }

  void _drawLabels(Canvas canvas, List<String> labels, List<Offset> points, double width, double top) {
    var i = 0;
    for (var element in labels) {
      final dp = points[i];
      final dy = (dp.dy - 15.0) < top ? 15.0 : -15.0;
      final ly = dp + Offset(0, dy);

      drawTextCentered(canvas, ly, element, labelStyle, width);
      i++;
    }
  }

  void _drawXLabel(Canvas canvas, Offset offset, double wd) {
    for (var element in x) {
      drawTextCentered(canvas, offset, element, xLabelStyle, wd);

      offset += Offset(wd, 0);
    }
  }
}
