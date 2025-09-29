import 'package:crasenimpharma/pages/presentationPage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  var grpIndex = 0;
  var groupedImages = [
    [''],
    [''],
    [''],
    [''],
    [''],
    [''],
  ];
  late List<String> currScopeImages;

  @override
  Widget build(BuildContext context) {
    currScopeImages = groupedImages[grpIndex];
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Drawer(
            backgroundColor: Colors.white,
            width: MediaQuery.of(context).size.width * 0.2,
            child: ListView(
              children: [
                DrawerHeader(
                  child: GestureDetector(
                    onTap: () => {Navigator.pop(context)},
                    child: Image.asset(
                      'assets/images/logo.jpeg',
                      height: MediaQuery.of(context).size.height * 0.6,
                      width: MediaQuery.of(context).size.width * 0.4,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                ListTile(
                  title: Text(
                    'Chest',
                    style: GoogleFonts.secularOne(
                      fontSize: MediaQuery.of(context).size.height * 0.02,
                    ),
                  ),
                  tileColor: grpIndex == 0 ? Colors.blue[300] : Colors.white,
                  onTap: () => setState(() {
                    grpIndex = 0;
                    currScopeImages = groupedImages[grpIndex];
                  }),
                ),
                ListTile(
                  title: Text(
                    'Tricep',
                    style: GoogleFonts.secularOne(
                      fontSize: MediaQuery.of(context).size.height * 0.02,
                    ),
                  ),
                  tileColor: grpIndex == 1 ? Colors.blue[300] : Colors.white,
                  onTap: () => setState(() {
                    grpIndex = 1;
                    currScopeImages = groupedImages[grpIndex];
                  }),
                ),
                ListTile(
                  title: Text(
                    'Shoulder',
                    style: GoogleFonts.secularOne(
                      fontSize: MediaQuery.of(context).size.height * 0.02,
                    ),
                  ),
                  tileColor: grpIndex == 2 ? Colors.blue[300] : Colors.white,
                  onTap: () => setState(() {
                    grpIndex = 2;
                    currScopeImages = groupedImages[grpIndex];
                  }),
                ),
                ListTile(
                  title: Text(
                    'ForeArm',
                    style: GoogleFonts.secularOne(
                      fontSize: MediaQuery.of(context).size.height * 0.02,
                    ),
                  ),
                  tileColor: grpIndex == 3 ? Colors.blue[300] : Colors.white,
                  onTap: () => setState(() {
                    grpIndex = 3;
                    currScopeImages = groupedImages[grpIndex];
                  }),
                ),
                ListTile(
                  title: Text(
                    'Lats',
                    style: GoogleFonts.secularOne(
                      fontSize: MediaQuery.of(context).size.height * 0.02,
                    ),
                  ),
                  tileColor: grpIndex == 4 ? Colors.blue[300] : Colors.white,
                  onTap: () => setState(() {
                    grpIndex = 4;
                    currScopeImages = groupedImages[grpIndex];
                  }),
                ),
                ListTile(
                  title: Text(
                    'Bicep',
                    style: GoogleFonts.secularOne(
                      fontSize: MediaQuery.of(context).size.height * 0.02,
                    ),
                  ),
                  tileColor: grpIndex == 5 ? Colors.blue[300] : Colors.white,
                  onTap: () => setState(() {
                    grpIndex = 5;
                    currScopeImages = groupedImages[grpIndex];
                  }),
                ),
              ],
            ),
          ),
          Stack(
            children: [
              Center(
                child: Image.asset(
                  'assets/images/logo.jpeg',
                  opacity: AlwaysStoppedAnimation(0.1),
                ),
              ),
              Positioned(
                right: 0,
                top: 20,
                child: Presentationpage(imageList: currScopeImages),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
