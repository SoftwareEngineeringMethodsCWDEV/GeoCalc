import 'package:flutter/material.dart';

import '../label_setup_dialog.dart';
import '../data_classes/label.dart';

class RulerRowPainter extends CustomPainter {
  final Label _beforeLabel; // last before curr Row (not fake)
  final Label? _afterLabel; // first after curr Row (not fake)

  final int _startDistance; // starting distance of row

  const RulerRowPainter(this._startDistance, this._beforeLabel, this._afterLabel);

  @override
  void paint(Canvas canvas, Size size) {
    // отрисовка разметки
    final List<int> drawDistances = [];

    Label currLabel = _beforeLabel;
    if (_beforeLabel.nextReal() == null) {
      // no labels ahead => nothing to paint
      return;
    }

    double currDepth = Label.calcDepthBetween(_beforeLabel, _beforeLabel.nextReal()!, _startDistance).ceilToDouble();
    while (currLabel != _afterLabel && currLabel.nextReal() != null) {
      final Label nextLabel = currLabel.nextReal()!;
      for (double depth = currDepth; depth < nextLabel.depth; depth += 1.0) {
        //TODO: 0.5
        final int lineDistance = Label.calcDistanceBetween(currLabel, nextLabel, depth);
        if (lineDistance > _startDistance + 100) {
          break; // to next line
        }
        drawDistances.add(lineDistance);
      }
      currLabel = nextLabel;
      currDepth = currLabel.depth.ceilToDouble();
    }
    print(drawDistances);
    final paint = Paint()..strokeWidth = 2;
    for (int drawDist in drawDistances) {
      final Offset top = Offset(size.width * (drawDist % 100) / 100, 0);
      final Offset bot = Offset(size.width * (drawDist % 100) / 100, size.height);
      canvas.drawLine(top, bot, paint);
    }

    // отрисовка чисел
    const textStyle = TextStyle(color: Colors.black, fontSize: 15);

    Label? drawLabel = _beforeLabel.nextReal()!;
    while (drawLabel != _afterLabel) {
      final textPainter = TextPainter(text: TextSpan(text: drawLabel!.depth.toStringAsFixed(2), style: textStyle), textDirection: TextDirection.ltr);
      textPainter.layout(minWidth: 0, maxWidth: size.width);
      final Offset labelPlace = Offset(size.width * (drawLabel.distance % 100) / 100, size.height / 3);
      textPainter.paint(canvas, labelPlace);

      drawLabel = drawLabel.nextReal();
    }
  }

  @override
  bool shouldRepaint(RulerRowPainter oldDelegate) {
    return false;
  }
}

class CasketScheme extends StatefulWidget {
  final Label _startFake;
  final Label _endFake;
  final Function _afterChangingCallback;

  //final int _colAmount;

  const CasketScheme(this._startFake, this._endFake, this._afterChangingCallback, {super.key});

  @override
  createState() => CasketSchemeState(_startFake, _endFake, _afterChangingCallback);
}

class CasketSchemeState extends State<CasketScheme> {
  final Label _startFake;
  final Label _endFake;
  final Function _afterChangingCallback;

  int get rowsAmount => ((_endFake.distance - _startFake.distance) / 100).round();

  CasketSchemeState(this._startFake, this._endFake, this._afterChangingCallback);

  void redrawScheme() {
    setState(() {});
    _afterChangingCallback();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = <Widget>[];

    Label beforeRowLabel = _startFake.prevReal()!; // точно есть из-за стартовой
    Label? afterRowLabel = beforeRowLabel.nextReal();

    Label insideRowLabel = beforeRowLabel;

    for (int rowDist = _startFake.distance; rowDist < _endFake.distance; rowDist += 100) {
      final tableRow = <Container>[];
      for (int cellDist = rowDist + 10; cellDist <= rowDist + 100; cellDist += 10) {
        if (afterRowLabel == null) {
          tableRow.add(Container(
              decoration: BoxDecoration(border: Border.all(color: Colors.grey)), child: CasketCellData(insideRowLabel, false, cellDist, redrawScheme)));
          continue;
        }

        if (afterRowLabel.distance <= cellDist) {
          final double diff = afterRowLabel.depth - afterRowLabel.prevReal()!.depth;
          final String toShow = ' От: ${insideRowLabel.depth.toStringAsFixed(2)} м'
              '\n До: ${afterRowLabel.depth.toStringAsFixed(2)} м'
              '\n Пр: ${diff.toStringAsFixed(2)} м'
              '\n В/К: ${(afterRowLabel.core_output).toStringAsFixed(2)} м'
              '\n %:  ${((afterRowLabel.core_output / diff) * 100).toStringAsFixed(2)}';
          tableRow.add(Container(
              decoration: BoxDecoration(border: Border.all(color: Colors.black /*invert(afterRowLabel.color)*/), color: afterRowLabel.color),
              child: Tooltip(
                message: toShow,
                child: CasketCellData(afterRowLabel, true, cellDist, redrawScheme),
              )));

          insideRowLabel = afterRowLabel;
          afterRowLabel = afterRowLabel.nextReal();
        } else {
          final String toShow = ' Глубина ${Label.calcDepthBetween(insideRowLabel, afterRowLabel, cellDist).toStringAsFixed(2)} м';
          tableRow.add(Container(
              decoration: BoxDecoration(border: Border.all(color: invert(afterRowLabel.color)), color: afterRowLabel.color),
              child: Tooltip(message: toShow, child: CasketCellData(insideRowLabel, false, cellDist, redrawScheme))));
        }
      }

      scheme.add(Container(
          color: Colors.white,
          height: 25,
          width: double.infinity,
          child: CustomPaint(foregroundPainter: RulerRowPainter(rowDist, beforeRowLabel, afterRowLabel))));
      scheme.add(Table(children: [TableRow(children: tableRow)]));

      beforeRowLabel = insideRowLabel;
    }

    return Column(children: scheme);
  }
}

Color invert(Color color) {
  //TODO:
  final r = 255 - color.red;
  final g = 255 - color.blue;
  final b = 255 - color.green;
  return Color.fromARGB((color.opacity * 255).round(), r, g, b);
}
/// Tooltip