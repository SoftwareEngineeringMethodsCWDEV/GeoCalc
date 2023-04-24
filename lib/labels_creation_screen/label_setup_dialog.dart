import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter/material.dart';

import 'data_classes/label.dart';
import 'database_interaction/db_commands.dart';

class KernLabelSetup extends StatefulWidget {
  final Label _initial;

  final double _depthBefore;
  final double? _depthAfter;
  final int _startingDistance;

  const KernLabelSetup(this._initial, this._depthBefore, this._depthAfter, this._startingDistance, {super.key});

  @override
  State<StatefulWidget> createState() => KernLabelSetupState(_initial, _depthBefore, _depthAfter, _startingDistance);
}

class KernLabelSetupState extends State<KernLabelSetup> {
  final Label _current;
  final int _startingDistance;
  final double _depthBefore;
  final double? _depthAfter;

  KernLabelSetupState(this._current, this._depthBefore, this._depthAfter, this._startingDistance);
  @override
  Widget build(BuildContext context) {
    final String nextLabelDepth = (_depthAfter == null ? ' ' : 'до ${_depthAfter!.toStringAsFixed(2)}');
    return Column(children: [
      const Text('Расстояние от края'),
      Slider(
          value: ((_current.distance) % 100).toDouble(),
          min: _startingDistance.toDouble() % 100,
          max: _startingDistance.toDouble() % 100 + 9,
          divisions: 10,
          label: '${(_current.distance) % 100}',
          onChanged: (newDist) => setState(() {
                _current.distance = newDist.toInt();
              })),
      Text('возможная глубина: от ${_depthBefore.toStringAsFixed(2)}$nextLabelDepth'),
      Row(
        children: [
          const Text('Глубина: '),
          Expanded(
              child: TextFormField(
                  keyboardType: TextInputType.number,
                  initialValue: '${_current.depth}',
                  onChanged: (text) {
                    if (text.isEmpty) {
                      return;
                    }
                    final double parsed = double.parse(text);
                    if (parsed >= _depthBefore && (_depthAfter == null || parsed <= _depthAfter!)) {
                      _current.depth = parsed;
                    }
                  }))
        ],
      ),
      Row(
        children: [
          const Text('Выход керна: '),
          Expanded(
              child: TextFormField(
            keyboardType: TextInputType.number,
            initialValue: '${_current.core_output}',
            onChanged: (text) {
              if (text.isNotEmpty) {
                _current.core_output = double.parse(text);
              }
            },
          ))
        ],
      ),
      Row(
        children: [
          Container(decoration: BoxDecoration(shape: BoxShape.circle, color: _current.color), width: 30, height: 30),
          ElevatedButton(onPressed: () => pickColor(context), child: const Text('Выбрать цвет'))
        ],
      )
    ]);
  }

  void pickColor(BuildContext context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text('Цвет'),
            content:
                SingleChildScrollView(child: MaterialPicker(pickerColor: _current.color, onColorChanged: (color) => setState(() => _current.color = color))),
            actions: <Widget>[
              TextButton(
                child: const Text('Выбрать'),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          ));
}

class CasketCellData extends StatelessWidget {
  final Label _reference;
  final bool _isLabelKeeper;
  final int _distance;
  final Function _afterChangingCallback;

  final Label _dialogOutput;

  CasketCellData(this._reference, this._isLabelKeeper, this._distance, this._afterChangingCallback, {super.key})
      : _dialogOutput = Label(
            id: (_isLabelKeeper ? _reference.id : null),
            drillhole_id: _reference.drillhole_id,
            is_Imaginary: false,
            distance: _distance,
            depth: (_isLabelKeeper
                ? _reference.depth
                : (_reference.nextReal() == null
                    ? Label.extrapolateDepth(_reference, _distance)
                    : Label.calcDepthBetween(_reference, _reference.nextReal()!, _distance))),
            core_output: _reference.core_output,
            color: _reference.color);

  void showCreateDialog(BuildContext context) => showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Column(children: [
            const Text('Создать этикетку'),
            KernLabelSetup(_dialogOutput, _reference.depth, (_reference.nextReal() == null ? null : _reference.nextReal()!.depth), _distance),
            Row(children: [
              ElevatedButton(
                  onPressed: () async {
                    _dialogOutput.id = await DrillholesDatabase.instance.createLabel(_dialogOutput);
                    if (_reference.next != null && _reference.next!.distance < _dialogOutput.distance) {
                      _reference.next!.insertAfter(_dialogOutput);
                    } else {
                      _reference.insertAfter(_dialogOutput);
                    }

                    _afterChangingCallback();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Сохранить')),
              ElevatedButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Отмена'))
            ])
          ]),
        );
      });

  void showModifyDialog(BuildContext context) => showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Column(children: [
            Row(
              children: [
                const Text('Модификация'),
                ElevatedButton(
                    onPressed: () async {
                      await DrillholesDatabase.instance.deleteLabel(_dialogOutput.id!);
                      _reference.unlink();
                      _afterChangingCallback();
                      Navigator.of(context).pop();
                    },
                    child: const Text('Удалить'))
              ],
            ),
            KernLabelSetup(_dialogOutput, _reference.depth, (_reference.nextReal() == null ? null : _reference.nextReal()!.depth), _distance),
            Row(children: [
              ElevatedButton(
                  onPressed: () async {
                    await DrillholesDatabase.instance.updateLabel(_dialogOutput);
                    _reference.copyDataFrom(_dialogOutput);
                    _afterChangingCallback();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Модифицировать')),
              ElevatedButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Отмена'))
            ])
          ]),
        );
      });

  @override
  Widget build(BuildContext context) {
    return TableRowInkWell(
        child: const Text(' '),
        onDoubleTap: () {
          if (_isLabelKeeper) {
            return showModifyDialog(context);
          } else {
            return showCreateDialog(context);
          }
        });
  }
}
