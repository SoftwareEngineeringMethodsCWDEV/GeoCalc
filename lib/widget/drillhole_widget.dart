
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/drillhole.dart';

class DrillholeCardWidget extends StatelessWidget {
  DrillholeCardWidget({
    Key? key,
    required this.drillhole,
    required this.index,
  }) : super(key: key);

  final Drillhole drillhole;
  final int index;

  @override
  Widget build(BuildContext context) {
    final time = DateFormat.yMMMd().format(drillhole.createdTime);

    return Card(
      margin: EdgeInsets.symmetric(vertical: 5),
      color: Colors.blue,
      child: Container(
        constraints: BoxConstraints(minHeight: 100),
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              time,
              style: TextStyle(color: Colors.grey.shade700),
            ),
            SizedBox(height: 4),
            Text(
              drillhole.name,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
