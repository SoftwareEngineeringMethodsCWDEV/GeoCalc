import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:geoapp/DataBase/db.dart';
import 'package:geoapp/model/drillhole.dart';
// import 'package:geoapp/model/label.dart';
import 'package:geoapp/edit_drillhole_page.dart';
import 'package:geoapp/widget/labelWiget.dart';

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

    this.drillhole = await DrillholesDatabase.instance.readDrillhole(widget.drillholeId);

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
          SizedBox(height: 8),
      Column(children:[
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
      ]

      )
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