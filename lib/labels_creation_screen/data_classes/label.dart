import 'dart:collection';
import 'package:flutter/material.dart';

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
  static final String color = 'color';
}

class Label extends LinkedListEntry<Label> {
  int? id;
  final int drillhole_id;
  final bool is_Imaginary;

  double depth;
  int distance;
  double core_output;

  Color color;

  Label(
      {this.id,
      required this.drillhole_id,
      required this.is_Imaginary,
      required this.depth,
      required this.distance,
      required this.core_output,
      required this.color});

  Label copy({int? id, int? drillhole_id, bool? is_Imaginary, double? depth, int? distance, double? core_output, Color? color}) => Label(
      id: id ?? this.id,
      drillhole_id: drillhole_id ?? this.drillhole_id,
      is_Imaginary: is_Imaginary ?? this.is_Imaginary,
      depth: depth ?? this.depth,
      distance: distance ?? this.distance,
      core_output: core_output ?? this.core_output,
      color: color ?? this.color);

  static Label fromJson(Map<String, Object?> json) => Label(
      id: json[LabelFields.id] as int?,
      drillhole_id: json[LabelFields.drillhole_id] as int,
      is_Imaginary: json[LabelFields.is_Imaginary] == 1,
      depth: json[LabelFields.depth] as double,
      distance: json[LabelFields.distance] as int,
      core_output: json[LabelFields.core_output] as double,
      color: toColor(json[LabelFields.color] as int));

  Map<String, Object?> toJson() => {
        LabelFields.id: id,
        LabelFields.drillhole_id: drillhole_id,
        LabelFields.is_Imaginary: is_Imaginary ? 1 : 0,
        LabelFields.depth: depth,
        LabelFields.distance: distance,
        LabelFields.core_output: core_output,
        LabelFields.color: toInt(color)
      };

  ///
  ///
  static int toInt(Color c) {
    return c.value;
  }

  static Color toColor(int val) {
    return Color(val);
  }

  /// доп. функции
  ///
  void copyDataFrom(Label other) {
    this.distance = other.distance;
    this.depth = other.depth;
    this.core_output = other.core_output;
    this.color = other.color;
  }

  Label? nextReal() {
    Label? curr = this.next;
    while (curr != null && curr.is_Imaginary) {
      curr = curr.next;
    }
    return curr;
  }

  Label? nextFake() {
    Label? curr = this.next;
    while (curr != null && !curr.is_Imaginary) {
      curr = curr.next;
    }
    return curr;
  }

  Label? prevReal() {
    Label? curr = this.previous;
    while (curr != null && curr.is_Imaginary) {
      curr = curr.previous;
    }
    return curr;
  }

  Label? prevFake() {
    Label? curr = this.previous;
    while (curr != null && !curr.is_Imaginary) {
      curr = curr.previous;
    }
    return curr;
  }

  static double calcDepthBetween(Label before, Label after, int onDistance) {
    // TODO: check inputs
    double scale = (after.depth - before.depth) / (after.distance - before.distance);
    return before.depth + (onDistance - before.distance) * scale;
  }

  static double extrapolateDepth(Label before, int onDistance) {
    double scale = (before.depth) / (before.distance);
    return onDistance * scale;
  }

  static int calcDistanceBetween(Label before, Label after, double onDepth) {
    // TODO: check inputs
    double scale = (after.distance - before.distance) / (after.depth - before.depth);

    return before.distance + ((onDepth - before.depth) * scale).round();
  }
}
