import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: ThermometerWidget(),
      ),
    );
  }
}

class Thermometer extends ImplicitlyAnimatedWidget {
  const Thermometer({
    super.key,
    super.curve,
    required this.color,
    required this.value,
    required super.duration,
    super.onEnd,
  });

  final Color color;
  final double value;

  @override
  AnimatedWidgetBaseState<Thermometer> createState() => _ThermometerState();
}

class _ThermometerState extends AnimatedWidgetBaseState<Thermometer> {
  ColorTween? _color;
  Tween<double>? _value;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: FittedBox(
        child: CustomPaint(
          size: const Size(18, 63),
          painter: _ThermometerPainter(
            color: _color!.evaluate(animation)!,
            value: _value!.evaluate(animation),
          ),
        ),
      ),
    );
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _color = visitor(_color, widget.color, (dynamic v) => ColorTween(begin: v)) as ColorTween?;
    _value =
        visitor(_value, widget.value, (dynamic v) => Tween<double>(begin: v)) as Tween<double>?;
  }
}

class _ThermometerPainter extends CustomPainter {
  _ThermometerPainter({
    required this.color,
    required this.value,
  });

  final Color color;
  final double value;

  @override
  void paint(Canvas canvas, Size size) {
    const bulbRadius = 7.5;
    const smallRadius = 2.8;
    const border = 1.8;
    final rect = (Offset.zero & size);
    final innerRect = rect.deflate(size.width / 2 - bulbRadius);
    final r1 =
        Alignment.bottomCenter.inscribe(const Size(2 * smallRadius, bulbRadius * 2), innerRect);
    final r2 = Alignment.center.inscribe(Size(2 * smallRadius, innerRect.height), innerRect);

    final bulb = Path()
      ..addOval(Alignment.bottomCenter.inscribe(Size.square(innerRect.width), innerRect));
    final outerPath = Path()
      ..addOval(
          Alignment.bottomCenter.inscribe(Size.square(innerRect.width), innerRect).inflate(border))
      ..addRRect(RRect.fromRectAndRadius(r2, const Radius.circular(smallRadius)).inflate(border));

    final valueRect = Rect.lerp(r1, r2, value)!;
    final valuePaint = Paint()..color = color;

    canvas
      ..save()
      // draw shadow
      ..drawPath(
          outerPath.shift(const Offset(1, 1)),
          Paint()
            ..color = Colors.black26
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1))
      ..clipPath(outerPath)
      // draw background
      ..drawPaint(Paint()..color = Colors.white)
      // draw foreground
      ..drawPath(bulb, valuePaint)
      ..drawRRect(
          RRect.fromRectAndRadius(valueRect, const Radius.circular(smallRadius)), valuePaint)
      ..restore();

    // debug only:

    // canvas.drawRect(rect, Paint()..color = Colors.black38);
    // canvas.drawRect(innerRect, Paint()..color = Colors.black38);
    // canvas.drawRect(valueRect, Paint()..color = Colors.black38);
    // canvas.drawRect(scaleRect, Paint()..color = Colors.black38);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class ThermometerWidget extends StatefulWidget {
  const ThermometerWidget({super.key});

  @override
  State<ThermometerWidget> createState() => _ThermometerWidgetState();
}

class _ThermometerWidgetState extends State<ThermometerWidget> {
  int i = 0;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        i++;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // return Container(
    //   color: Colors.black12,
    //   // child: Column(
    //   //   children: [
    //   //     Expanded(
    //   //       child: Stack(
    //   //         children: [
    //   //           Positioned(
    //   //             left: 25,
    //   //             top: 50,
    //   //             width: 125,
    //   //             height: 400,
    //   //             child: Card(
    //   //               elevation: 6,
    //   //               child: Thermo(
    //   //                 duration: const Duration(milliseconds: 1250),
    //   //                 color: i.isOdd ? Colors.red : Colors.green,
    //   //                 value: i.isOdd ? 0.9 : 0.1,
    //   //                 curve: Curves.easeInOut,
    //   //               ),
    //   //             ),
    //   //           ),
    //   //           Positioned(
    //   //             left: 150,
    //   //             top: 75,
    //   //             width: 50,
    //   //             height: 150,
    //   //             child: Card(
    //   //               elevation: 6,
    //   //               child: Thermo(
    //   //                 duration: const Duration(milliseconds: 1250),
    //   //                 color: i.isOdd ? Colors.indigo : Colors.teal,
    //   //                 value: i.isOdd ? 0.2 : 0.7,
    //   //                 curve: Curves.elasticOut,
    //   //               ),
    //   //             ),
    //   //           ),
    //   //           Positioned(
    //   //             left: 175,
    //   //             top: 225,
    //   //             width: 100,
    //   //             height: 200,
    //   //             child: Card(
    //   //               elevation: 6,
    //   //               child: Thermo(
    //   //                 duration: const Duration(milliseconds: 750),
    //   //                 color: i.isOdd ? Colors.orange : Colors.deepPurple,
    //   //                 value: i.isOdd ? 0.3 : 1.0,
    //   //                 curve: Curves.bounceOut,
    //   //               ),
    //   //             ),
    //   //           ),
    //   //         ],
    //   //       ),
    //   //     ),
    //   //     Padding(
    //   //       padding: const EdgeInsets.all(32.0),
    //   //       child: ElevatedButton(
    //   //         onPressed: () {
    //   //           setState(() => i++);
    //   //         },
    //   //         child: const Text('click me'),
    //   //       ),
    //   //     ),
    //   //   ],
    //   // ),
    //   child: const Center(
    //     // child: Container(
    //     //   width: MediaQuery.of(context).size.width / 2,
    //     //   height: MediaQuery.of(context).size.height / 2,
    //     //   decoration: BoxDecoration(
    //     //     color: Colors.white,
    //     //     boxShadow: [
    //     //       BoxShadow(
    //     //         offset: const Offset(0, 0),
    //     //         color: Colors.black26.withOpacity(0.4),
    //     //         blurRadius: 10,
    //     //       )
    //     //     ],
    //     //   ),
    //     //   child: Thermo(
    //     //     duration: const Duration(milliseconds: 1250),
    //     //     color: i.isOdd ? Colors.red : Colors.green,
    //     //     value: 0.6,
    //     //     curve: Curves.easeInOut,
    //     //   ),
    //     // ),
    //     // child: Thermo(
    //     //   duration: Duration(milliseconds: 1250),
    //     //   color: Color(0xFF71BF0D),
    //     //   value: 0.7,
    //     //   curve: Curves.easeInOut,
    //     // ),
    //
    //
    //   ),
    // );
    return Center(
      child: Container(
        width: 100,
        height: 300,
        decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(16)),
            boxShadow: [
              BoxShadow(
                color: Color(0xFFBFC9D7),
                offset: Offset(4, 4),
                blurRadius: 10,
              )
            ]),
        child: Stack(
          children: [
            Container(
              width: 14,
              height: 4,
              margin: const EdgeInsets.only(top: 40),
              decoration: const BoxDecoration(
                color: Color(0xFFB0B0B0),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
            ),
            Container(
              width: 14,
              height: 4,
              margin: const EdgeInsets.only(top: 70),
              decoration: const BoxDecoration(
                color: Color(0xFFB0B0B0),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
            ),
            Container(
              width: 14,
              height: 4,
              margin: const EdgeInsets.only(top: 100),
              decoration: const BoxDecoration(
                color: Color(0xFFB0B0B0),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
            ),
            Container(
              width: 14,
              height: 4,
              margin: const EdgeInsets.only(top: 130),
              decoration: const BoxDecoration(
                color: Color(0xFFB0B0B0),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
            ),
            Container(
              width: 14,
              height: 4,
              margin: const EdgeInsets.only(top: 160),
              decoration: const BoxDecoration(
                color: Color(0xFFB0B0B0),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Container(
                width: 14,
                height: 4,
                margin: const EdgeInsets.only(top: 48),
                decoration: const BoxDecoration(
                  color: Color(0xFFB0B0B0),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Container(
                width: 14,
                height: 4,
                margin: const EdgeInsets.only(top: 78),
                decoration: const BoxDecoration(
                  color: Color(0xFFB0B0B0),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Container(
                width: 14,
                height: 4,
                margin: const EdgeInsets.only(top: 108),
                decoration: const BoxDecoration(
                  color: Color(0xFFB0B0B0),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Container(
                width: 14,
                height: 4,
                margin: const EdgeInsets.only(top: 138),
                decoration: const BoxDecoration(
                  color: Color(0xFFB0B0B0),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Container(
                width: 14,
                height: 4,
                margin: const EdgeInsets.only(top: 168),
                decoration: const BoxDecoration(
                  color: Color(0xFFB0B0B0),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 20.0,
                  bottom: 50.0,
                ),
                child: Thermometer(
                  duration: const Duration(milliseconds: 1250),
                  color: const Color(0xFF71BF0D),
                  value: i % 2 == 0 ? 0.2 : 0.65,
                  curve: Curves.easeInOut,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
