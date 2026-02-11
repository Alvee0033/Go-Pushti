import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CostSummaryCard extends StatelessWidget {
  final double totalCost;
  final double costPerKgMilk;
  final bool isDairy;
  final LinearGradient gradient;
  final String totalCostLabel;
  final String costPerKgLabel;

  const CostSummaryCard({
    super.key,
    required this.totalCost,
    required this.costPerKgMilk,
    required this.isDairy,
    required this.gradient,
    this.totalCostLabel = 'Total Cost / Day',
    this.costPerKgLabel = 'Cost / Kg Milk',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: gradient.colors.first.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.account_balance_wallet_rounded,
                      color: Colors.white70,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        totalCostLabel,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '৳${totalCost.toStringAsFixed(0)}',
                  style: GoogleFonts.poppins(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          if (isDairy) ...[
            Container(width: 1, height: 60, color: Colors.white24),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.local_drink_rounded,
                        color: Colors.white70,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          costPerKgLabel,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '৳${costPerKgMilk.toStringAsFixed(1)}',
                    style: GoogleFonts.poppins(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
