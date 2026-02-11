import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/ingredient.dart';
import '../providers/language_provider.dart';
import '../theme/app_theme.dart';

class IngredientTile extends StatelessWidget {
  final Ingredient ingredient;
  final ValueChanged<double> onInclusionChanged;
  final ValueChanged<double> onPriceChanged;

  const IngredientTile({
    super.key,
    required this.ingredient,
    required this.onInclusionChanged,
    required this.onPriceChanged,
  });

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context);
    final Color accent = AppTheme.categoryColor(ingredient.category);
    final bool isActive = ingredient.inclusionRate > 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: isActive ? accent : Colors.grey[300],
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () => _showPriceDialog(context, accent, lang),
                  child: Text(
                    ingredient.displayName(lang.isBengali),
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                      color: isActive ? AppTheme.textPrimary : Colors.grey[500],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 44,
                child: Text(
                  '${ingredient.inclusionRate.toStringAsFixed(0)}%',
                  textAlign: TextAlign.right,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isActive ? accent : Colors.grey[400],
                  ),
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: accent,
              inactiveTrackColor: accent.withValues(alpha: 0.10),
              thumbColor: isActive ? accent : Colors.grey[400],
              overlayColor: accent.withValues(alpha: 0.08),
              trackHeight: 3,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
            ),
            child: Slider(
              value: ingredient.inclusionRate,
              min: 0,
              max: 60,
              divisions: 60,
              onChanged: onInclusionChanged,
            ),
          ),
        ],
      ),
    );
  }

  void _showPriceDialog(BuildContext context, Color accent, LanguageProvider lang) {
    final controller = TextEditingController(
      text: ingredient.pricePerKg.toStringAsFixed(0),
    );
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          ingredient.displayName(lang.isBengali),
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              lang.t('প্রতি কেজি মূল্য (৳)', 'Price per kg (৳)'),
              style: GoogleFonts.inter(fontSize: 13, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              autofocus: true,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
              decoration: InputDecoration(
                prefixText: '৳ ',
                prefixStyle: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: accent,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(lang.t('বাতিল', 'Cancel')),
          ),
          FilledButton(
            onPressed: () {
              final val = double.tryParse(controller.text);
              if (val != null) onPriceChanged(val);
              Navigator.pop(ctx);
            },
            child: Text(lang.t('সংরক্ষণ', 'Save')),
          ),
        ],
      ),
    );
  }
}
