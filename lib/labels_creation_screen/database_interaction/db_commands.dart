import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:collection';

import '../data_classes/drillhole.dart';
import '../data_classes/label.dart';

class Box {
  late LinkedList<Label> _labels;

  Box(LinkedList<Label> labels) {
    _labels = labels;
  }

  LinkedList<Label> get labels => _labels;
}

class DrillholesDatabase {
  static final DrillholesDatabase instance = DrillholesDatabase._init();

  static Database? _database;

  DrillholesDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('drillholes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';
    final boolType = 'BOOLEAN NOT NULL';
    final integerType = 'INTEGER NOT NULL';
    final doubleType = 'DOUBLE NOT NULL';

    await db.execute('''
CREATE TABLE $tableDrillholes ( 
  ${DrillholeFields.id} $idType,
  ${DrillholeFields.name} $textType,
  ${DrillholeFields.creation_date} $textType
  )
''');

    await db.execute('''
CREATE TABLE $tableLabels (
  ${LabelFields.id} $idType,
  ${LabelFields.drillhole_id} $integerType,
  ${LabelFields.is_Imaginary} $boolType,
  ${LabelFields.depth} $doubleType,
  ${LabelFields.distance} $integerType,
  ${LabelFields.core_output} $doubleType,
  ${LabelFields.color} $integerType
  )
''');
  }

  Future<Drillhole> createDrillhole(Drillhole drillhole) async {
    final db = await instance.database;

    final id = await db.insert(tableDrillholes, drillhole.toJson());
    return drillhole.copy(id: id);
  }

  Future<Drillhole> readDrillhole(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableDrillholes,
      columns: DrillholeFields.values,
      where: '${DrillholeFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Drillhole.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Drillhole>> readAllDrillholes() async {
    final db = await instance.database;

    final orderBy = '${DrillholeFields.creation_date} ASC';
    // final result =
    //     await db.rawQuery('SELECT * FROM $tableDrillholes ORDER BY $orderBy');

    final result = await db.query(tableDrillholes, orderBy: orderBy);

    return result.map((json) => Drillhole.fromJson(json)).toList();
  }

  Future<int> updateDrillhole(Drillhole drillhole) async {
    final db = await instance.database;

    return db.update(
      tableDrillholes,
      drillhole.toJson(),
      where: '${DrillholeFields.id} = ?',
      whereArgs: [drillhole.id],
    );
  }

  Future<int> deleteDrillhole(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableDrillholes,
      where: '${DrillholeFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }

  Future<int> createLabel(Label label) async {
    final db = await instance.database;

    final id = await db.insert(tableLabels, label.toJson());
    return id;
  }

  Future<Label> readLabel(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableLabels,
      columns: LabelFields.values,
      where: '${LabelFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Label.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Label>> readAllLabels() async {
    final db = await instance.database;

    final orderBy = '${LabelFields.depth} ASC';
    final result = await db.rawQuery('SELECT * FROM $tableLabels ORDER BY $orderBy');

    return result.map((json) => Label.fromJson(json)).toList();
  }

  Future<LinkedList<Label>> labelsToLinkedList(List<Label> labelList) async {
    LinkedList<Label> linkedList = LinkedList<Label>();
    labelList.forEach((label) {
      linkedList.add(label);
    });
    return linkedList;
  }

  Future<List<Label>> linkedLabelsToList(LinkedList<Label> linkedList) async {
    return linkedList.toList();
  }

  Future<int> updateLabel(Label label) async {
    final db = await instance.database;

    return db.update(
      tableLabels,
      label.toJson(),
      where: '${LabelFields.id} = ?',
      whereArgs: [label.id],
    );
  }

  Future<int> deleteLabel(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableLabels,
      where: '${LabelFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<int> countBoxes(int dh_id) async {
    final db = await instance.database;

    final count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $tableLabels WHERE is_Imaginary = 1 AND drillhole_id = ?', [dh_id])) ?? 0;
    // Return the count
    return count;
  }

  Future<List<Box>> CreateBoxList(LinkedList<Label> labels, int dh_id) async {
    List<Box> boxList = [];
    LinkedList<Label> filteredLabelList = LinkedList<Label>();

    for (int i = 0; i < labels.length; i++) {
      Label currentList = labels.elementAt(i);

      if (currentList.drillhole_id == dh_id && currentList.is_Imaginary == true) {
        filteredLabelList.add(currentList);
      }
    }

    if (filteredLabelList.isNotEmpty) {
      Box box = Box(filteredLabelList);
      boxList.add(box);
    }

    return boxList;
  }

  Future<List<int>> CreateBoxListFromLinked(LinkedList<Label> labels, int dh_id) async {
    List<int> boxList = [];

    for (int i = 0; i < labels.length; i++) {
      Label currentList = labels.elementAt(i);

      if (currentList.drillhole_id == dh_id && currentList.is_Imaginary == true) {
        boxList.add(i);
      }
    }

    return boxList;
  }

  Future createFirstLabel(int dh_id) async {
    final db = await instance.database;

    int count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $tableLabels WHERE drillhole_id = ?', [dh_id])) ?? 0;
    if (count == 0) {
      db.rawInsert('INSERT INTO Label(drillhole_id, is_Imaginary, depth, distance, core_output, color) VALUES(?, 0, 0, 0, 0, 0)', [dh_id]);
      db.rawInsert('INSERT INTO Label(drillhole_id, is_Imaginary, depth, distance, core_output, color) VALUES(?, 1, 0, 0, 0, 0)', [dh_id]);
    }
  }

  Future createBox(int dh_id) async {
    final db = await instance.database;
    db.rawInsert('INSERT INTO Label(drillhole_id, is_Imaginary, depth, distance, core_output, color) VALUES(?, 1, 99999, 500, 0, 0)', [dh_id]);
  }

  Future randominsert() async {
    final db = await instance.database;

    db.rawInsert('INSERT INTO Label(drillhole_id, is_Imaginary, depth, distance, core_output) VALUES(1, 1, 0, 0, 0)');
    db.rawInsert('INSERT INTO Label(drillhole_id, is_Imaginary, depth, distance, core_output) VALUES(1, 0, 3, 1, 0.2)');
    db.rawInsert('INSERT INTO Label(drillhole_id, is_Imaginary, depth, distance, core_output) VALUES(1, 1, 21, 15, 0.4)');
    db.rawInsert('INSERT INTO Label(drillhole_id, is_Imaginary, depth, distance, core_output) VALUES(1, 0, 24, 1, 1)');
    db.rawInsert('INSERT INTO Label(drillhole_id, is_Imaginary, depth, distance, core_output) VALUES(1, 0, 31, 6, 1)');
    db.rawInsert('INSERT INTO Label(drillhole_id, is_Imaginary, depth, distance, core_output) VALUES(1, 1, 35, 4, 0.9)');
    db.rawInsert('INSERT INTO Label(drillhole_id, is_Imaginary, depth, distance, core_output) VALUES(1, 0, 41, 6, 0.2)');
    db.rawInsert('INSERT INTO Label(drillhole_id, is_Imaginary, depth, distance, core_output) VALUES(2, 1, 0, 2, 0.1)');
    db.rawInsert('INSERT INTO Label(drillhole_id, is_Imaginary, depth, distance, core_output) VALUES(2, 0, 2, 2, 0.2)');
    db.rawInsert('INSERT INTO Label(drillhole_id, is_Imaginary, depth, distance, core_output) VALUES(2, 1, 3, 1, 0.4)');
  }
}
