import 'package:flutter/material.dart';

import 'casket_classes.dart';
import 'label_setup_dialog.dart';

class RulerRowPainter extends CustomPainter {
  final KernLabel _beforeLabel; // last before curr Row, not included
  final KernLabel? _afterLabel; // first after curr Row, not included

  final int _startDistance; // starting distance of row

  const RulerRowPainter(
      this._startDistance, this._beforeLabel, this._afterLabel);

  @override
  void paint(Canvas canvas, Size size) {
    // отрисовка разметки
    KernLabel currLabel = _beforeLabel;
    double currDepth = KernLabel.calcDepthBetween(
            _beforeLabel, _beforeLabel.next!, _startDistance)
        .ceilToDouble();
    final List<int> drawDistances = [];
    while (currLabel != _afterLabel) {
      final KernLabel nextLabel = currLabel.next!;
      for (double depth = currDepth; depth < nextLabel.depth; depth += 1.0) {
        //TODO: 0.5
        final int lineDistance =
            KernLabel.calcDistanceBetween(currLabel, nextLabel, depth);
        if (lineDistance > _startDistance + 100) {
          break;
        }
        drawDistances.add(lineDistance);
      }
      currLabel = nextLabel;
      currDepth = currLabel.depth.ceilToDouble();
    }

    final paint = Paint()..strokeWidth = 4;
    for (int drawDist in drawDistances) {
      final Offset top = Offset(size.width * (drawDist % 100) / 100, 0);
      final Offset bot =
          Offset(size.width * (drawDist % 100) / 100, size.height);
      canvas.drawLine(top, bot, paint);
    }

    // отрисовка чисел
    final textStyle = TextStyle(color: Colors.black, fontSize: 10);

    currLabel = _beforeLabel.next!;
    while (currLabel != _afterLabel) {
      final textPainter = TextPainter(
          text: TextSpan(text: '${currLabel.depth}🠗', style: textStyle),
          textDirection: TextDirection.ltr);
      textPainter.layout(minWidth: 0, maxWidth: size.width);
      final Offset labelPlace = Offset(
          size.width * (currLabel.distance % 100) / 100, size.height / 2);
      textPainter.paint(canvas, labelPlace);

      currLabel = currLabel.nextReal()!;
    }
  }

  @override
  bool shouldRepaint(RulerRowPainter oldDelegate) {
    return false;
  }
}

class CasketScheme extends StatefulWidget {
  final KernLabel _startFake;
  final KernLabel _endFake;
  //final int _colAmount; // TODO: настраиваемая

  const CasketScheme(this._startFake, this._endFake);
  @override
  createState() => CasketSchemeState(_startFake, _endFake);
}

class CasketSchemeState extends State<CasketScheme> {
  final KernLabel _startFake;
  final KernLabel _endFake;

  int get rowsAmount =>
      ((_endFake.distance - _startFake.distance) / 100).round();

  CasketSchemeState(this._startFake, this._endFake);

  void redrawScheme() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final scheme = <Widget>[];

    KernLabel rowStartLabel = _startFake;
    KernLabel rowEndLabel = rowStartLabel.next!;
    for (int rowDist = _startFake.distance;
        rowDist < _endFake.distance;
        rowDist += 100) {
      final tableRow = <Container>[];
      for (int cellDist = rowDist + 10;
          cellDist <= rowDist + 100;
          cellDist += 10) {
        // TODO: числа в переменные
        double toShow = KernLabel.calcDepthBetween(
            rowEndLabel.prevReal()!, rowEndLabel, cellDist);
        if (rowEndLabel.distance <= cellDist) {
          tableRow.add(Container(
              color: rowEndLabel.color,
              child: Tooltip(
                message: '$toShow',
                child:
                    CasketCellData(rowEndLabel, true, cellDist, redrawScheme),
              )));
          if (rowEndLabel.nextReal() == null) {
            break;
          }
          rowEndLabel = rowEndLabel.nextReal()!;
        } else {
          tableRow.add(Container(
              color: rowEndLabel.color,
              child: Tooltip(
                  message: '$toShow',
                  child: CasketCellData(rowEndLabel, false, cellDist,
                      redrawScheme)))); // TODO: отличия только в true/false
        }
      }

      scheme.add(Container(
          color: Colors.white,
          height: 25,
          width: double.infinity, // full width
          child: CustomPaint(
              foregroundPainter:
                  RulerRowPainter(rowDist, rowStartLabel, rowEndLabel))));
      scheme.add(Table(children: [TableRow(children: tableRow)]));
      rowStartLabel = rowEndLabel.previous!;
    }

    return Column(children: scheme);
  }
}
