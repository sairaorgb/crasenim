import 'package:crasenimpharma/database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SelectMedicine extends StatefulWidget {
  final List<String> currScopeMedicines;
  const SelectMedicine({super.key, required this.currScopeMedicines});

  @override
  State<SelectMedicine> createState() => _SelectMedicineState();
}

class _SelectMedicineState extends State<SelectMedicine> {
  Database db = Database();
  late List<String> totalMedicines;
  late List<List<dynamic>> medicineDisplayList;

  void setTotalScope() {
    final totSet = widget.currScopeMedicines.toSet();
    final excludedMeds = totalMedicines
        .where((e) => !totSet.contains(e))
        .toList();
    medicineDisplayList = [];
    widget.currScopeMedicines.forEach(
      (e) => medicineDisplayList.add([e, true]),
    );
    excludedMeds.forEach((e) => medicineDisplayList.add([e, false]));
  }

  void changeTotalScope(String med, bool currBool) {
    final currIndex = medicineDisplayList.indexOf([med, currBool]);
    medicineDisplayList[currIndex] = [med, !currBool];
  }

  void initState() {
    super.initState();
    totalMedicines = db.totalMedicines;
    setTotalScope();
  }

  @override
  Widget build(BuildContext context) {
    // return Column();
    return MedicineGridWidget(items: medicineDisplayList);
  }
}

/// Responsive grid of medicine cards.
/// items: List of [name: String, included: bool]
/// e.g. [ ['Aspirin', true], ['Paracetamol', false] ]
class MedicineGridWidget extends StatelessWidget {
  final List<List<dynamic>> items;
  final void Function(int index)? onActionPressed;
  final double minTileWidth; // controls how many columns at various widths
  final double tileAspect; // width/height ratio

  const MedicineGridWidget({
    Key? key,
    required this.items,
    this.onActionPressed,
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
              onActionPressed: onActionPressed == null
                  ? null
                  : () => onActionPressed!(index),
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
                        name,
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: mutedText,
                          height: 1.12,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 12),

                  // small footer row: hint text on left and subtle metadata on center/left
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 14,
                        color: Colors.grey[400],
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Tap add to include',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
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

/// items: List of [name: String, included: bool]
/// e.g. [ ['Aspirin', true], ['Paracetamol', false] ]
class MedicineListWidget extends StatelessWidget {
  final List<List<dynamic>> items;
  final void Function(int index)? onActionPressed;
  final bool dense; // smaller paddings if true

  const MedicineListWidget({
    Key? key,
    required this.items,
    this.onActionPressed,
    this.dense = false,
  }) : super(key: key);

  static const Color primaryBlue = Color(0xFF2563EB);
  static const Color accentTeal = Color(0xFF0EA5C9);
  static const Color mutedText = Color(0xFF374151);

  @override
  Widget build(BuildContext context) {
    final verticalPadding = dense ? 8.0 : 12.0;
    final rowHeight = dense ? 60.0 : 72.0;
    return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      itemCount: items.length,
      separatorBuilder: (_, __) => SizedBox(height: dense ? 10 : 14),
      itemBuilder: (context, index) {
        final entry = items[index];
        final name = (entry.isNotEmpty && entry[0] is String)
            ? entry[0] as String
            : 'Unnamed';
        final included = (entry.length > 1 && entry[1] is bool)
            ? entry[1] as bool
            : false;

        return _MedicineRow(
          index: index,
          name: name,
          included: included,
          height: rowHeight,
          verticalPadding: verticalPadding,
          onActionPressed: onActionPressed,
        );
      },
    );
  }
}

class _MedicineRow extends StatelessWidget {
  final int index;
  final String name;
  final bool included;
  final double height;
  final double verticalPadding;
  final void Function(int index)? onActionPressed;

  const _MedicineRow({
    Key? key,
    required this.index,
    required this.name,
    required this.included,
    required this.height,
    required this.verticalPadding,
    required this.onActionPressed,
  }) : super(key: key);

  static const Color primaryBlue = Color(0xFF2563EB);
  static const Color accentTeal = Color(0xFF0EA5C9);
  static const Color surfaceGray = Color(0xFFF8FAFB);
  static const Color subtleBorder = Color(0xFFE6EEF8);
  static const Color mutedText = Color(0xFF374151);

  @override
  Widget build(BuildContext context) {
    // Left accent shown when included (visual cue)
    final leftAccent = included ? primaryBlue : Colors.transparent;

    return Semantics(
      button: true,
      label: '${name}, ${included ? "included" : "not included"}',
      child: Material(
        color: Colors.transparent,
        child: Container(
          height: height,
          padding: EdgeInsets.symmetric(
            horizontal: 12,
            vertical: verticalPadding,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 12,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              // Left thin accent (4 px) — visible when included
              AnimatedContainer(
                duration: Duration(milliseconds: 260),
                width: 6,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: leftAccent,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              SizedBox(width: 12),

              // Leading icon (circular small)
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Color(0xFFF3F4F6),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.local_pharmacy,
                    size: 18,
                    color: included ? primaryBlue : Color(0xFF6B7280),
                  ),
                ),
              ),

              SizedBox(width: 12),

              // Name & optional subtitle
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: mutedText,
                      ),
                    ),
                    SizedBox(height: 4),
                    // optional secondary line (placeholder for dose/notes if you provide one)
                    Text(
                      'Tap the icon to ${included ? "remove" : "add"}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),

              // Status pill (optional) — example static placeholder
              // SizedBox(width: 8),
              // _StatusPill(text: 'OTC'),
              SizedBox(width: 12),

              // Action: Plus (if not included) / Minus (if included)
              _ActionCircle(
                included: included,
                onPressed: onActionPressed == null
                    ? null
                    : () => onActionPressed!(index),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionCircle extends StatelessWidget {
  final bool included;
  final VoidCallback? onPressed;

  const _ActionCircle({Key? key, required this.included, this.onPressed})
    : super(key: key);

  static const Color primaryBlue = Color(0xFF2563EB);
  static const Color accentTeal = Color(0xFF0EA5C9);
  static const Color outlineGray = Color(0xFFE6EEF8);

  @override
  Widget build(BuildContext context) {
    // Visual variants for plus / minus
    if (included) {
      // Filled gradient "minus" button (item is included → show minus to remove)
      return SizedBox(
        width: 48,
        height: 48,
        child: ElevatedButton(
          onPressed: onPressed,
          style:
              ElevatedButton.styleFrom(
                elevation: 8,
                shape: CircleBorder(),
                padding: EdgeInsets.all(0),
                backgroundColor: Colors.transparent,
              ).copyWith(
                // gradient background via Container wrapping below
                backgroundColor: MaterialStateProperty.all(Colors.transparent),
                shadowColor: MaterialStateProperty.all(
                  Colors.black.withOpacity(0.12),
                ),
              ),
          child: Ink(
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
            child: Container(
              constraints: BoxConstraints(minWidth: 48, minHeight: 48),
              alignment: Alignment.center,
              child: Icon(Icons.remove, color: Colors.white.withOpacity(0.95)),
            ),
          ),
        ),
      );
    } else {
      // Ghost "plus" button (item not included → show plus to add)
      return SizedBox(
        width: 48,
        height: 48,
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            shape: CircleBorder(),
            side: BorderSide(color: outlineGray),
            backgroundColor: Colors.white,
            padding: EdgeInsets.all(0),
          ),
          child: Icon(Icons.add, color: primaryBlue),
        ),
      );
    }
  }
}
