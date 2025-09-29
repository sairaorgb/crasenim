import 'package:crasenimpharma/pages/slideshowPage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Presentationpage extends StatelessWidget {
  final List<String> imageList;
  Presentationpage({super.key, required this.imageList});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FullscreenCarousel(images: imageList),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.blue,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.03,
            vertical: MediaQuery.of(context).size.height * 0.02,
          ),
          child: Text(
            'Start presentation',
            style: GoogleFonts.secularOne(
              fontSize: MediaQuery.of(context).size.height * 0.04,
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
