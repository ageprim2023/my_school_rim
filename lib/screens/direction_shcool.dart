

import 'package:flutter/material.dart';
import 'package:my_school_rim/models/utilisateurs.dart';
import 'package:my_school_rim/widgets/drawer.dart';

class DirectionSchool extends StatefulWidget {
  static const root = 'DirectionSchool';
  const DirectionSchool({super.key});

  @override
  State<DirectionSchool> createState() => _DirectionSchoolState();
}

class _DirectionSchoolState extends State<DirectionSchool> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إدارة مدرسة'),centerTitle: true),
    );
  }
}