import 'package:crasenimpharma/pages/homePage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Welcomepage extends StatelessWidget {
  const Welcomepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Align(
            alignment: Alignment.center,
            child: Image.asset(
              'assets/images/logo.jpeg',
              filterQuality: FilterQuality.high,
              // opacity: AlwaysStoppedAnimation(0.2),
            ),
          ),
          MaterialButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Homepage()),
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
                  'Detailing',
                  style: GoogleFonts.secularOne(
                    fontSize: MediaQuery.of(context).size.height * 0.04,
                    fontWeight: FontWeight.w300,
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
