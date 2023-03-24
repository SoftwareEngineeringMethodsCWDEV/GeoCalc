//import 'package:flutter/material.dart'; - нужно будет подгрузить
class Color {
  int c;
  Color(this.c);
}

//Основа для всех вычислений это Этикетка - вводится пользователем => все расчёты исходят от неё
class KernLabel {
  final int casketsDistance; // в сантиметрах (мб double, мб long )
  final double depth; // в метрах
  final double coreOutput; // соотношение

  final Color groundType; // цвет для рейса до этикетки

  const KernLabel(
      this.casketsDistance, this.depth, this.coreOutput, this.groundType);
}

/* думаю не нужно
class CasketRow {
}
*/

class Casket {
  double _casketsDistance; // в сантиметрах (всегда % 100)
  double _depth; // в метрах (глубина начала ящика) -

  int _rowAmount;
  List<KernLabel> _insideLabels;
  KernLabel? _nextLabel;

  Casket(this._casketsDistance,
      this._depth) // или можно через factory Casket.createEmpty()
      : _insideLabels = [],
        _rowAmount = 0;

  // sets
  set newRowAmount(int amount) {
    // разные проверки
    _rowAmount = amount;
  }

  // полезные gets
  double get averageCoreOutput => 0.5 /*функция считающая среднее ВК в ящике*/;
  double get endDistance => _casketsDistance + _rowAmount * 100;
  int get number => (_casketsDistance / 100).round();

  // функции
  String showInfo() =>
      'dist: $_casketsDistance, dpth: $_depth, rows: $_rowAmount, lbls: ${_insideLabels.length}, next: ${_nextLabel != null}, avg: ${averageCoreOutput}';
}

// перевод от "скважина"
class DrillHole {
  String name;

  List<KernLabel> _labels;
  List<Casket> _caskets;
  // если что-то меняется в середине списка, то нужно пройти до конца и пересчитать все остальные

  DrillHole(String this.name)
      : _labels = [],
        _caskets = [];

  // gets
  double get depth => this._labels.last.depth;
  int get casketsAmount => this._caskets.length;
}

class TheGeoApp {
  List<DrillHole> _drillHoles;
  //Settings - в виде singleton

  TheGeoApp() : _drillHoles = [];
}

//usage testing
void main(List<String> args) {
  List<KernLabel> drillHole = [];
  double drillDepth = 0;
  List<Casket> caskets = [];
  double casketsDistance = 0;

  caskets.add(Casket(casketsDistance, drillDepth));
  print(caskets.last.showInfo());

  drillHole.add(KernLabel(80, 1.0, 0.5, Color(5)));
  drillHole.add(KernLabel(70, 1.8, 1.0, Color(54)));
}
