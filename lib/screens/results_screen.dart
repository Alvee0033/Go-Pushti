import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/cattle_profile.dart';
import '../models/ingredient.dart';
import '../models/ration_result.dart';
import '../models/saved_assessment.dart';
import '../calculators/ration_calculator.dart';
import '../data/assessment_store.dart';
import '../providers/language_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/nutrient_bar.dart';
import '../widgets/tmr_item.dart';
import '../widgets/cost_summary_card.dart';

class ResultsScreen extends StatefulWidget {
  final String cattleName;
  final CattleProfile profile;
  final List<Ingredient> ingredients;

  const ResultsScreen({
    super.key,
    required this.cattleName,
    required this.profile,
    required this.ingredients,
  });

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  bool _saved = false;
  late List<Ingredient> _ingredients;

  @override
  void initState() {
    super.initState();
    _ingredients = widget.ingredients.map((i) => i.copyWith()).toList();
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context);
    final calc = RationCalculator();
    final result = calc.calculate(widget.profile, _ingredients);
    final isDairy = widget.profile.mode == CattleMode.dairy;

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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _saved
                ? Chip(
                    avatar: const Icon(Icons.check, size: 16, color: AppTheme.met),
                    label: Text(
                      lang.t('সংরক্ষিত', 'Saved'),
                      style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.met),
                    ),
                    backgroundColor: AppTheme.met.withValues(alpha: 0.1),
                    side: BorderSide.none,
                  )
                : FilledButton.tonalIcon(
                    onPressed: () => _saveAssessment(result, lang),
                    icon: const Icon(Icons.save_rounded, size: 18),
                    label: Text(
                      lang.t('সংরক্ষণ', 'Save'),
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                  ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _stepBadge(
            lang.t('ধাপ ৩/৩', 'Step 3 of 3'),
            lang.t('আপনার ফলাফল', 'Your results'),
          ),
          const SizedBox(height: 20),

          CostSummaryCard(
            totalCost: result.totalCostPerDay,
            costPerKgMilk: result.feedCostPerKgMilk,
            isDairy: isDairy,
            gradient: AppTheme.primaryGradient,
            totalCostLabel: lang.t('মোট খরচ / দিন', 'Total Cost / Day'),
            costPerKgLabel: lang.t('খরচ / কেজি দুধ', 'Cost / Kg Milk'),
          ),
          const SizedBox(height: 24),

          _sectionLabel(lang.t('পুষ্টি ভারসাম্য', 'NUTRIENT BALANCE')),
          const SizedBox(height: 12),
          NutrientBar(
            label: lang.t('শক্তি (ME)', 'Energy (ME)'),
            required_: result.requiredME,
            supplied: result.suppliedME,
            unit: 'MJ',
            requiredLabel: lang.t('প্রয়োজন', 'Required'),
            suppliedLabel: lang.t('সরবরাহ', 'Supplied'),
          ),
          NutrientBar(
            label: lang.t('প্রোটিন (CP)', 'Protein (CP)'),
            required_: result.requiredCP,
            supplied: result.suppliedCP,
            unit: 'g',
            requiredLabel: lang.t('প্রয়োজন', 'Required'),
            suppliedLabel: lang.t('সরবরাহ', 'Supplied'),
          ),

          const SizedBox(height: 16),

          _sectionLabel(lang.t('শক্তি বিভাজন', 'ENERGY BREAKDOWN')),
          const SizedBox(height: 12),
          _buildEnergyBreakdown(result, isDairy, lang),

          const SizedBox(height: 24),

          _sectionLabel(lang.t('দৈনিক মিশ্রণ রেসিপি', 'DAILY MIXING RECIPE')),
          const SizedBox(height: 12),
          _buildTmrHeader(result, lang),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: Text(
              lang.t('টিপ: মূল্য পরিবর্তন করতে উপাদানে ট্যাপ করুন।', 'Tip: Tap any ingredient to edit its price.'),
              style: GoogleFonts.inter(fontSize: 11, color: Colors.grey[400]),
            ),
          ),
          const SizedBox(height: 4),
          
          ...result.tmrBreakdown.map(
            (item) => GestureDetector(
              onTap: () => _editPrice(item, lang),
              child: TmrItemWidget(
                item: item,
                accentColor: AppTheme.primary,
              ),
            ),
          ),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton.icon(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              icon: const Icon(Icons.home_rounded),
              label: Text(
                lang.t('হোমে ফিরুন', 'Back to Home'),
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _editPrice(TmrItem tmrItem, LanguageProvider lang) {
    final index = _ingredients.indexWhere((i) => i.name == tmrItem.name);
    if (index == -1) return;

    final ingredient = _ingredients[index];
    final controller = TextEditingController(text: ingredient.pricePerKg.toStringAsFixed(0));

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(ingredient.displayName(lang.isBengali), style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              lang.t('প্রতি কেজি মূল্য আপডেট করুন', 'Update price per kg'),
              style: GoogleFonts.inter(fontSize: 13, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              autofocus: true,
              decoration: InputDecoration(
                prefixText: '৳ ',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
              if (val != null) {
                setState(() {
                  _ingredients[index].pricePerKg = val;
                  _saved = false;
                });
              }
              Navigator.pop(ctx);
            },
            child: Text(lang.t('আপডেট', 'Update')),
          ),
        ],
      ),
    );
  }

  Future<void> _saveAssessment(RationResult result, LanguageProvider lang) async {
    final assessment = SavedAssessment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      cattleName: widget.cattleName,
      mode: widget.profile.mode == CattleMode.dairy ? 'dairy' : 'beef',
      createdAt: DateTime.now(),
      totalCostPerDay: result.totalCostPerDay,
      costPerKgMilk: result.feedCostPerKgMilk,
      requiredME: result.requiredME,
      suppliedME: result.suppliedME,
      requiredCP: result.requiredCP,
      suppliedCP: result.suppliedCP,
      totalDMIntake: result.totalDMIntake,
      bodyWeight: widget.profile.bodyWeight,
      milkProduction: widget.profile.milkProduction,
      meMaintenance: result.meMaintenance,
      meLactation: result.meLactation,
      meGrowth: result.meGrowth,
      mePregnancy: result.mePregnancy,
      ingredients: result.tmrBreakdown.map((t) => 
        SavedIngredient(name: t.name, kgAsFed: t.kgAsFed, cost: t.cost)
      ).toList(),
    );

    await AssessmentStore.save(assessment);

    if (mounted) {
      setState(() => _saved = true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            lang.t('✅ সংরক্ষিত!', '✅ Saved!'),
            style: GoogleFonts.inter(fontWeight: FontWeight.w500),
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: AppTheme.met,
        ),
      );
    }
  }

  Widget _stepBadge(String step, String desc) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.met.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.met.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.met,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              step,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            desc,
            style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Colors.grey[500],
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildTmrHeader(RationResult result, LanguageProvider lang) {
    final totalAsFed = result.tmrBreakdown.fold(0.0, (sum, i) => sum + i.kgAsFed);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            lang.t('দৈনিক মোট খাদ্য:', 'Total feed to mix daily:'),
            style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textSecondary),
          ),
          Text(
            '${totalAsFed.toStringAsFixed(1)} ${lang.t('কেজি', 'kg')}',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppTheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnergyBreakdown(RationResult result, bool isDairy, LanguageProvider lang) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0F0F0)),
      ),
      child: Column(
        children: [
          _breakdownRow(lang.t('রক্ষণাবেক্ষণ', 'Maintenance'), result.meMaintenance, AppTheme.primary),
          if (isDairy)
            _breakdownRow(lang.t('দুগ্ধদান', 'Lactation'), result.meLactation, AppTheme.secondary),
          _breakdownRow(lang.t('বৃদ্ধি', 'Growth'), result.meGrowth, AppTheme.concentrateColor),
          _breakdownRow(
            isDairy ? lang.t('গর্ভাবস্থা', 'Pregnancy') : lang.t('বীর্য', 'Semen'),
            result.mePregnancy,
            AppTheme.additiveColor,
          ),
          const Divider(height: 16),
          _breakdownRow(lang.t('মোট প্রয়োজন', 'Total Required'), result.requiredME, AppTheme.primaryDark,
              bold: true),
          _breakdownRow(lang.t('মোট সরবরাহ', 'Total Supplied'), result.suppliedME,
              result.meIsMet ? AppTheme.met : AppTheme.deficit,
              bold: true),
        ],
      ),
    );
  }

  Widget _breakdownRow(String label, double value, Color color,
      {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
          Text(
            '${value.toStringAsFixed(1)} MJ',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
