import 'dart:typed_data';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http_parser/http_parser.dart';
import 'package:neurolog_flutter_demo/resources/resources.dart';
import 'package:neurolog_flutter_demo/tic_tac_toe.dart';

const double canvasSize = 200.0;

final Paint drawingPaint = Paint()
  ..strokeCap = StrokeCap.round
  ..isAntiAlias = true
  ..color = Colors.black
  ..strokeWidth = 18.0;

void main() => runApp(MyApp());

class DrawingPainter extends CustomPainter {
  List<Offset> offsetPoints;

  DrawingPainter({required this.offsetPoints});

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < offsetPoints.length - 1; i++) {
      if (offsetPoints[i] != Offset.zero &&
          offsetPoints[i + 1] != Offset.zero) {
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
      // home: MyHomePage(),
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
  String sum = "";
  int sumOrTtt = 0;
  bool _feedbackGiven = false;
  bool _negativeFeedbackGiven = false;

  final _textController = TextEditingController();
  bool _validInputSum = true;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _resetAll() {
    digit1 = [];
    digit2 = [];
    sum = "";
    _feedbackGiven = false;
    _validInputSum = true;
    _negativeFeedbackGiven = false;
    _textController.clear();
  }

  bool _bothDigitsFilled() => digit1.isNotEmpty && digit2.isNotEmpty;

  bool _sumCalculated() => sum.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      // appBar: AppBar(title: Text(widget.title)),
      body: sumOrTtt == 0
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Spacer(),
                  // Image(image: AssetImage(Images.brainNetwork), height: 100),
                  // Text(
                  //   'NeuroLog',
                  //   style: TextStyle(
                  //     fontFeatures: [FontFeature.enable('smcp')],
                  //     color: Colors.blue,
                  //     fontSize: 60,
                  //     letterSpacing: .5,
                  //   ),
                  // ),
                  Text(
                    'NeuroLog',
                    style: GoogleFonts.vt323(
                      textStyle: TextStyle(
                        color: Colors.blue,
                        fontFeatures: [FontFeature.enable('smcp')],
                        letterSpacing: .5,
                        fontSize: 80,
                      ),
                    ),
                  ),
                  Text(
                    "A Neural-Symbolic System",
                    style: GoogleFonts.vt323(
                      textStyle: TextStyle(
                        // color: Colors.blue,
                        letterSpacing: .5,
                        fontSize: 30,
                      ),
                    ),
                  ),
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
                                setState(
                                  () {
                                    RenderBox renderBox =
                                        context.findRenderObject() as RenderBox;
                                    digit1.add(renderBox
                                        .globalToLocal(details.globalPosition));
                                  },
                                );
                              },
                              // mark end with Offset.zero
                              onPanEnd: (details) => digit1.add(Offset.zero),
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
                                setState(() {
                                  RenderBox renderBox =
                                      context.findRenderObject() as RenderBox;
                                  digit2.add(renderBox
                                      .globalToLocal(details.globalPosition));
                                });
                              },
                              onPanEnd: (details) => digit2.add(Offset.zero),
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
                        child: sum.isNotEmpty
                            ? Center(
                                child: Text(
                                  sum,
                                  style: GoogleFonts.vt323(
                                    textStyle: TextStyle(
                                      letterSpacing: .5,
                                      fontSize: 100,
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                      ),
                      const SizedBox(width: 20),
                      SizedBox(
                        height: 200.0,
                        width: 200.0,
                        child: AnimatedCrossFade(
                          duration: const Duration(milliseconds: 200),
                          crossFadeState: _sumCalculated()
                              ? CrossFadeState.showSecond
                              : CrossFadeState.showFirst,
                          firstChild: SizedBox(
                            // empty box
                            height: 200.0,
                            width: 200.0,
                          ),
                          secondChild: !_feedbackGiven
                              ? AnimatedCrossFade(
                                  duration: const Duration(milliseconds: 200),
                                  crossFadeState: !_negativeFeedbackGiven
                                      ? CrossFadeState.showFirst
                                      : CrossFadeState.showSecond,
                                  firstChild: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "How did the system do?",
                                        style: GoogleFonts.vt323(
                                          textStyle: TextStyle(
                                            letterSpacing: .5,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                            icon: FaIcon(
                                              FontAwesomeIcons.check,
                                              color: Colors.green,
                                            ),
                                            onPressed: _sumCalculated()
                                                ? () {
                                                    setState(() =>
                                                        _feedbackGiven = true);
                                                  }
                                                : null,
                                          ),
                                          const SizedBox(height: 20),
                                          IconButton(
                                            icon: FaIcon(
                                              FontAwesomeIcons.times,
                                              color: Colors.red,
                                            ),
                                            onPressed: _sumCalculated()
                                                ? () {
                                                    setState(() {
                                                      _negativeFeedbackGiven =
                                                          true;
                                                    });
                                                  }
                                                : null,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  secondChild: SizedBox(
                                    // negative feedback here
                                    height: 200.0,
                                    width: 200.0,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Help the system learn by providing "
                                          "the correct answer!",
                                          style: GoogleFonts.vt323(
                                            textStyle: TextStyle(
                                              letterSpacing: .5,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        TextField(
                                          controller: _textController,
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'[0-9]')),
                                          ],
                                          decoration: InputDecoration(
                                            helperText:
                                                "Enter a value between 0-18.",
                                            errorText: !_validInputSum
                                                ? "Must be a value between 0-18!"
                                                : null,
                                            border: OutlineInputBorder(),
                                            helperStyle: GoogleFonts.vt323(
                                              textStyle: TextStyle(
                                                letterSpacing: .5,
                                                fontSize: 12,
                                              ),
                                            ),
                                            errorStyle: GoogleFonts.vt323(
                                              textStyle: TextStyle(
                                                letterSpacing: .5,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          style: GoogleFonts.vt323(
                                            textStyle: TextStyle(
                                              letterSpacing: .5,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () =>
                                                  setState(() => _resetAll()),
                                              child: Text(
                                                "CANCEL & RETRY",
                                                style: GoogleFonts.vt323(
                                                  textStyle: TextStyle(
                                                    letterSpacing: .5,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            ElevatedButton(
                                              onPressed: () {
                                                setState(() {
                                                  var text =
                                                      _textController.text;
                                                  if (text.isNotEmpty) {
                                                    var intVal =
                                                        int.tryParse(text) ??
                                                            -1;
                                                    print("INTVAL $intVal");

                                                    if (0 <= intVal &&
                                                        intVal <= 18) {
                                                      text = intVal.toString();
                                                    } else {
                                                      text = "";
                                                    }
                                                  }
                                                  print("TEXT $text");
                                                  if (text.isNotEmpty) {
                                                    _textController.clear();
                                                    _feedbackGiven = true;
                                                  } else {
                                                    _validInputSum = false;
                                                  }
                                                });
                                              },
                                              child: Text(
                                                "SUBMIT",
                                                style: GoogleFonts.vt323(
                                                  textStyle: TextStyle(
                                                    letterSpacing: .5,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Center(
                                  // TODO here add reset button
                                  child: Text(
                                    "Thanks for the feedback!\n\nYour response "
                                    "will be used to re-train and improve the "
                                    "system.",
                                    style: GoogleFonts.vt323(
                                      textStyle: TextStyle(
                                        letterSpacing: .5,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        label: Text(
                          "RESET",
                          style: GoogleFonts.vt323(
                            textStyle: TextStyle(
                              // color: Colors.blue,
                              letterSpacing: .5,
                              fontSize: 25,
                            ),
                          ),
                        ),
                        icon: FaIcon(FontAwesomeIcons.redo),
                        onPressed: () => setState(() => _resetAll()),
                      ),
                      const SizedBox(width: 30),
                      Tooltip(
                        message: _bothDigitsFilled()
                            ? "Calculate answer!"
                            : "Please write numbers first!",
                        child: ElevatedButton.icon(
                          label: Text(
                            "CALCULATE",
                            style: GoogleFonts.vt323(
                              textStyle: TextStyle(
                                // color: Colors.blue,
                                letterSpacing: .5,
                                fontSize: 25,
                              ),
                            ),
                          ),
                          icon: FaIcon(FontAwesomeIcons.brain),
                          onPressed: _bothDigitsFilled()
                              ? () async {
                                  if (digit1.isNotEmpty && digit2.isNotEmpty) {
                                    var res = await Future.wait([
                                      digit1,
                                      digit2
                                    ].map((points) => convertToImg(points)))
                                        .then((imgs) => callNl(imgs));
                                    if (res.statusCode == 200) {
                                      setState(() => sum =
                                          (res.data['digit1.png'] +
                                                  res.data['digit2.png'])
                                              .toString());
                                      print(res.data);
                                    }
                                  }
                                }
                              : null, // this disables button when digits empty
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                          child: Image(
                              image: AssetImage(Images.oucLogo), height: 80),
                          onTap: () => print("tap")),
                      InkWell(
                        child: Image(
                            image: AssetImage(Images.cclabLogo), height: 80),
                        onTap: () {},
                      ),
                      Image(
                          image: AssetImage(Images.mariSenseLogo), height: 80),
                      // TODO add url links when clicking images
                      //  TODO add link to github repo, build with Flutter
                    ],
                  ),
                ],
              ),
            )
          : TicTacToeMain(),
      floatingActionButton: FloatingActionButton.extended(
        label: sumOrTtt == 0
            ? Text("Switch to Tic-Tac-Toe")
            : Text("Switch to Sum"),
        icon: sumOrTtt == 0
            ? FaIcon(FontAwesomeIcons.borderAll)
            : FaIcon(FontAwesomeIcons.plus),
        onPressed: () => setState(() => sumOrTtt = (sumOrTtt + 1) % 2),
      ),
    );
  }
}

Future<Response> callNl(List<Uint8List> imgs) async {
  var dio = Dio(
    BaseOptions(
      // baseUrl: 'http://0.0.0.0:8000/',
      baseUrl: 'https://neurolog-demo-backend.herokuapp.com',
      responseType: ResponseType.json,
    ),
  );
  var formData = FormData();
  formData.files.addAll(
    [
      MapEntry(
        'files',
        MultipartFile.fromBytes(
          imgs[0],
          filename: "digit1.png",
          contentType: MediaType("image", "png"),
        ),
      ),
      MapEntry(
        'files',
        MultipartFile.fromBytes(
          imgs[1],
          filename: "digit2.png",
          contentType: MediaType("image", "png"),
        ),
      ),
    ],
  );
  return await dio.post("/deduce", data: formData);
}

Future<Uint8List> convertToImg(List<Offset> points) async {
  final recorder = PictureRecorder();
  final canvas = Canvas(
    recorder,
    Rect.fromPoints(Offset(0.0, 0.0), Offset(canvasSize, canvasSize)),
  );

  canvas.drawRect(
    Rect.fromLTWH(0, 0, canvasSize, canvasSize),
    Paint()..color = Colors.white,
  );

  for (int i = 0; i < points.length - 1; i++) {
    if (points[i] != Offset.zero && points[i + 1] != Offset.zero) {
      canvas.drawLine(points[i], points[i + 1], drawingPaint);
    }
  }

  final picture = recorder.endRecording();
  final img = await picture.toImage(canvasSize.toInt(), canvasSize.toInt());
  final imgBytes = await img.toByteData(format: ImageByteFormat.png);
  Uint8List pngUint8List = imgBytes!.buffer.asUint8List();
  return pngUint8List;
}
