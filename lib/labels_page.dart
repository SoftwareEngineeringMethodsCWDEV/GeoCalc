import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'database/db.dart';
import 'model/drillhole.dart';
import 'edit_drillhole_page.dart';
import 'widget/label_widget.dart';
import 'casket_scheme.dart';
import 'casket_classes.dart';

class DrillholeDetailPage extends StatefulWidget {
  final int drillholeId;

  const DrillholeDetailPage({
    Key? key,
    required this.drillholeId,
  }) : super(key: key);

  @override
  _DrillholeDetailPageState createState() => _DrillholeDetailPageState();
}

class _DrillholeDetailPageState extends State<DrillholeDetailPage> {
  late Drillhole drillhole;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshDrillhole();
  }

  Future refreshDrillhole() async {
    setState(() => isLoading = true);

    this.drillhole =
        await DrillholesDatabase.instance.readDrillhole(widget.drillholeId);

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          actions: [editButton(), deleteButton()],
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: EdgeInsets.all(12),
                child: ListView(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    children: [
                      Text(
                        drillhole.name,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        DateFormat.yMMMd().format(drillhole.createdTime),
                        style: TextStyle(color: Colors.black),
                      ),
                      SizedBox(
                          height: 8,
                          child: ElevatedButton(
                              child: Text("схема"),
                              onPressed: () {
                                final loadedLabels = LinkedList<KernLabel>();
                                KernLabel fstStart =
                                    KernLabel(true, 0, 0, 5, Colors.green);
                                KernLabel fstEnd =
                                    KernLabel(true, 200, 5.5, 5, Colors.grey);
                                loadedLabels.addAll([
                                  KernLabel(false, 0, 0, 5, Colors.green),
                                  fstStart,
                                  KernLabel(false, 50, 1.5, 5, Colors.green),
                                  KernLabel(false, 75, 2, 5, Colors.blue),
                                  KernLabel(false, 150, 3.4, 5, Colors.grey),
                                  fstEnd,
                                  KernLabel(false, 210, 5.6, 5, Colors.yellow),
                                ]);
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => Scaffold(
                                        body: CasketScheme(fstStart, fstEnd))));
                              })),
                      Column(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            alignment: Alignment.centerRight,
                            width: 200,
                            height: 150,
                            color: Colors.blue,
                            child: Text('Box1'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            alignment: Alignment.centerRight,
                            width: 200,
                            height: 150,
                            color: Colors.blue,
                            child: Text('Box2'),
                          ),
                        )
                      ])
                    ]),
              ),
      );

  Widget editButton() => IconButton(
      icon: Icon(Icons.edit_outlined),
      onPressed: () async {
        if (isLoading) return;

        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AddEditDrillholePage(drillhole: drillhole),
        ));

        refreshDrillhole();
      });

  Widget deleteButton() => IconButton(
        icon: Icon(Icons.delete),
        onPressed: () async {
          await DrillholesDatabase.instance.delete(widget.drillholeId);

          Navigator.of(context).pop();
        },
      );
}
