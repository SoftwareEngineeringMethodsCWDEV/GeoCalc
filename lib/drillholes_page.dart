import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

// import 'package:geoapp/model/label.dart';
import 'database/db.dart';
import 'model/drillhole.dart';
import 'edit_drillhole_page.dart';
import 'labels_page.dart';
import 'widget/drillhole_widget.dart';

class DrillholesPage extends StatefulWidget {
  @override
  _DrillholesPageState createState() => _DrillholesPageState();
}

class _DrillholesPageState extends State<DrillholesPage> {
  late List<Drillhole> drillholes;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshDrillholes();
  }

  // @override
  // void dispose() {
  //   DrillholesDatabase.instance.close();
  //
  //   super.dispose();
  // }

  Future refreshDrillholes() async {
    setState(() => isLoading = true);

    this.drillholes = await DrillholesDatabase.instance.readAllDrillholes();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(
            'Скважины',
            style: TextStyle(fontSize: 24),
          ),
          actions: [Icon(Icons.search), SizedBox(width: 12)],
        ),
        body: Center(
          child: isLoading
              ? CircularProgressIndicator()
              : drillholes.isEmpty
                  ? Text(
                      'No Drillholes',
                      style: TextStyle(color: Colors.black, fontSize: 24),
                    )
                  : buildDrillholes(),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue[900],
          child: Icon(Icons.add),
          onPressed: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => AddEditDrillholePage()),
            );

            refreshDrillholes();
          },
        ),
      );

  Widget buildDrillholes() => StaggeredGridView.countBuilder(
        padding: EdgeInsets.all(8),
        itemCount: drillholes.length,
        staggeredTileBuilder: (index) => StaggeredTile.fit(5),
        crossAxisCount: 4,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        itemBuilder: (context, index) {
          final drillhole = drillholes[index];

          return GestureDetector(
            onTap: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    DrillholeDetailPage(drillholeId: drillhole.id!),
              ));
              // DrillholesDatabase.instance.randominsert();
              refreshDrillholes();
            },
            child: DrillholeCardWidget(drillhole: drillhole, index: index),
          );
        },
      );
}
