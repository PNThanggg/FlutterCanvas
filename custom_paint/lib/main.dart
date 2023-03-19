import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'page/arc_paint_page.dart';
import 'page/circle_paint_page.dart';
import 'page/image_paint_page.dart';
import 'page/line_paint_page.dart';
import 'page/rectangle_paint_page.dart';
import 'page/rounded_rectangle_page.dart';
import 'page/shape_page.dart';
import 'page/triangle_paint_page.dart';
import 'widget/tabbar_widget.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static const String title = 'Custom Paint';

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(primarySwatch: Colors.deepOrange, scaffoldBackgroundColor: Colors.black),
        home: const MainPage(),
      );
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) => const TabBarWidget(
        title: MyApp.title,
        tabs: [
          Tab(icon: Icon(Icons.stacked_line_chart), text: 'Line'),
          Tab(icon: Icon(Icons.crop_landscape), text: 'Rectangle'),
          Tab(icon: Icon(Icons.crop_square), text: 'Rounded Rectangle'),
          Tab(icon: Icon(Icons.circle), text: 'Circle'),
          Tab(icon: Icon(Icons.architecture), text: 'Arc'),
          Tab(icon: Icon(Icons.warning), text: 'Triangle'),
          Tab(icon: Icon(Icons.image), text: 'Image'),
          Tab(
            icon: Icon(Icons.add),
            text: "Shape",
          )
        ],
        children: [
          LinePaintPage(),
          RectanglePaintPage(),
          RoundedRectanglePaintPage(),
          CirclePaintPage(),
          ArcPaintPage(),
          TrianglePaintPage(),
          ImagePaintPage(),
          ShapePage(),
        ],
      );
}
