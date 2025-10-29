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
    ['1.jpg', '2.jpg', '3.jpg', '4.jpg', '5.jpg', '6.jpg'],
    ['1.jpg', '5G.jpg', '8.jpg', '4.jpg', '6.jpg'],
    ['1.jpg', '7.jpg'],
    ['5.jpg', '4.jpg', '6.jpg'],
  ];
  late List<String> currScopeImages;

  // Helper to build the menu list used for both drawer and tablet pane
  Widget _buildMenu(double sideWidth, bool isTablet, Size size) {
    // Put these near top of file or inside your widget build scope
    final labels = ["MD Physician", "Gynae", "Pedia", "Ortho"];
    final icons = [
      Icons.medical_services, // MD Physician
      Icons.female, // Gynae
      Icons.child_care, // Pedia
      Icons.healing, // Ortho
    ];

    // The improved drawer widget
    return Container(
      width: sideWidth,
      decoration: BoxDecoration(
        // subtle card feel and rounded right edge
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
        borderRadius: BorderRadius.horizontal(right: Radius.circular(16)),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Header with a soft background and logo
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? 20 : 12,
                vertical: isTablet ? 20 : 12,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.white, Colors.white.withOpacity(0.98)],
                ),
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: GestureDetector(
                onTap: () {
                  if (!isTablet) Navigator.pop(context);
                },
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Row(
                    children: [
                      // Logo as rounded avatar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          'assets/images/logo.png',
                          height: isTablet ? 72 : 56,
                          width: isTablet ? 72 : 56,
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(width: 20),
                      // Brand title & tagline
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Crasenim Pharma',
                              style: GoogleFonts.poppins(
                                fontSize: isTablet ? 18 : 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'For healthy life',
                              style: GoogleFonts.poppins(
                                fontSize: isTablet ? 12 : 10,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Divider / spacing
            SizedBox(height: 12),

            // Menu list (use Expanded so it scrolls)
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 8),
                itemCount: labels.length,
                itemBuilder: (context, idx) {
                  final label = labels[idx];
                  final selected = grpIndex == idx;
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 14 : 10,
                      vertical: 6,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => setState(() {
                          grpIndex = idx;
                          currScopeImages = groupedImages[grpIndex];
                          if (!isTablet) Navigator.pop(context);
                        }),
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 220),
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: isTablet ? 14 : 12,
                          ),
                          decoration: BoxDecoration(
                            color: selected
                                ? Color(0xFF3B82F6).withOpacity(0.12)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: selected
                                ? Border.all(
                                    color: Color(0xFF3B82F6).withOpacity(0.18),
                                  )
                                : Border.all(color: Colors.transparent),
                            boxShadow: [
                              if (!selected)
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.02),
                                  blurRadius: 8,
                                  offset: Offset(0, 3),
                                ),
                            ],
                          ),
                          child: Row(
                            children: [
                              // Left accent indicator (pill)
                              AnimatedContainer(
                                duration: Duration(milliseconds: 220),
                                width: 4,
                                height: isTablet ? 36 : 32,
                                decoration: BoxDecoration(
                                  color: selected
                                      ? Color(0xFF3B82F6)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              SizedBox(width: 12),

                              // Icon (use asset logos if you have them)
                              CircleAvatar(
                                radius: isTablet ? 18 : 16,
                                backgroundColor: selected
                                    ? Color(0xFF3B82F6).withOpacity(0.14)
                                    : Colors.grey[100],
                                child: Icon(
                                  icons[idx],
                                  size: isTablet ? 20 : 18,
                                  color: selected
                                      ? Color(0xFF3B82F6)
                                      : Colors.grey[700],
                                ),
                              ),

                              SizedBox(width: 12),

                              // Label + optional subtitle
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      label,
                                      style: GoogleFonts.poppins(
                                        fontSize:
                                            (size.height *
                                                    (isTablet ? 0.020 : 0.018))
                                                .clamp(12.0, 18.0),
                                        fontWeight: selected
                                            ? FontWeight.w700
                                            : FontWeight.w600,
                                        letterSpacing: 0.6,
                                        color: selected
                                            ? Colors.black87
                                            : Colors.black87,
                                      ),
                                    ),
                                    // optional tiny subtitle / count
                                    // SizedBox(height: 2),
                                    // Text('12 doctors', style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                                  ],
                                ),
                              ),

                              // Right chevron for affordance
                              Icon(
                                Icons.chevron_right,
                                color: selected
                                    ? Color(0xFF3B82F6)
                                    : Colors.grey[400],
                                size: isTablet ? 26 : 22,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Optional footer for quick action
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, isTablet ? 48 : 44),
                  // backgroundColor: Color(0xFF06B6D4), // teal-ish accent
                  backgroundColor: Color(0xFF3B82F6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 6,
                  shadowColor: Colors.black.withOpacity(0.12),
                ),
                onPressed: () {
                  // Demo action
                },
                icon: Icon(Icons.power_settings_new_rounded),
                label: Text(
                  'Logout',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    currScopeImages = groupedImages[grpIndex];
    final mq = MediaQuery.of(context);
    final size = mq.size;
    final isTablet = size.shortestSide >= 600;
    // side panel width for tablet, clamped to reasonable sizes
    final sideWidth = (size.width * 0.22).clamp(200.0, size.width * 0.38);

    return Scaffold(
      // on phones provide a drawer, on tablets show a permanent side pane
      backgroundColor: Color(0xFFF9FAFB),
      drawer: isTablet
          ? null
          : Drawer(
              backgroundColor: Colors.white, // Keep background white
              elevation: 8.0, // Add elevation for a soft shadow
              shape: RoundedRectangleBorder(
                // Add border radius to the drawer
                borderRadius: BorderRadius.horizontal(
                  right: Radius.circular(16),
                ),
              ),
              child: _buildMenu(sideWidth, isTablet, size),
            ),
      body: isTablet
          ? Row(
              children: [
                Container(
                  width: sideWidth,
                  // Use BoxDecoration for color, border radius, and shadow
                  decoration: BoxDecoration(
                    color: Colors.white, // Background color
                    borderRadius: BorderRadius.horizontal(
                      right: Radius.circular(16),
                    ), // Border radius
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3), // Soft shadow
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: Offset(4, 0), // Shadow to the right
                      ),
                    ],
                  ),
                  child: _buildMenu(sideWidth, isTablet, size),
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
                      // Place the presentation button with more padding on larger screens
                      Positioned(
                        right: 48, // Increased padding
                        top: 48, // Increased padding
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
                  right: 20, // Increased padding
                  top: 40, // Increased padding
                  child: Presentationpage(imageList: currScopeImages),
                ),
              ],
            ),
    );
  }
}
