import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter/material.dart';

import 'database_interaction/db_commands.dart';
import 'data_classes/drillhole.dart';
import 'widgets/drillhole_widget.dart';
import 'drillhole_setup_page.dart';
import 'caskets_page.dart';

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

  Future refreshDrillholes() async {
    setState(() => isLoading = true);

    this.drillholes = await DrillholesDatabase.instance.readAllDrillholes();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text(
            'Скважины',
            style: TextStyle(fontSize: 24),
          ),
          actions: const [Icon(Icons.search), SizedBox(width: 12)],
        ),
        body: Center(
          child: isLoading
              ? const CircularProgressIndicator()
              : drillholes.isEmpty
                  ? const Text(
                      'No Drillholes',
                      style: TextStyle(color: Colors.black, fontSize: 24),
                    )
                  : buildDrillholes(),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          child: const Icon(Icons.add),
          onPressed: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AddEditDrillholePage()),
            );

            refreshDrillholes();
          },
        ),
      );

  Widget buildDrillholes() => StaggeredGridView.countBuilder(
        padding: const EdgeInsets.all(8),
        itemCount: drillholes.length,
        staggeredTileBuilder: (index) => const StaggeredTile.fit(5),
        crossAxisCount: 4,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        itemBuilder: (context, index) {
          final drillhole = drillholes[index];

          return GestureDetector(
            onTap: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => DrillholeDetailPage(drillholeId: drillhole.id!, drillhole: drillhole),
              ));

              refreshDrillholes();
            },
            child: DrillholeCardWidget(drillhole: drillhole, index: index),
          );
        },
      );
}
