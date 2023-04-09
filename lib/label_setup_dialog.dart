import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import 'casket_classes.dart';

class CasketCellData extends StatelessWidget {
  final KernLabel _reference;
  final bool _isLabelKeeper;
  final int _distance;
  final Function _afterChangingCallback;

  KernLabel _dialogOutput;

// TODO: Разобраться с Key? key
  CasketCellData(this._reference, this._isLabelKeeper, this._distance,
      this._afterChangingCallback)
      : _dialogOutput = KernLabel(
            false,
            _distance,
            (_isLabelKeeper
                ? _reference.depth
                : KernLabel.calcDepthBetween(
                    _reference.previous!, _reference, _distance)),
            _reference.coreOutput,
            _reference.color);

  void showCreateDialog(BuildContext context) => showDialog(
      context: context,
      builder: (context) {
        final prevLabelDepth = _reference.prevReal()!.depth;
        final nextLabel = _reference.nextReal();
        final String nextLabelDepth =
            (nextLabel == null ? ' ' : 'до ${nextLabel.depth}');
        return Dialog(
          child: Column(children: [
            Text('Создать этикетку'),
            // Text('Расстояние от края'), //TODO: Slider требует StatefulWidget
            // Slider(
            //     value: _distance.toDouble(),
            //     min: _distance.toDouble(),
            //     max: _distance.toDouble() + 10,
            //     divisions: 10,
            //     label: '${(_dialogOutput.distance) % 100}',
            //     onChanged: (newDist) {
            //       _dialogOutput.distance = newDist.round();
            //     }),
            Text('На ${_dialogOutput.distance} см'),
            Text('возможная глубина: от $prevLabelDepth$nextLabelDepth'),
            Row(
              children: [
                Text('Глубина: '),
                Expanded(
                    child: TextFormField(
                  keyboardType: TextInputType.number,
                  initialValue: '${_dialogOutput.depth}',
                ))
              ],
            ),
            Row(
              children: [
                Text('Выход керна: '),
                Expanded(
                    child: TextFormField(
                  keyboardType: TextInputType.number,
                  initialValue: '${_dialogOutput.coreOutput}',
                ))
              ],
            ),
            Row(children: [
              Text('Выход керна: '),
              ColorPicker(
                  pickerColor: _dialogOutput.color,
                  onColorChanged: (color) {
                    _dialogOutput.color = color;
                  })
            ]),
            Row(children: [
              ElevatedButton(
                  onPressed: () {
                    //TODO: бд
                    _reference
                        .insertBefore(_dialogOutput); // TODO: может быть null
                    _afterChangingCallback();
                    Navigator.of(context).pop();
                  },
                  child: Text('Сохранить')),
              ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Отмена'))
            ])
          ]),
        );
      });

  void showModifyDialog(BuildContext context) => showDialog(
      context: context,
      builder: (context) {
        final prevLabelDepth = _reference.prevReal()!.depth;
        final nextLabel = _reference.nextReal();
        final String nextLabelDepth =
            (nextLabel == null ? ' ' : 'до ${nextLabel.depth}');
        return Dialog(
          child: Column(children: [
            Row(
              children: [
                Text('Модификация'),
                ElevatedButton(
                    onPressed: () {
                      //TODO: бд
                      _reference.unlink();
                      _afterChangingCallback();
                      Navigator.of(context).pop();
                    },
                    child: Text('Удалить'))
              ],
            ),

            // Text('Расстояние от края'), //TODO: Slider требует StatefulWidget
            // Slider(
            //     value: _distance.toDouble(),
            //     min: _distance.toDouble(),
            //     max: _distance.toDouble() + 10,
            //     divisions: 10,
            //     label: '${(_dialogOutput.distance) % 100}',
            //     onChanged: (newDist) {
            //       _dialogOutput.distance = newDist.round();
            //     }),
            Text('На ${_dialogOutput.distance} см'),
            Text('возможная глубина: от $prevLabelDepth$nextLabelDepth'),
            Row(
              children: [
                Text('Глубина: '),
                Expanded(
                    child: TextFormField(
                        keyboardType: TextInputType.number,
                        initialValue: '${_dialogOutput.coreOutput}'))
              ],
            ),
            Row(
              children: [
                Text('Выход керна: '),
                Expanded(
                    child: TextFormField(
                        keyboardType: TextInputType.number,
                        initialValue: '${_dialogOutput.coreOutput}'))
              ],
            ),
            Row(children: [
              Text('Выход керна: '),
              ColorPicker(
                  pickerColor: _dialogOutput.color,
                  onColorChanged: (color) {
                    _dialogOutput.color = color;
                  })
            ]),
            Row(children: [
              ElevatedButton(
                  onPressed: () {
                    //TODO: бд
                    _reference
                        .copyDataFrom(_dialogOutput); // TODO: может быть null
                    _afterChangingCallback();
                    Navigator.of(context).pop();
                  },
                  child: Text('Модифицировать')),
              ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Отмена'))
            ])
          ]),
        );
      });

  @override
  Widget build(BuildContext context) {
    if (_isLabelKeeper) {
      return TableRowInkWell(
          child: Text(' '),
          onLongPress: () {
            return showModifyDialog(context);
          }); //TODO: мб тут можно оптимальней
    } else {
      return TableRowInkWell(
          child: Text(' '),
          onLongPress: () {
            return showCreateDialog(context);
          });
    }
  }
}
