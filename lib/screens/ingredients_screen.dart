import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/cattle_profile.dart';
import '../models/ingredient.dart';
import '../calculators/ration_calculator.dart';
import '../providers/language_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/ingredient_tile.dart';
import 'results_screen.dart';

class IngredientsScreen extends StatefulWidget {
  final String cattleName;
  final CattleProfile profile;
  final List<Ingredient> ingredients;

  const IngredientsScreen({
    super.key,
    required this.cattleName,
    required this.profile,
    required this.ingredients,
  });

  @override
  State<IngredientsScreen> createState() => _IngredientsScreenState();
}

class _IngredientsScreenState extends State<IngredientsScreen> {
  late List<Ingredient> _ingredients;

  @override
  void initState() {
    super.initState();
    _ingredients = widget.ingredients;
  }

  double get _totalInclusion =>
      _ingredients.fold(0.0, (sum, i) => sum + i.inclusionRate);

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context);
    final calc = RationCalculator();
    final result = calc.calculate(widget.profile, _ingredients);
    final total = _totalInclusion;
    final isBalanced = (total - 100).abs() < 0.5;

    final roughage =
        _ingredients.where((i) => i.category == 'Roughage').toList();
    final concentrate =
        _ingredients.where((i) => i.category == 'Concentrate').toList();
    final additive =
        _ingredients.where((i) => i.category == 'Additive').toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      appBar: AppBar(
        title: Text(
          widget.cattleName,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      body: Column(
        children: [
          _buildDashboard(result, total, isBalanced, lang),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 100),
              children: [
                _sectionLabel(lang.t('ঘাস ও খড়', 'GRASS & HAY')),
                ...roughage.map(_buildTile),
                _sectionLabel(lang.t('দানাদার ও প্রোটিন', 'GRAINS & PROTEIN')),
                ...concentrate.map(_buildTile),
                _sectionLabel(lang.t('সংযোজন', 'SUPPLEMENTS')),
                ...additive.map(_buildTile),
              ],
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ResultsScreen(
                cattleName: widget.cattleName,
                profile: widget.profile,
                ingredients: _ingredients,
              ),
            ),
          );
        },
        backgroundColor: isBalanced ? AppTheme.primary : AppTheme.deficit,
        foregroundColor: Colors.white,
        icon: Icon(
          isBalanced ? Icons.arrow_forward_rounded : Icons.warning_rounded,
        ),
        label: Text(
          isBalanced
              ? lang.t('ফলাফল দেখুন', 'See Results')
              : lang.t('মিশ্রণ ১০০% হতে হবে', 'Mix must be 100%'),
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildTile(Ingredient item) {
    return IngredientTile(
      ingredient: item,
      onInclusionChanged: (val) {
        setState(() => item.inclusionRate = val);
      },
      onPriceChanged: (val) {
        setState(() => item.pricePerKg = val);
      },
    );
  }

  Widget _buildDashboard(dynamic result, double total, bool isBalanced, LanguageProvider lang) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              lang.t('ধাপ ২/৩ · উপাদান নির্বাচন ও সমন্বয়', 'Step 2 of 3 · Select & adjust ingredients'),
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppTheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              _miniStat(
                lang.t('শক্তি', 'Energy'),
                '${result.requiredME.toStringAsFixed(0)} MJ',
                result.meIsMet ? AppTheme.met : AppTheme.deficit,
                result.meIsMet
                    ? Icons.check_circle_rounded
                    : Icons.cancel_rounded,
              ),
              const SizedBox(width: 10),
              _miniStat(
                lang.t('প্রোটিন', 'Protein'),
                '${result.requiredCP.toStringAsFixed(0)} g',
                result.cpIsMet ? AppTheme.met : AppTheme.deficit,
                result.cpIsMet
                    ? Icons.check_circle_rounded
                    : Icons.cancel_rounded,
              ),
              const SizedBox(width: 10),
              _miniStat(
                lang.t('খরচ/দিন', 'Cost/day'),
                '৳${result.totalCostPerDay.toStringAsFixed(0)}',
                AppTheme.primary,
                Icons.account_balance_wallet_rounded,
              ),
            ],
          ),
          const SizedBox(height: 10),

          Row(
            children: [
              Text(
                '${lang.t('মিশ্রণ', 'Mix')}: ${total.toStringAsFixed(0)}%',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isBalanced ? AppTheme.met : AppTheme.textSecondary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: (total / 100).clamp(0.0, 1.0),
                    minHeight: 8,
                    backgroundColor: Colors.grey[100],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isBalanced ? AppTheme.met : AppTheme.deficit,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                isBalanced ? Icons.check_circle : Icons.warning_rounded,
                size: 18,
                color: isBalanced ? AppTheme.met : AppTheme.deficit,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _miniStat(String label, String value, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(height: 4),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.inter(fontSize: 10, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 4, left: 16),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Colors.grey[400],
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
