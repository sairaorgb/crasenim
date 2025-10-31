import 'dart:ui';
import 'package:crasenimpharma/pages/homePage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeHomePage extends StatelessWidget {
  const WelcomeHomePage({super.key});

  // Colors tuned to match earlier palette
  static const Color brandBlue = Color(0xFF0EA5C9);
  static const Color accentTeal = Color(0xFF0EA5C9);
  static const Color paleBg = Color(0xFFF8FAFC);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // subtle gradient background
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [paleBg, Colors.white],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 800;
              final horizontalPadding = isWide ? 56.0 : 20.0;
              final logoWidth = isWide
                  ? constraints.maxWidth * 0.36
                  : constraints.maxWidth * 0.6;
              final titleSize = isWide ? 52.0 : 24.0;
              final subtitleSize = isWide ? 16.0 : 13.0;

              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: 28,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 1200),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // RIGHT: Big logo
                        _LogoPanel(width: logoWidth),
                        // LEFT: Card with title, tagline and vertical button column
                        _LeftCard(
                          titleSize: titleSize,
                          subtitleSize: subtitleSize,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Left card with title / subtitle and vertical buttons
class _LeftCard extends StatelessWidget {
  final double titleSize;
  final double subtitleSize;
  const _LeftCard({required this.titleSize, required this.subtitleSize});

  // Reuse brand colors
  static const Color brandBlue = Color(0xFF2563EB);

  Widget _buildButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    ButtonStyle? style,
    bool outline = false,
  }) {
    final baseStyle = ElevatedButton.styleFrom(
      elevation: outline ? 0 : 6,
      shadowColor: Colors.black.withOpacity(0.12),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );

    if (outline) {
      return OutlinedButton.icon(
        onPressed: onPressed,
        style: baseStyle.copyWith(
          backgroundColor: MaterialStateProperty.all(Colors.white),
          side: MaterialStateProperty.all(
            BorderSide(color: brandBlue.withOpacity(0.12)),
          ),
        ),
        icon: Icon(icon, color: Colors.white, size: 18),
        label: Text(
          label,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: brandBlue,
            letterSpacing: 0.3,
          ),
        ),
      );
    }

    return ElevatedButton.icon(
      onPressed: onPressed,
      style:
          style ??
          baseStyle.copyWith(
            backgroundColor: MaterialStateProperty.all(brandBlue),
          ),
      icon: Icon(icon, size: 16, color: Colors.white),
      label: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: 18,
            color: Colors.white,
            letterSpacing: 0.4,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cardColor = Colors.white.withOpacity(0.85);

    return Flexible(
      flex: 6,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 22),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Spacer(flex: 2),
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Brand title
                      Text(
                        'Crasenim Pharma',
                        style: GoogleFonts.poppins(
                          fontSize: titleSize,
                          fontWeight: FontWeight.w800,
                          color: Colors.black87,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Delivering knowledge that heals — select an option to continue.',
                        style: GoogleFonts.inter(
                          fontSize: subtitleSize,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 40),

                      // small divider line
                      Container(
                        height: 1,
                        color: Colors.grey.withOpacity(0.12),
                      ),
                      const SizedBox(height: 18),

                      // Buttons column
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                // width: double.infinity,
                                child: _buildButton(
                                  context: context,
                                  label: '   Login    ',
                                  icon: Icons.play_circle_fill,
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: brandBlue,
                                  ),
                                ),
                              ),

                              // About us: secondary (teal) variant
                              SizedBox(
                                // width: double.infinity,
                                child: _buildButton(
                                  context: context,
                                  label: ' Signup ',
                                  icon: Icons.info_outline,

                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: brandBlue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                // width: double.infinity,
                                child: _buildButton(
                                  context: context,
                                  label: 'Detailing',
                                  icon: Icons.info_outline,
                                  onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Homepage(),
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: brandBlue,
                                  ),
                                ),
                              ),
                              SizedBox(
                                // width: double.infinity,
                                child: _buildButton(
                                  context: context,
                                  label: 'Products',
                                  icon: Icons.info_outline,
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: brandBlue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 32),
                      Row(
                        children: [
                          Icon(Icons.shield, size: 18, color: Colors.grey[500]),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Trusted clinical content • Compliance-ready',
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Spacer(flex: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Right-side panel with big logo
class _LogoPanel extends StatelessWidget {
  final double width;
  const _LogoPanel({required this.width});

  @override
  Widget build(BuildContext context) {
    // use same brand blue for a subtle ring
    return Flexible(
      flex: 5,
      child: Center(
        child: Container(
          width: width,
          height: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            // gradient: const LinearGradient(
            //   colors: [Colors.white, Color(0xFFEFF9FF)],
            //   begin: Alignment.topLeft,
            //   end: Alignment.bottomRight,
            // ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),

                blurRadius: 22,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/logo.jpeg', // your logo
                    fit: BoxFit.contain,
                    // keep it responsive inside container
                    width: width * 0.8,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
