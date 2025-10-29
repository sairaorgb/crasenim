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
    ['2.jpg', '3.jpg', '4.jpg', '5.jpg', '6.jpg'],
    ['8.jpg', '4.jpg', '6.jpg', '5G.jpg'],
    ['7.jpg'],
    ['5.jpg', '4.jpg', '6.jpg'],
  ];
  late List<String> currScopeImages;

  @override
  Widget build(BuildContext context) {
    currScopeImages = groupedImages[grpIndex];
    final mq = MediaQuery.of(context);
    final size = mq.size;
    final isTablet = size.shortestSide >= 600;
    // side panel width for tablet, clamped to reasonable sizes
    final sideWidth = (size.width * 0.22).clamp(200.0, size.width * 0.38);

    // Helper to build the menu list used for both drawer and tablet pane
    Widget buildMenu() {
      return ListView(
        children: [
          DrawerHeader(
            child: GestureDetector(
              onTap: () => {if (!isTablet) Navigator.pop(context)},
              child: Image.asset(
                'assets/images/logo.jpeg',
                height: isTablet ? size.height * 0.25 : size.height * 0.2,
                width: isTablet ? sideWidth * 0.9 : size.width * 0.4,
                fit: BoxFit.contain,
              ),
            ),
          ),
          ...["MD Physician", "Gynae", "Pedia", "Ortho"].asMap().entries.map((
            e,
          ) {
            final idx = e.key;
            final label = e.value;
            return Material(
              color: grpIndex == idx ? Colors.blue[300] : Colors.white,
              child: ListTile(
                title: Text(
                  label,
                  style: GoogleFonts.secularOne(
                    fontSize: (size.height * (isTablet ? 0.022 : 0.02)).clamp(
                      12.0,
                      22.0,
                    ),
                  ),
                ),
                onTap: () => setState(() {
                  grpIndex = idx;
                  currScopeImages = groupedImages[grpIndex];
                  if (!isTablet) Navigator.pop(context);
                }),
              ),
            );
          }).toList(),
        ],
      );
    }

    return Scaffold(
      // on phones provide a drawer, on tablets show a permanent side pane
      drawer: isTablet
          ? null
          : Drawer(backgroundColor: Colors.white, child: buildMenu()),
      body: isTablet
          ? Row(
              children: [
                Container(
                  width: sideWidth,
                  color: Colors.white,
                  child: buildMenu(),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      Center(
                        child: Image.asset(
                          'assets/images/logo.jpeg',
                          opacity: AlwaysStoppedAnimation(0.1),
                          fit: BoxFit.contain,
                          width: size.width * 0.6,
                        ),
                      ),
                      // Place the presentation button with some padding on larger screens
                      Positioned(
                        right: 24,
                        top: 24,
                        child: Presentationpage(imageList: currScopeImages),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Stack(
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
    );
  }
}
