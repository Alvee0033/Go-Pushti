import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/saved_assessment.dart';
import '../models/ration_result.dart';
import '../providers/language_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/nutrient_bar.dart';
import '../widgets/tmr_item.dart';
import '../widgets/cost_summary_card.dart';
import '../data/assessment_store.dart';

class SavedDetailsScreen extends StatelessWidget {
  final SavedAssessment assessment;
  final VoidCallback onDelete;

  const SavedDetailsScreen({
    super.key,
    required this.assessment,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context);
    final isDairy = assessment.isDairy;
    
    final tmrItems = assessment.ingredients.map((i) => TmrItem(
      name: i.name,
      kgAsFed: i.kgAsFed,
      kgDM: 0,
      cost: i.cost,
    )).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              assessment.cattleName,
              style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 18),
            ),
            Text(
              lang.t('সংরক্ষিত প্রতিবেদন', 'Saved Report'),
              style: GoogleFonts.inter(
                fontSize: 11,
                color: Colors.grey[500],
                fontWeight: FontWeight.w500
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 1,
        actions: [
          IconButton(
            onPressed: () => _confirmDelete(context, lang),
            icon: const Icon(Icons.delete_outline_rounded, color: AppTheme.deficit),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          CostSummaryCard(
            totalCost: assessment.totalCostPerDay,
            costPerKgMilk: assessment.costPerKgMilk,
            isDairy: isDairy,
            gradient: isDairy 
              ? const LinearGradient(colors: [Color(0xFF00897B), Color(0xFF26A69A)])
              : const LinearGradient(colors: [Color(0xFF5C6BC0), Color(0xFF7986CB)]),
            totalCostLabel: lang.t('মোট খরচ / দিন', 'Total Cost / Day'),
            costPerKgLabel: lang.t('খরচ / কেজি দুধ', 'Cost / Kg Milk'),
          ),
          const SizedBox(height: 24),

          _sectionLabel(lang.t('পুষ্টি ভারসাম্য', 'NUTRIENT BALANCE')),
          const SizedBox(height: 12),
          NutrientBar(
            label: lang.t('শক্তি (ME)', 'Energy (ME)'),
            required_: assessment.requiredME,
            supplied: assessment.suppliedME,
            unit: 'MJ',
            requiredLabel: lang.t('প্রয়োজন', 'Required'),
            suppliedLabel: lang.t('সরবরাহ', 'Supplied'),
          ),
          NutrientBar(
            label: lang.t('প্রোটিন (CP)', 'Protein (CP)'),
            required_: assessment.requiredCP,
            supplied: assessment.suppliedCP,
            unit: 'g',
            requiredLabel: lang.t('প্রয়োজন', 'Required'),
            suppliedLabel: lang.t('সরবরাহ', 'Supplied'),
          ),

          const SizedBox(height: 16),

          _sectionLabel(lang.t('শক্তি বিভাজন', 'ENERGY BREAKDOWN')),
          const SizedBox(height: 12),
          _buildEnergyBreakdown(isDairy, lang),

          const SizedBox(height: 24),

          _sectionLabel(lang.t('দৈনিক মিশ্রণ রেসিপি', 'DAILY MIXING RECIPE')),
          const SizedBox(height: 12),
          _buildTmrHeader(tmrItems, lang),
          const SizedBox(height: 8),
          if (tmrItems.isEmpty)
             Padding(
               padding: const EdgeInsets.all(12),
               child: Text(
                 lang.t(
                   'এই রেকর্ডের জন্য কোনো রেসিপি বিবরণ নেই।',
                   'No recipe details available for this record.',
                 ),
                 style: GoogleFonts.inter(fontSize: 13, color: Colors.grey[400]),
               ),
             )
          else
            ...tmrItems.map(
              (item) => TmrItemWidget(
                item: item,
                accentColor: isDairy ? AppTheme.secondary : AppTheme.concentrateColor,
              ),
            ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, LanguageProvider lang) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          lang.t('রেকর্ড মুছবেন?', 'Delete Record?'),
          style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
        ),
        content: Text(lang.t(
          'এই কাজটি পূর্বাবস্থায় ফেরানো যাবে না।',
          'This action cannot be undone.',
        )),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(lang.t('বাতিল', 'Cancel')),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await AssessmentStore.delete(assessment.id);
              if (context.mounted) {
                onDelete(); 
                Navigator.of(context).pop();
              }
            },
            style: FilledButton.styleFrom(backgroundColor: AppTheme.deficit),
            child: Text(lang.t('মুছুন', 'Delete')),
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

  Widget _buildTmrHeader(List<TmrItem> items, LanguageProvider lang) {
    final totalAsFed = items.fold(0.0, (sum, i) => sum + i.kgAsFed);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            lang.t('দৈনিক মোট খাদ্য:', 'Total feed to mix daily:'),
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppTheme.textSecondary,
            ),
          ),
          Text(
            '${totalAsFed.toStringAsFixed(1)} ${lang.t('কেজি', 'kg')}',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnergyBreakdown(bool isDairy, LanguageProvider lang) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0F0F0)),
      ),
      child: Column(
        children: [
          _breakdownRow(lang.t('রক্ষণাবেক্ষণ', 'Maintenance'), assessment.meMaintenance, AppTheme.primary),
          if (isDairy)
            _breakdownRow(lang.t('দুগ্ধদান', 'Lactation'), assessment.meLactation, AppTheme.secondary),
          _breakdownRow(lang.t('বৃদ্ধি', 'Growth'), assessment.meGrowth, AppTheme.concentrateColor),
          _breakdownRow(
            isDairy ? lang.t('গর্ভাবস্থা', 'Pregnancy') : lang.t('বীর্য', 'Semen'),
            assessment.mePregnancy,
            AppTheme.additiveColor,
          ),
          const Divider(height: 16),
          _breakdownRow(lang.t('মোট প্রয়োজন', 'Total Required'), assessment.requiredME, AppTheme.primaryDark,
              bold: true),
          _breakdownRow(lang.t('মোট সরবরাহ', 'Total Supplied'), assessment.suppliedME,
              assessment.meIsMet ? AppTheme.met : AppTheme.deficit,
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
