import 'package:crasenimpharma/database.dart';
import 'package:crasenimpharma/pages/presentationPage.dart';
import 'package:crasenimpharma/utils/selectMeds.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailingHomePage extends StatefulWidget {
  final String specialityLabel;
  final List<String> specMedicinceList;
  const DetailingHomePage({
    super.key,
    required this.specMedicinceList,
    required this.specialityLabel,
  });

  @override
  State<DetailingHomePage> createState() => _DetailingHomePageState();
}

class _DetailingHomePageState extends State<DetailingHomePage> {
  late Database db;
  late List<String> totalMedicinesList;
  late List<String> currInstanceSpecMedicineList;
  late List<List<dynamic>> currInstanceTotalMedicineList;

  @override
  void initState() {
    super.initState();
    db = Database();
    totalMedicinesList = db.totalMedicines;
    currInstanceSpecMedicineList = widget.specMedicinceList;
    setInstanceScope();
  }

  @override
  void didUpdateWidget(DetailingHomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    currInstanceSpecMedicineList = widget.specMedicinceList;
    setInstanceScope();
  }

  void setInstanceScope() {
    final totSet = widget.specMedicinceList.toSet();
    final excludedMeds = totalMedicinesList
        .where((e) => !totSet.contains(e))
        .toList();
    currInstanceTotalMedicineList = [];
    widget.specMedicinceList.forEach(
      (e) => currInstanceTotalMedicineList.add([e, true]),
    );
    excludedMeds.forEach((e) => currInstanceTotalMedicineList.add([e, false]));
  }

  void changeInstanceScope(String med, bool currBool) {
    setState(() {
      final currIndex = currInstanceTotalMedicineList.indexWhere(
        (item) => item[0] == med,
      );
      currInstanceTotalMedicineList[currIndex] = [med, !currBool];
      currBool
          ? currInstanceSpecMedicineList.remove(med)
          : currInstanceSpecMedicineList.add(med);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Expanded(
      child: Stack(
        children: [
          Center(
            child: Image.asset(
              'assets/images/logo.jpeg',
              opacity: AlwaysStoppedAnimation(0.07),
              fit: BoxFit.contain,
              width: size.width * 0.6,
            ),
          ),
          Positioned.fill(
            left: 0,
            top: 160,
            child:
                // speciality
                // list of medicines
                Expanded(
                  child: MedicineGridWidget(
                    items: currInstanceTotalMedicineList.sublist(1),
                    onActionPressed: changeInstanceScope,
                  ),
                ),
          ),
          Positioned(
            right: 48, // Increased padding
            left: 48,
            top: 48, // Increased padding
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.specialityLabel,
                  style: GoogleFonts.secularOne(fontSize: 22, letterSpacing: 1),
                ),
                Presentationpage(imageList: currInstanceSpecMedicineList),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
