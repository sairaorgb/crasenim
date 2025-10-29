import 'package:flutter/material.dart';

class DrawerUtil extends StatefulWidget {
  const DrawerUtil({super.key});

  @override
  State<DrawerUtil> createState() => _DrawerUtilState();
}

class _DrawerUtilState extends State<DrawerUtil> {
  final labels = ["MD Physician", "Gynae", "Pedia", "Ortho"];
  final icons = [
    Icons.medical_services, // MD Physician
    Icons.female, // Gynae
    Icons.child_care, // Pedia
    Icons.healing, // Ortho
  ];
  @override
  Widget build(BuildContext context) {
    return Drawer();
  }
}
