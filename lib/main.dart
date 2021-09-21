import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:neurolog_flutter_demo/resources/resources.dart';

const double canvasSize = 200.0;

final Paint drawingPaint = Paint()
  ..strokeCap = StrokeCap.round
  ..isAntiAlias = true
  ..color = Colors.black
  ..strokeWidth = 12.0;

void main() => runApp(MyApp());

class DrawingPainter extends CustomPainter {
  List<Offset> offsetPoints;

  DrawingPainter({required this.offsetPoints});

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < offsetPoints.length - 1; i++) {
      if (offsetPoints[i] != null && offsetPoints[i + 1] != null) {
        canvas.drawLine(offsetPoints[i], offsetPoints[i + 1], drawingPaint);
      }
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) => true;
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NeuroLog: A Neural-Symbolic System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(title: 'NeuroLog'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Offset> digit1 = [];
  List<Offset> digit2 = [];

  void _resetDigits() {
    digit1 = [];
    digit2 = [];
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      // appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Spacer(),
            // Image(image: AssetImage(Images.brainNetwork), height: 100),
            Text(
              'NeuroLog',
              style: TextStyle(
                fontFeatures: [FontFeature.enable('smcp')],
                color: Colors.blue,
                fontSize: 60,
                letterSpacing: .5,
              ),
            ),
            Text('A Neural-Symbolic System', style: TextStyle(fontSize: 30)),
            Spacer(),
            Row(
              children: [
                Spacer(),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 2.0, color: Colors.blue),
                  ),
                  child: Builder(
                    builder: (BuildContext context) {
                      return GestureDetector(
                        onPanUpdate: (details) {
                          setState(
                            () {
                              RenderBox renderBox =
                                  context.findRenderObject() as RenderBox;
                              digit1.add(renderBox
                                  .globalToLocal(details.globalPosition));
                            },
                          );
                        },
                        onPanStart: (details) {
                          print("start");
                          setState(
                            () {
                              RenderBox renderBox =
                                  context.findRenderObject() as RenderBox;
                              digit1.add(renderBox
                                  .globalToLocal(details.globalPosition));
                            },
                          );
                        },
                        onPanEnd: (details) {
                          print(details.toString());
                          print("end");
                        },
                        child: ClipRect(
                          child: CustomPaint(
                            size: Size(canvasSize, canvasSize),
                            painter: DrawingPainter(offsetPoints: digit1),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 30),
                FaIcon(FontAwesomeIcons.plus, size: size.width / 15),
                const SizedBox(width: 30),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 2.0, color: Colors.blue),
                  ),
                  child: Builder(
                    builder: (BuildContext context) {
                      return GestureDetector(
                        onPanUpdate: (details) {
                          setState(
                            () {
                              RenderBox renderBox =
                                  context.findRenderObject() as RenderBox;
                              digit2.add(renderBox
                                  .globalToLocal(details.globalPosition));
                            },
                          );
                        },
                        onPanStart: (details) {
                          print("start");
                          setState(() {
                            RenderBox renderBox =
                                context.findRenderObject() as RenderBox;
                            digit2.add(renderBox
                                .globalToLocal(details.globalPosition));
                          });
                        },
                        onPanEnd: (details) {
                          print("end");
                        },
                        child: ClipRect(
                          child: CustomPaint(
                            size: Size(canvasSize, canvasSize),
                            painter: DrawingPainter(offsetPoints: digit2),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 30),
                FaIcon(FontAwesomeIcons.equals, size: size.width / 15),
                const SizedBox(width: 30),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 2.0, color: Colors.blue),
                  ),
                  width: canvasSize,
                  height: canvasSize,
                ),
                Spacer(),
              ],
            ),
            Spacer(),
            ElevatedButton.icon(
              onPressed: () => setState(() => _resetDigits()),
              icon: FaIcon(FontAwesomeIcons.redo),
              label: Text("Reset"),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(image: AssetImage(Images.oucLogo), height: 80),
                Image(image: AssetImage(Images.cclabLogo), height: 80),
                Image(image: AssetImage(Images.mariSenseLogo), height: 80),
                // TODO add url links when clicking images
                //  TODO add link to github repo, build with Flutter
              ],
            ),
          ],
        ),
      ),
    );
  }
}
