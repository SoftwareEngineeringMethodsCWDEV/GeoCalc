import 'package:flutter/material.dart';

import 'database/db.dart';
import 'model/drillhole.dart';
import 'widget/drillhole_from_wiget.dart';

class AddEditDrillholePage extends StatefulWidget {
  final Drillhole? drillhole;

  const AddEditDrillholePage({
    Key? key,
    this.drillhole,
  }) : super(key: key);

  @override
  _AddEditDrillholePageState createState() => _AddEditDrillholePageState();
}

class _AddEditDrillholePageState extends State<AddEditDrillholePage> {
  final _formKey = GlobalKey<FormState>();
  late String name;

  @override
  void initState() {
    super.initState();

    name = widget.drillhole?.name ?? '';
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          actions: [buildButton()],
        ),
        body: Form(
          key: _formKey,
          child: DrillholeFormWidget(
            name: name,
            onChangedName: (name) => setState(() => this.name = name),
          ),
        ),
      );

  Widget buildButton() {
    final isFormValid = name.isNotEmpty;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.white,
          primary: isFormValid ? null : Colors.blue[900]!,
        ),
        onPressed: addOrUpdateDrillhole,
        child: Text('Save'),
      ),
    );
  }

  void addOrUpdateDrillhole() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final isUpdating = widget.drillhole != null;

      if (isUpdating) {
        await updateDrillhole();
      } else {
        await addDrillhole();
      }

      Navigator.of(context).pop();
    }
  }

  Future updateDrillhole() async {
    final drillhole = widget.drillhole!.copy(
      name: name,
    );

    await DrillholesDatabase.instance.updateDrillhole(drillhole);
  }

  Future addDrillhole() async {
    final drillhole = Drillhole(
      name: name,
      createdTime: DateTime.now(),
    );

    await DrillholesDatabase.instance.createDrillhole(drillhole);
  }
}
