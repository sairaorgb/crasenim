import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MedicineGridWidget extends StatelessWidget {
  final List<List<dynamic>> items;
  final void Function(String, bool) onActionPressed;
  final double minTileWidth; // controls how many columns at various widths
  final double tileAspect; // width/height ratio

  const MedicineGridWidget({
    Key? key,
    required this.items,
    required this.onActionPressed,
    this.minTileWidth = 260,
    this.tileAspect = 1.05,
  }) : super(key: key);

  static const Color primaryBlue = Color(0xFF2563EB);
  static const Color accentTeal = Color(0xFF0EA5C9);
  static const Color mutedText = Color(0xFF374151);
  static const Color paleSurface = Color(0xFFFFFFFF);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        // Decide columns by available width (responsive)
        final columns = (maxWidth / minTileWidth).floor().clamp(1, 6);
        final crossAxisSpacing = 18.0;
        final mainAxisSpacing = 18.0;

        return GridView.builder(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: crossAxisSpacing,
            mainAxisSpacing: mainAxisSpacing,
            childAspectRatio: tileAspect,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final raw = items[index];
            final name = (raw.isNotEmpty && raw[0] is String)
                ? raw[0] as String
                : 'Unnamed';
            final included = (raw.length > 1 && raw[1] is bool)
                ? raw[1] as bool
                : false;

            return _MedicineCard(
              name: name,
              included: included,
              onActionPressed: () => onActionPressed(name, included),
            );
          },
        );
      },
    );
  }
}

class _MedicineCard extends StatelessWidget {
  final String name;
  final bool included;
  final VoidCallback? onActionPressed;
  const _MedicineCard({
    Key? key,
    required this.name,
    required this.included,
    this.onActionPressed,
  }) : super(key: key);

  static const Color primaryBlue = Color(0xFF2563EB);
  static const Color accentTeal = Color(0xFF0EA5C9);
  static const Color lightGray = Color(0xFFF3F4F6);
  static const Color subtleBorder = Color(0xFFE6EEF8);
  static const Color mutedText = Color(0xFF374151);

  @override
  Widget build(BuildContext context) {
    // Card design: roomy, rounded, subtle shadow. Action circle anchored bottom-right.
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          // Could open details — not action button. Keep tap separate from action circle.
        },
        child: Container(
          decoration: BoxDecoration(
            // color: Colors,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 14,
                offset: Offset(0, 8),
              ),
            ],
            border: Border.all(color: Colors.white),
          ),
          padding: EdgeInsets.fromLTRB(16, 18, 16, 16),
          child: Stack(
            children: [
              // Main content flows naturally; action circle is overlaid (bottom-right)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // leading area: small circular monogram / icon and optional tag
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // small circular monogram for quick scanning
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: lightGray,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            _initials(name),
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      // optional small status pill or category — left intentionally available
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Rx',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 12),

                  // Centered large name — allow wrapping but keep it elevated
                  Expanded(
                    child: Center(
                      child: Text(
                        name.substring(0, name.length - 4),
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.6,
                          color: mutedText,
                          height: 1.12,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 12),

                  // small footer row: hint text on left and subtle metadata on center/left
                  // Row(
                  //   children: [
                  //     Icon(
                  //       Icons.info_outline,
                  //       size: 14,
                  //       color: Colors.grey[400],
                  //     ),
                  //     SizedBox(width: 8),
                  //     Text(
                  //       'Tap add to include',
                  //       style: GoogleFonts.poppins(
                  //         fontSize: 12,
                  //         color: Colors.grey[500],
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),

              // Action circle pinned bottom-right (keeps layout consistent across grid)
              Positioned(
                right: 6,
                bottom: 6,
                child: _GridActionCircle(
                  included: included,
                  onPressed: onActionPressed,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _initials(String s) {
    final parts = s.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts[0].substring(0, 1).toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }
}

class _GridActionCircle extends StatelessWidget {
  final bool included;
  final VoidCallback? onPressed;
  const _GridActionCircle({Key? key, required this.included, this.onPressed})
    : super(key: key);

  static const Color primaryBlue = Color(0xFF2563EB);
  static const Color accentTeal = Color(0xFF0EA5C9);
  static const Color outlineGray = Color(0xFFE6EEF8);

  @override
  Widget build(BuildContext context) {
    // Keep visual weight consistent across states
    const double size = 46;
    if (included) {
      // Filled gradient circle with minus icon
      return GestureDetector(
        onTap: onPressed,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryBlue, accentTeal],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 12,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Center(
            child: Icon(Icons.remove, color: Colors.white, size: 20),
          ),
        ),
      );
    } else {
      // Outline circle with plus icon (lighter)
      return GestureDetector(
        onTap: onPressed,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: outlineGray),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Center(child: Icon(Icons.add, color: primaryBlue, size: 20)),
        ),
      );
    }
  }
}
