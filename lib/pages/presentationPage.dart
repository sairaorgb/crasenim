import 'package:crasenimpharma/pages/slideshowPage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Presentationpage extends StatelessWidget {
  final List<String> imageList;
  Presentationpage({super.key, required this.imageList});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final size = mq.size;
    final isTablet = size.shortestSide >= 600;
    final fontSize = (isTablet ? size.height * 0.03 : size.height * 0.035)
        .clamp(14.0, 26.0);
    final padH = isTablet ? size.width * 0.04 : size.width * 0.03;
    final padV = isTablet ? size.height * 0.02 : size.height * 0.018;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        padding: EdgeInsets.symmetric(horizontal: padH, vertical: padV),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FullscreenCarousel(images: imageList),
        ),
      ),
      child: Text(
        'Start presentation',
        style: GoogleFonts.secularOne(
          fontSize: fontSize,
          fontWeight: FontWeight.w300,
          color: Colors.white,
        ),
      ),
    );
  }
}
