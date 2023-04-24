import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'labels_page.dart';
import 'database_interaction/db_commands.dart';
import 'data_classes/drillhole.dart';
import 'data_classes/label.dart';
import 'drillhole_setup_page.dart';
import 'widgets/label_widget.dart';

class DrillholeDetailPage extends StatefulWidget {
  final int drillholeId;
  final Drillhole drillhole;

  const DrillholeDetailPage({Key? key, required this.drillholeId, required this.drillhole}) : super(key: key);

  @override
  _DrillholeDetailPageState createState() => _DrillholeDetailPageState(drillhole);
}

class _DrillholeDetailPageState extends State<DrillholeDetailPage> {
  Drillhole drillhole;
  late List<Label> labels;
  bool isLoading = false;
  late int start_depth;

  _DrillholeDetailPageState(this.drillhole);

  @override
  void initState() {
    refreshDrillhole();
    refreshLabels();
    super.initState();
  }

  Future<List<int>> GetBoxes(dh_id) async {
    Future<List<Label>> labelsFuture = DrillholesDatabase.instance.readAllLabels(drillhole.id!);
    List<Label> labels = await labelsFuture;
    LinkedList<Label> linked_lables = await DrillholesDatabase.instance.labelsToLinkedList(labels);
    Future<List<int>> boxListFuture = DrillholesDatabase.instance.CreateBoxListFromLinked(linked_lables, dh_id);
    List<int> boxes = await boxListFuture;
    return boxes;
  }

  Future refreshDrillhole() async {
    setState(() => isLoading = true);

    this.drillhole = await DrillholesDatabase.instance.readDrillhole(widget.drillholeId);

    setState(() => isLoading = false);
  }

  Future refreshLabels() async {
    setState(() => isLoading = true);

    this.labels = await DrillholesDatabase.instance.readAllLabels(drillhole.id!);

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(
            this.drillhole.name,
            style: TextStyle(fontSize: 24),
          ),
          actions: [editButton(), deleteButton()],
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: EdgeInsets.only(left: 100, top: 12, right: 12, bottom: 12),
                child: FutureBuilder<Widget>(
                  future: buildLabels(context),
                  builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                    if (snapshot.hasData) {
                      return snapshot.data!;
                    } else if (snapshot.hasError) {
                      return const Text('Error loading widget');
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                ),
              ),
        floatingActionButton: Builder(
          builder: (BuildContext context) {
            return FloatingActionButton(
              backgroundColor: Colors.blue[900],
              child: Icon(Icons.add),
              onPressed: () async {
                refreshLabels();
                int? row_count;
                TextEditingController rowsController = TextEditingController(text: '');
                await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Кол-во рядов ящика:"),
                      content: TextField(
                        controller: rowsController,
                        keyboardType: TextInputType.number,
                        onSubmitted: (String text) {
                          row_count = int.parse(rowsController.text);
                          Navigator.of(context).pop();
                        },
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: Text("Cancel"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text("OK"),
                          onPressed: () async {
                            Future<double> max_distance_future = DrillholesDatabase.instance.getMaxDistance(labels, widget.drillholeId);
                            double max_distance = await max_distance_future;
                            row_count = int.parse(rowsController.text) * 100;
                            DrillholesDatabase.instance.createFirstLabel(widget.drillholeId);
                            DrillholesDatabase.instance.createBox(widget.drillholeId, (row_count! + max_distance));
                            refreshLabels();
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            );
          },
        ),
      );

  Future<Widget> buildLabels(BuildContext context) async {
    LinkedList<Label> linked_lables = await DrillholesDatabase.instance.labelsToLinkedList(labels);
    Future<List<int>> Futureboxes = GetBoxes(widget.drillholeId);
    List<int> boxes = await Futureboxes;
    return StaggeredGridView.countBuilder(
      padding: EdgeInsets.all(8),
      itemCount: boxes.length - 1,
      staggeredTileBuilder: (index) => StaggeredTile.fit(5),
      crossAxisCount: 4,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        index = index + 1;

        return GestureDetector(
          onTap: () async {
            await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Scaffold(body: KernLabelsPage(linked_lables.elementAt(boxes[index - 1]), linked_lables.elementAt(boxes[index]), index))));

            refreshLabels();
          },
          child: LabelCardWidget(
            label: linked_lables.elementAt(boxes[index]),
            index: index,
            row_count: (linked_lables.elementAt(boxes[index]).distance - linked_lables.elementAt(boxes[index - 1]).distance).toInt(),
          ),

          // child: Row(
          //   children: [
          //     Text('${linked_lables.elementAt(boxes[index]).depth}; '),
          //     Text('${linked_lables.elementAt(boxes[index]).distance}')
          //   ],
          // ),
        );
      },
    );
    ;
  }

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
          await DrillholesDatabase.instance.deleteDrillhole(widget.drillholeId);

          Navigator.of(context).pop();
        },
      );
}
