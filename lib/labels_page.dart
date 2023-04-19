import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'widget/drillhole_widget.dart';
import 'DataBase/db.dart';
import 'model/drillhole.dart';
import 'model/label.dart';
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
  late List<Label> labels;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshDrillhole();
    refreshLabels();
  }

  Future<List<Box>> GetBoxes(dh_id) async {
    Future<List<Label>> labelsFuture =
        DrillholesDatabase.instance.readAllLabels();
    List<Label> labels = await labelsFuture;
    Future<List<Box>> boxListFuture =
        DrillholesDatabase.instance.CreateBoxList(labels, dh_id);
    List<Box> boxes = await boxListFuture;
    return boxes;
  }

  Future refreshDrillhole() async {
    setState(() => isLoading = true);

    this.drillhole =
        await DrillholesDatabase.instance.readDrillhole(widget.drillholeId);

    setState(() => isLoading = false);
  }

  Future refreshLabels() async {
    setState(() => isLoading = true);

    this.labels = await DrillholesDatabase.instance.readAllLabels();

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
                padding:
                    EdgeInsets.only(left: 100, top: 12, right: 12, bottom: 12),
                child: FutureBuilder<Widget>(
                  future: buildLabels(context),
                  builder:
                      (BuildContext context, AsyncSnapshot<Widget> snapshot) {
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
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue[900],
          child: Icon(Icons.add),
          onPressed: () async {
            DrillholesDatabase.instance.createBox(widget.drillholeId);
            refreshLabels();
          },
        ),
      );

  Future<Widget> buildLabels(BuildContext context) async {
    Future<List<Box>> Futureboxes = GetBoxes(widget.drillholeId);
    List<Box> boxes = await Futureboxes;
    return StaggeredGridView.countBuilder(
      padding: EdgeInsets.all(8),
      itemCount: boxes.length,
      staggeredTileBuilder: (index) => StaggeredTile.fit(5),
      crossAxisCount: 4,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final box = boxes[index];

        return GestureDetector(
          onTap: () async {
            final loadedLabels = LinkedList<KernLabel>();
            KernLabel fstStart = KernLabel(true, 0, 0, 5, Colors.green);
            KernLabel fstEnd = KernLabel(true, 200, 5.5, 5, Colors.grey);
            loadedLabels.addAll([
              KernLabel(false, 0, 0, 5, Colors.green),
              fstStart,
              KernLabel(false, 50, 1.5, 5, Colors.green),
              KernLabel(false, 75, 2, 5, Colors.blue),
              KernLabel(false, 150, 3.4, 5, Colors.grey),
              fstEnd,
              KernLabel(false, 210, 5.6, 5, Colors.yellow),
            ]);
            await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    Scaffold(body: CasketScheme(fstStart, fstEnd))));

            refreshLabels();
          },
          child: LabelCardWidget(
            box: box,
            index: index,
          ),
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
