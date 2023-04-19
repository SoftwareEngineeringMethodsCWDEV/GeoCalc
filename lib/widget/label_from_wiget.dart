// import 'package:flutter/material.dart';
//
// class LabelFormWidget extends StatelessWidget {
//   final String? name;
//   final ValueChanged<String> onChangedName;
//
//   const LabelFormWidget({
//     Key? key,
//     this.name = '',
//     required this.onChangedName,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) => SingleChildScrollView(
//     child: Padding(
//       padding: EdgeInsets.all(16),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Row(
//
//
//
//           ),
//           buildName(),
//           SizedBox(height: 8),
//           SizedBox(height: 16),
//         ],
//       ),
//     ),
//   );
//
//   Widget buildName() => TextFormField(
//     maxLines: 1,
//     initialValue: name,
//     style: TextStyle(
//       color: Colors.black,
//       fontWeight: FontWeight.bold,
//       fontSize: 24,
//     ),
//     decoration: InputDecoration(
//       border: InputBorder.none,
//       hintText: 'Name',
//       hintStyle: TextStyle(color: Colors.black),
//     ),
//     validator: (name) =>
//     name != null && name.isEmpty ? 'The name cannot be empty' : null,
//     onChanged: onChangedName,
//   );
//
//   Widget buildDescription() => TextFormField(
//     maxLines: 5,
//     style: TextStyle(color: Colors.black, fontSize: 18),
//     decoration: InputDecoration(
//       border: InputBorder.none,
//       hintText: 'Type something...',
//       hintStyle: TextStyle(color: Colors.black),
//     ),
//     validator: (name) => name != null && name.isEmpty
//         ? 'The description cannot be empty'
//         : null,
//   );
// }