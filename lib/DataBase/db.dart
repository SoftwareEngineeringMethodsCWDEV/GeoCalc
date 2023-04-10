import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/label.dart';
import '../model/drillhole.dart';

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

//     await db.execute('''
// CREATE TABLE $tableLabels (
//   ${LabelFields.id} $idType,
//   ${LabelFields.drillhole_id} $idType,
//   ${LabelFields.is_Imaginary} $boolType,
//   ${LabelFields.depth} $doubleType,
//   ${LabelFields.distance} $integerType,
//   ${LabelFields.core_output} $doubleType,
//   )
// ''');
  }

  Future<Drillhole> create(Drillhole drillhole) async {
    final db = await instance.database;

    // final json = drillhole.toJson();
    // final columns =
    //     '${DrillholeFields.title}, ${DrillholeFields.description}, ${DrillholeFields.time}';
    // final values =
    //     '${json[DrillholeFields.title]}, ${json[DrillholeFields.description]}, ${json[DrillholeFields.time]}';
    // final id = await db
    //     .rawInsert('INSERT INTO table_name ($columns) VALUES ($values)');

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

  Future<int> update(Drillhole drillhole) async {
    final db = await instance.database;

    return db.update(
      tableDrillholes,
      drillhole.toJson(),
      where: '${DrillholeFields.id} = ?',
      whereArgs: [drillhole.id],
    );
  }

  Future<int> delete(int id) async {
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
}
