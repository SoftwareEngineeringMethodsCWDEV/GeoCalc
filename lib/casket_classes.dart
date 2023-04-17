import 'dart:collection';
import 'package:flutter/material.dart';

//Основа для всех вычислений это Этикетка - вводится пользователем => все расчёты исходят от неё
class KernLabel extends LinkedListEntry<KernLabel> {
  final bool isImaginary;

  int distance; // в сантиметрах
  double depth; // в метрах
  double coreOutput; // соотношение

  Color color; // цвет для рейса до этикетки

  KernLabel(this.isImaginary, this.distance, this.depth, this.coreOutput, this.color);

  void copyDataFrom(KernLabel other) {
    this.distance = other.distance;
    this.depth = other.depth;
    this.coreOutput = other.coreOutput;
    this.color = other.color;
  }

  KernLabel? nextReal() {
    KernLabel? curr = this.next;
    while (curr != null && curr.isImaginary) {
      curr = curr.next;
    }
    return curr;
  }

  KernLabel? nextFake() {
    KernLabel? curr = this.next;
    while (curr != null && !curr.isImaginary) {
      curr = curr.next;
    }
    return curr;
  }

  KernLabel? prevReal() {
    KernLabel? curr = this.previous;
    while (curr != null && curr.isImaginary) {
      curr = curr.previous;
    }
    return curr;
  }

  KernLabel? prevFake() {
    KernLabel? curr = this.previous;
    while (curr != null && !curr.isImaginary) {
      curr = curr.previous;
    }
    return curr;
  }

  static double calcDepthBetween(KernLabel before, KernLabel after, int onDistance) {
    // TODO: check inputs
    double scale = (after.depth - before.depth) / (after.distance - before.distance);
    return before.depth + (onDistance - before.distance) * scale;
  }

  static double extrapolateDepth(KernLabel before, int onDistance) {
    double scale = (before.depth) / (before.distance);
    return onDistance * scale;
  }

  static int calcDistanceBetween(KernLabel before, KernLabel after, double onDepth) {
    // TODO: check inputs
    double scale = (after.distance - before.distance) / (after.depth - before.depth);

    return before.distance + ((onDepth - before.depth) * scale).round();
  }
}

// class KernCasket {
//   double _casketsDistance; // в сантиметрах (всегда % 100)
//   double _depth; // в метрах (глубина начала ящика) -

//   int _rowAmount;
//   KernLabel? _nextLabel;

//   Casket(this._casketsDistance,
//       this._depth) // или можно через factory Casket.createEmpty()
//       : _insideLabels = [],
//         _rowAmount = 0;

//   // sets
//   set newRowAmount(int amount) {
//     // разные проверки
//     _rowAmount = amount;
//   }

//   // полезные gets
//   double get averageCoreOutput => 0.5 /*функция считающая среднее ВК в ящике*/;
//   double get endDistance => _casketsDistance + _rowAmount * 100;
//   int get number => (_casketsDistance / 100).round();

//   // функции
//   String showInfo() =>
//       'dist: $_casketsDistance, dpth: $_depth, rows: $_rowAmount, lbls: ${_insideLabels.length}, next: ${_nextLabel != null}, avg: ${averageCoreOutput}';
// }

// перевод от "скважина"
// class DrillHole {
//   String name;
//   DateTime created;

//   // если что-то меняется в середине списка, то нужно пройти до конца и пересчитать все остальные

//   DrillHole(String this.name)
//       : _labels = [],
//         _caskets = [];

//   // gets
//   double get depth => this._labels.last.depth;
//   int get casketsAmount => this._caskets.length;
// }

// class TheGeoApp {
//   List<DrillHole> _drillHoles;
//   //Settings - в виде singleton

//   TheGeoApp() : _drillHoles = [];
// }

// //usage testing
// void main(List<String> args) {
//   List<KernLabel> drillHole = [];
//   double drillDepth = 0;
//   List<Casket> caskets = [];
//   double casketsDistance = 0;

//   caskets.add(Casket(casketsDistance, drillDepth));
//   print(caskets.last.showInfo());
// }
