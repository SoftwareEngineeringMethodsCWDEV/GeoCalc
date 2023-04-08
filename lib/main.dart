import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:from_empty/casket_classes.dart';

import 'casket_scheme.dart';

void main() {
  final loadedLabels = LinkedList<KernLabel>();
  KernLabel fstStart = KernLabel(true, 0, 0, 5, Colors.green);
  KernLabel fstEnd = KernLabel(true, 200, 5.5, 5, Colors.grey);
  loadedLabels.addAll([
    KernLabel(false, 0, 0, 5, Colors.green),
    fstStart,
    KernLabel(false, 50, 1.5, 5, Colors.green),
    KernLabel(false, 75, 2, 5, Colors.blue),
    KernLabel(false, 150, 3.4, 5, Colors.grey),
    fstEnd,
    KernLabel(false, 210, 5.6, 5, Colors.yellow),
  ]);

  runApp(MaterialApp(
      home: Scaffold(
          appBar: AppBar(title: const Text('Fl')),
          body: CasketScheme(fstStart, fstEnd))));
}
