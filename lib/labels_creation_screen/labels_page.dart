import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'data_classes/label.dart';
import 'widgets/casket_scheme.dart';

class KernLabelsPage extends StatefulWidget {
  final Label _startFake;
  final Label _endFake;
  final int _casketIndex;

  const KernLabelsPage(this._startFake, this._endFake, this._casketIndex, {super.key});

  @override
  State<StatefulWidget> createState() => KernLabelsPageState(_startFake, _endFake, _casketIndex);
}

class KernLabelsPageState extends State<KernLabelsPage> {
  final Label _startFake;
  final Label _endFake;
  final int _casketIndex;

  KernLabelsPageState(this._startFake, this._endFake, this._casketIndex) {
    recalcFakeLabels();
    recalcCoreOutput();
  }

  void redrawCasketInfo() {
    setState(() {
      recalcFakeLabels();
      recalcCoreOutput();
    });
  }

  void recalcFakeLabels() {
    if (_startFake.nextReal() != null) {
      _startFake.depth = Label.calcDepthBetween(_startFake.prevReal()!, _startFake.nextReal()!, _startFake.distance);
    } else {
      _startFake.depth = Label.extrapolateDepth(_startFake.prevReal()!, _startFake.distance);
    }
    if (_endFake.nextReal() != null) {
      _endFake.depth = Label.calcDepthBetween(_endFake.prevReal()!, _endFake.nextReal()!, _endFake.distance);
    } else if (_endFake.previous! != _startFake) {
      _endFake.depth = Label.extrapolateDepth(_endFake.prevReal()!, _endFake.distance);
    } else {
      _endFake.copyDataFrom(_startFake);
    }
  }

  void recalcCoreOutput() {
    if (_startFake.next == _endFake) {
      _endFake.core_output = _endFake.nextReal() == null ? 0 : _endFake.nextReal()!.core_output;
      return;
    }

    int prevDist = _startFake.distance;
    Label currLabel = _startFake.next!;
    double answ = 0;
    while (currLabel != _endFake) {
      answ += (currLabel.distance - prevDist).toDouble() * currLabel.core_output;
      prevDist = currLabel.distance;
      currLabel = currLabel.next!;
    }
    if (currLabel.nextReal() != null) {
      answ += (currLabel.distance - prevDist).toDouble() * currLabel.nextReal()!.core_output;
      prevDist = currLabel.distance;
    }
    currLabel.core_output = answ / (prevDist - _startFake.distance).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]);

    return Scaffold(
        body: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
      Text('Ящик $_casketIndex'),
      Text('${(_startFake.depth == _endFake.depth ? ' ' : _startFake.depth)}->     '),
      Container(decoration: BoxDecoration(border: Border.all(color: Colors.black)), child: CasketScheme(_startFake, _endFake, redrawCasketInfo)),
      Text('->${(_startFake.depth == _endFake.depth ? ' ' : _endFake.depth)}     '),
      const Text(' '),
      Text('Средний Core Output ящика: ${_endFake.core_output}'),
      const Text(' '),
      const Text(' '),
      const Text('Нажать на ячейку чтобы посмотреть; двойной щелчок чтобы добавить/изменить', style: TextStyle(color: Colors.grey)),
    ]));
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft, DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    super.dispose();
  }
}
