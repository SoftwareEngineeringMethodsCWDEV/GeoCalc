final String tableDrillholes = 'DrillHole';

class DrillholeFields {
  static final List<String> values = [
    /// Add all fields
    id, name, creation_date
  ];

  static final String id = '_id';
  static final String name = 'name';
  static final String creation_date = 'reation_date';
}

class Drillhole {
  final int? id;
  final String name;
  final DateTime createdTime;

  const Drillhole({
    this.id,
    required this.name,
    required this.createdTime,
  });

  Drillhole copy({
    int? id,
    String? name,
    DateTime? createdTime,
  }) =>
      Drillhole(
        id: id ?? this.id,
        name: name ?? this.name,
        createdTime: createdTime ?? this.createdTime,
      );

  static Drillhole fromJson(Map<String, Object?> json) => Drillhole(
    id: json[DrillholeFields.id] as int?,
    name: json[DrillholeFields.name] as String,
    createdTime: DateTime.parse(json[DrillholeFields.creation_date] as String),
  );

  Map<String, Object?> toJson() => {
    DrillholeFields.id: id,
    DrillholeFields.name: name,
    DrillholeFields.creation_date: createdTime.toIso8601String(),
  };
}
