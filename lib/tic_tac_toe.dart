import 'package:flutter/material.dart';
import 'package:neurolog_flutter_demo/resources/resources.dart';

const Map<int, ImageProvider<Object>> imgs = {
  0: AssetImage(Images.empty),
  1: AssetImage(Images.x),
  2: AssetImage(Images.o),
};

class TicTacToeMain extends StatefulWidget {
  const TicTacToeMain({Key? key}) : super(key: key);

  @override
  _TicTacToeMainState createState() => _TicTacToeMainState();
}

class _TicTacToeMainState extends State<TicTacToeMain> {
  int cell_0 = 0;
  int cell_1 = 0;
  int cell_2 = 0;
  int cell_3 = 0;
  int cell_4 = 0;
  int cell_5 = 0;
  int cell_6 = 0;
  int cell_7 = 0;
  int cell_8 = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Table(
        border: TableBorder.all(width: 2),
        columnWidths: const <int, TableColumnWidth>{
          0: IntrinsicColumnWidth(),
          1: IntrinsicColumnWidth(),
          2: IntrinsicColumnWidth(),
        },
        children: [
          TableRow(
            children: [
              InkWell(
                child: Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: imgs[cell_0] ?? AssetImage(Images.empty),
                    ),
                  ),
                ),
                onTap: () => setState(() {
                  cell_0 = (cell_0 + 1) % 3;
                }),
              ),
              InkWell(
                child: Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: imgs[cell_1] ?? AssetImage(Images.empty),
                    ),
                  ),
                ),
                onTap: () => setState(() {
                  cell_1 = (cell_1 + 1) % 3;
                }),
              ),
              InkWell(
                child: Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: imgs[cell_2] ?? AssetImage(Images.empty),
                    ),
                  ),
                ),
                onTap: () => setState(() {
                  cell_2 = (cell_2 + 1) % 3;
                }),
              ),
            ],
          ),
          TableRow(
            children: [
              InkWell(
                child: Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: imgs[cell_3] ?? AssetImage(Images.empty),
                    ),
                  ),
                ),
                onTap: () => setState(() {
                  cell_3 = (cell_3 + 1) % 3;
                }),
              ),
              InkWell(
                child: Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: imgs[cell_4] ?? AssetImage(Images.empty),
                    ),
                  ),
                ),
                onTap: () => setState(() {
                  cell_4 = (cell_4 + 1) % 3;
                }),
              ),
              InkWell(
                child: Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: imgs[cell_5] ?? AssetImage(Images.empty),
                    ),
                  ),
                ),
                onTap: () => setState(() {
                  cell_5 = (cell_5 + 1) % 3;
                }),
              ),
            ],
          ),
          TableRow(
            children: [
              InkWell(
                child: Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: imgs[cell_6] ?? AssetImage(Images.empty),
                    ),
                  ),
                ),
                onTap: () => setState(() {
                  cell_6 = (cell_6 + 1) % 3;
                }),
              ),
              InkWell(
                child: Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: imgs[cell_7] ?? AssetImage(Images.empty),
                    ),
                  ),
                ),
                onTap: () => setState(() => cell_7 = (cell_7 + 1) % 3),
              ),
              InkWell(
                child: Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: imgs[cell_8] ?? AssetImage(Images.empty),
                    ),
                  ),
                ),
                onTap: () => setState(() => cell_8 = (cell_8 + 1) % 3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Cell extends StatefulWidget {
  Cell({Key? key, required this.onTap, this.child}) : super(key: key);

  Function onTap;
  Widget? child;

  @override
  _CellState createState() => _CellState();
}

class _CellState extends State<Cell> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        height: 150,
        width: 150,
        child: widget.child ?? Image(image: AssetImage(Images.empty)),
      ),
      onTap: () => widget.onTap,
    );
  }
}
