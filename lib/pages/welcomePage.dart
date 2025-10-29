import 'package:crasenimpharma/pages/homePage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Welcomepage extends StatelessWidget {
  const Welcomepage({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final size = mq.size;
    // Use shortestSide breakpoint to detect tablet-like layouts
    final isTablet = size.shortestSide >= 600;

    // Scaled sizes with reasonable clamps
    final logoHeight = isTablet ? size.height * 0.45 : size.height * 0.28;
    final buttonFont = (isTablet ? size.height * 0.035 : size.height * 0.03)
        .clamp(16.0, 36.0);
    final buttonPaddingH = isTablet ? size.width * 0.08 : size.width * 0.06;
    final buttonPaddingV = isTablet ? size.height * 0.03 : size.height * 0.02;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Spacer above logo on larger screens for balance
                      Spacer(flex: isTablet ? 2 : 1),

                      // Logo (scales with available height)
                      Center(
                        child: Image.asset(
                          'assets/images/logo.jpeg',
                          height: logoHeight,
                          fit: BoxFit.contain,
                          filterQuality: FilterQuality.high,
                        ),
                      ),

                      Spacer(flex: 1),

                      // Button area with responsive width and padding
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.08,
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: EdgeInsets.symmetric(
                                horizontal: buttonPaddingH,
                                vertical: buttonPaddingV,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Homepage(),
                              ),
                            ),
                            child: Text(
                              'Detailing',
                              style: GoogleFonts.secularOne(
                                fontSize: buttonFont,
                                fontWeight: FontWeight.w300,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),

                      Spacer(flex: isTablet ? 3 : 2),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
