import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'data_classes/kern_label.dart';
import 'widgets/casket_scheme.dart';

class KernLabelsPage extends StatefulWidget {
  final KernLabel _startFake;
  final KernLabel _endFake;

  const KernLabelsPage(this._startFake, this._endFake, {super.key});

  @override
  State<StatefulWidget> createState() => KernLabelsPageState(_startFake, _endFake);
}

class KernLabelsPageState extends State<KernLabelsPage> {
  final KernLabel _startFake;
  final KernLabel _endFake;

  KernLabelsPageState(this._startFake, this._endFake);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]);

    return Scaffold(body: Center(child: CasketScheme(_startFake, _endFake)));
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft, DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    super.dispose();
  }
}
