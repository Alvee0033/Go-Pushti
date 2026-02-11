import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NutrientBar extends StatelessWidget {
  final String label;
  final double required_;
  final double supplied;
  final String unit;
  final Color metColor;
  final Color deficitColor;
  final String requiredLabel;
  final String suppliedLabel;

  const NutrientBar({
    super.key,
    required this.label,
    required this.required_,
    required this.supplied,
    required this.unit,
    this.metColor = const Color(0xFF66BB6A),
    this.deficitColor = const Color(0xFFEF5350),
    this.requiredLabel = 'Required',
    this.suppliedLabel = 'Supplied',
  });

  @override
  Widget build(BuildContext context) {
    final double maxVal =
        (required_ > supplied ? required_ : supplied) * 1.15;
    final double reqFrac = maxVal > 0 ? required_ / maxVal : 0;
    final double supFrac = maxVal > 0 ? supplied / maxVal : 0;
    final bool isMet = supplied >= required_;
    final Color barColor = isMet ? metColor : deficitColor;
    final double balance = supplied - required_;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color:
                      isMet
                          ? metColor.withValues(alpha: 0.12)
                          : deficitColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isMet
                      ? '+${balance.toStringAsFixed(1)} $unit'
                      : '${balance.toStringAsFixed(1)} $unit',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: barColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _BarRow(
            label: requiredLabel,
            value: required_.toStringAsFixed(1),
            unit: unit,
            fraction: reqFrac,
            color: Colors.grey[400]!,
          ),
          const SizedBox(height: 8),
          _BarRow(
            label: suppliedLabel,
            value: supplied.toStringAsFixed(1),
            unit: unit,
            fraction: supFrac,
            color: barColor,
          ),
        ],
      ),
    );
  }
}

class _BarRow extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final double fraction;
  final Color color;

  const _BarRow({
    required this.label,
    required this.value,
    required this.unit,
    required this.fraction,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(fontSize: 11, color: Colors.grey[600]),
            ),
            Text(
              '$value $unit',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: fraction.clamp(0.0, 1.0),
            minHeight: 10,
            backgroundColor: Colors.grey[100],
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}
