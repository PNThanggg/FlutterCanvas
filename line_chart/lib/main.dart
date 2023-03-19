import 'dart:math';

import 'package:flutter/material.dart';

import 'progress_chart.dart';

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
      home: const MyHomePage(title: 'Line Chart'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

const dayCount = 7;
final random = Random();

class _MyHomePageState extends State<MyHomePage> {
  List<Score> _scores = [];

  @override
  void initState() {
    super.initState();

    final scores = List<Score>.generate(dayCount, (index) {
      final y = random.nextDouble() * 100.0;
      final dateTime = DateTime.now().add(Duration(days: -dayCount + index));

      return Score(y, dateTime);
    });

    setState(() {
      _scores = scores;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111111),
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.red,
        child: SizedBox(
          height: 150,
          child: ProgressChart(scores: _scores),
        ),
      ),
    );
  }
}
