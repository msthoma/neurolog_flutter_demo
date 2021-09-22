import 'dart:typed_data';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

  void _resetDigits() {
    digit1 = [];
    digit2 = [];
    sum = "";
  }

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
                  Text(
                    'NeuroLog',
                    style: TextStyle(
                      fontFeatures: [FontFeature.enable('smcp')],
                      color: Colors.blue,
                      fontSize: 60,
                      letterSpacing: .5,
                    ),
                  ),
                  Text('A Neural-Symbolic System',
                      style: TextStyle(fontSize: 30)),
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
                                  style: TextStyle(fontSize: 80),
                                ),
                              )
                            : Container(),
                      ),
                      Spacer(),
                    ],
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        label: Text("Reset"),
                        icon: FaIcon(FontAwesomeIcons.redo),
                        onPressed: () => setState(() => _resetDigits()),
                      ),
                      const SizedBox(width: 30),
                      ElevatedButton.icon(
                        label: Text("Calculate"),
                        icon: FaIcon(FontAwesomeIcons.brain),
                        onPressed: () async {
                          if (digit1.isNotEmpty && digit2.isNotEmpty) {
                            var res = await Future.wait([digit1, digit2]
                                    .map((points) => convertToImg(points)))
                                .then((imgs) => callNl(imgs));
                            if (res.statusCode == 200) {
                              setState(() => sum = (res.data['digit1.png'] +
                                      res.data['digit2.png'])
                                  .toString());
                              print(res.data);
                            }
                          }
                        },
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
      floatingActionButton: FloatingActionButton(
        child: FaIcon(FontAwesomeIcons.sync),
        onPressed: () => setState(() => sumOrTtt = (sumOrTtt + 1) % 2),
      ),
    );
  }
}

Future<Response> callNl(List<Uint8List> imgs) async {
  // print(Uri.http("0.0.0.0:8000", "/process"));
  //
  // var res = await http.get(Uri.http("0.0.0.0:8000", "/process"));
  // print(res.statusCode);
  // print(jsonDecode(res.body));
  // print(res.body);

  var dio = Dio(
    BaseOptions(
      // baseUrl: 'http://0.0.0.0:8000/',
      baseUrl: 'https://neurolog-demo-backend.herokuapp.com',
      responseType: ResponseType.json,
    ),
  );
  var formData = FormData();
  formData.files.addAll([
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
  ]);
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

  // // String to uri
  // Uri uri = Uri.parse('http://0.0.0.0:8000/deduce');
  //
  // // create multipart request
  // http.MultipartRequest request = http.MultipartRequest("POST", uri);
  //
  // http.MultipartFile multipartFile = http.MultipartFile.fromBytes(
  //   'img',
  //   pngUint8List,
  //   filename: '${DateTime.now().millisecondsSinceEpoch}.jpg',
  //   contentType: MediaType("image", "jpg"),
  // );
  //
  // request.fields['FieldName'] = "img";
  // request.files.add(multipartFile);
  //
  // var response = await request.send();
  // print(response.statusCode);
}
