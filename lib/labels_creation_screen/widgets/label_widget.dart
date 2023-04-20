import 'package:flutter/material.dart';
import '../data_classes/label.dart';


import '../database_interaction/db_commands.dart';

class LabelCardWidget extends StatelessWidget {
  LabelCardWidget({
    Key? key,
    required this.label,
    required this.index,
  }) : super(key: key);

  final Label label;
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
              'Box $index',
              style: TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Глубина: ${label.depth}',
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
              'Выход керна: ${label.core_output}',
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
