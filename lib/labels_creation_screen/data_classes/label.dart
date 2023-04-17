final String tableLabels = 'Label';

class LabelFields {
  static final List<String> values = [
    /// Add all fields
    id, drillhole_id, is_Imaginary, depth, distance, core_output
  ];

  static final String id = '_id';
  static final String drillhole_id = 'drillhole_id';
  static final String is_Imaginary = 'is_Imaginary';
  static final String depth = 'depth';
  static final String distance = 'distance';
  static final String core_output = 'core_output';
}

class Label {
  final int? id;
  final int? drillhole_id;
  final bool is_Imaginary;
  final double depth;
  final int distance;
  final double core_output;

  const Label({
    this.id,
    required this.drillhole_id,
    required this.is_Imaginary,
    required this.depth,
    required this.distance,
    required this.core_output,
  });

  Label copy({
    int? id,
    int? drillhole_id,
    bool? is_Imaginary,
    double? depth,
    int? distance,
    double? core_output,
  }) =>
      Label(
        id: id ?? this.id,
        drillhole_id: drillhole_id ?? this.drillhole_id,
        is_Imaginary: is_Imaginary ?? this.is_Imaginary,
        depth: depth ?? this.depth,
        distance: distance ?? this.distance,
        core_output: core_output ?? this.core_output,
      );

  static Label fromJson(Map<String, Object?> json) => Label(
        id: json[LabelFields.id] as int?,
        drillhole_id: json[LabelFields.drillhole_id] as int?,
        is_Imaginary: json[LabelFields.is_Imaginary] == 1,
        depth: json[LabelFields.depth] as double,
        distance: json[LabelFields.distance] as int,
        core_output: json[LabelFields.core_output] as double,
      );

  Map<String, Object?> toJson() => {
        LabelFields.id: id,
        LabelFields.drillhole_id: drillhole_id,
        LabelFields.is_Imaginary: is_Imaginary ? 1 : 0,
        LabelFields.depth: depth,
        LabelFields.distance: distance,
        LabelFields.core_output: core_output,
      };
}
