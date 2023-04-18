import 'package:flutter/material.dart';

import '../data_classes/kern_label.dart';
import '../label_setup_dialog.dart';

class RulerRowPainter extends CustomPainter {
  final KernLabel _beforeLabel; // last before curr Row, not included
  final KernLabel? _afterLabel; // first after curr Row, not included - can be null for cut row

  final int _startDistance; // starting distance of row

  const RulerRowPainter(this._startDistance, this._beforeLabel, this._afterLabel);

  @override
  void paint(Canvas canvas, Size size) {
    // отрисовка разметки
    KernLabel currLabel = _beforeLabel;
    double currDepth = KernLabel.calcDepthBetween(_beforeLabel, _beforeLabel.nextReal()!, _startDistance).ceilToDouble();
    final List<int> drawDistances = [];
    while (currLabel != _afterLabel) {
      if (currLabel.nextReal() == null) {
        break;
      }
      final KernLabel nextLabel = currLabel.nextReal()!;
      for (double depth = currDepth; depth < nextLabel.depth; depth += 1.0) {
        //TODO: 0.5
        final int lineDistance = KernLabel.calcDistanceBetween(currLabel, nextLabel, depth);
        if (lineDistance > _startDistance + 100) {
          break;
        }
        drawDistances.add(lineDistance);
      }
      currLabel = nextLabel;
      currDepth = currLabel.depth.ceilToDouble();
    }

    final paint = Paint()..strokeWidth = 2;
    for (int drawDist in drawDistances) {
      final Offset top = Offset(size.width * (drawDist % 100) / 100, 0);
      final Offset bot = Offset(size.width * (drawDist % 100) / 100, size.height);
      canvas.drawLine(top, bot, paint);
    }

    // отрисовка чисел
    const textStyle = TextStyle(color: Colors.black, fontSize: 15);

    currLabel = _beforeLabel.nextReal()!;
    while (currLabel != _afterLabel) {
      final textPainter = TextPainter(text: TextSpan(text: currLabel.depth.toStringAsFixed(2), style: textStyle), textDirection: TextDirection.ltr);
      textPainter.layout(minWidth: 0, maxWidth: size.width);
      final Offset labelPlace = Offset(size.width * (currLabel.distance % 100) / 100, size.height / 2);
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

  int get rowsAmount => ((_endFake.distance - _startFake.distance) / 100).round();

  CasketSchemeState(this._startFake, this._endFake);

  void redrawScheme() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final scheme = <Widget>[];

    KernLabel rowStartLabel = _startFake.prevReal()!;
    KernLabel? rowEndLabel = rowStartLabel.nextReal();

    KernLabel remembrance = rowStartLabel; //TODO: по нормальному

    for (int rowDist = _startFake.distance; rowDist < _endFake.distance; rowDist += 100) {
      final tableRow = <Container>[];
      for (int cellDist = rowDist + 10; cellDist <= rowDist + 100; cellDist += 10) {
        // TODO: числа в переменные
        if (rowEndLabel == null) {
          tableRow.add(Container(child: CasketCellData(remembrance, false, cellDist, redrawScheme)));
          continue;
        }

        String toShow = KernLabel.calcDepthBetween(rowEndLabel.prevReal()!, rowEndLabel, cellDist).toStringAsFixed(2);
        if (rowEndLabel.distance <= cellDist) {
          tableRow.add(Container(
              decoration: BoxDecoration(border: Border.all(color: Colors.black), color: rowEndLabel.color),
              child: Tooltip(
                message: '$toShow',
                child: CasketCellData(rowEndLabel, true, cellDist, redrawScheme),
              )));

          if (rowEndLabel.nextReal() == null) {
            remembrance = rowEndLabel;
          }

          rowEndLabel = rowEndLabel.nextReal();
        } else {
          tableRow.add(Container(
              color: rowEndLabel.color, child: Tooltip(message: '$toShow', child: CasketCellData(rowEndLabel.prevReal()!, false, cellDist, redrawScheme))));
        }
      }

      scheme.add(Container(
          color: Colors.white,
          height: 25,
          width: double.infinity,
          child: CustomPaint(foregroundPainter: RulerRowPainter(rowDist, rowStartLabel, rowEndLabel))));
      scheme.add(Table(children: [TableRow(children: tableRow)]));

      rowStartLabel = (rowEndLabel == null ? remembrance : rowEndLabel.previous!);
    }

    return Column(children: scheme);
  }
}
/// Tooltip
/// End
/// конец