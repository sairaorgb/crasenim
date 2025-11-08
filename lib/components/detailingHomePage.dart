import 'package:crasenimpharma/database.dart';
import 'package:crasenimpharma/pages/presentationPage.dart';
import 'package:crasenimpharma/pages/welcomePage.dart';
import 'package:crasenimpharma/utils/selectMeds.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

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
  late var box;
  late List<String> totalMedicinesList;
  late List<String> currInstanceSpecMedicineList;
  late List<List<dynamic>> currInstanceTotalMedicineList;

  @override
  void initState() {
    super.initState();
    db = Database();
    box = Hive.box('myBox');
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
          // Positioned.fill(
          //   left: 0,
          //   top: 160,
          //   child:
          //       // speciality
          //       // list of medicines
          //       Expanded(
          //         child: MedicineGridWidget(
          //           items: currInstanceTotalMedicineList.sublist(1),
          //           onActionPressed: changeInstanceScope,
          //         ),
          //       ),
          // ),
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
          Positioned(
            width: 200,
            bottom: 48,
            right: 48,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 48),
                  // backgroundColor: Color(0xFF06B6D4), // teal-ish accent
                  backgroundColor: Color(0xFF3B82F6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 6,
                  shadowColor: Colors.black.withOpacity(0.12),
                ),
                onPressed: () {
                  box.put('creds', false);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Welcomepage(isLoggedIn: false),
                    ),
                    (Route<dynamic> route) => false,
                  );
                },
                icon: Icon(
                  Icons.power_settings_new_rounded,
                  color: Colors.white,
                ),
                label: Text(
                  'Logout',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
