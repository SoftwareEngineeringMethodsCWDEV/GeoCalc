import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/label.dart';
import 'package:geoapp/DataBase/db.dart';

class LabelCardWidget extends StatelessWidget {
  LabelCardWidget({
    Key? key,
    required this.box,
    required this.index,
  }) : super(key: key);

  final Box box;
  final int index;

  @override
  Widget build(BuildContext context) {
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
            SizedBox(height: 4),
            Text(
              'Box ${index + 1}',
              style: TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Глубина: ${box.labels[0].depth}',
              style: TextStyle(
                color: Colors.black,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Кол-во рядов: ???',
              style: TextStyle(
                color: Colors.black,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Выход керна: ${box.labels[0].core_output}',
              style: TextStyle(
                color: Colors.black,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
