import 'package:crasenimpharma/pages/OTPpage.dart';
import 'package:crasenimpharma/pages/homePage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Welcomepage extends StatelessWidget {
  final bool isLoggedIn;
  const Welcomepage({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final size = mq.size;
    // Use shortestSide breakpoint to detect tablet-like layouts
    final isTablet = size.shortestSide >= 600;

    // Scaled sizes with reasonable clamps
    final logoHeight = isTablet ? size.height * 0.65 : size.height * 0.28;
    final buttonFont = (isTablet ? size.height * 0.035 : size.height * 0.03)
        .clamp(16.0, 36.0);
    final buttonPaddingH = isTablet ? size.width * 0.08 : size.width * 0.06;
    final buttonPaddingV = isTablet ? size.height * 0.03 : size.height * 0.02;

    // Colors tuned to match earlier palette
    const Color brandBlue = Color(0xFF3B82F6);
    const Color accentTeal = Color(0xFF0EA5C9);
    const Color paleBg = Color(0xFFF8FAFC);

    return Scaffold(
      backgroundColor: Colors.white,
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
                        ),
                      ),

                      // Button area with responsive width and padding
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.08,
                        ),
                        child: SizedBox(
                          width: size.width * 0.3,

                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: EdgeInsets.symmetric(
                                horizontal: buttonPaddingH,
                                vertical: buttonPaddingV,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => isLoggedIn
                                    ? Homepage()
                                    : VerificationPagePage(),
                              ),
                            ),
                            child: Text(
                              'Login',
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
