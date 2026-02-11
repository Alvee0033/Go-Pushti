import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/cattle_profile.dart';
import '../data/default_ingredients.dart';
import '../providers/language_provider.dart';
import '../theme/app_theme.dart';
import 'ingredients_screen.dart';

class ProfileScreen extends StatefulWidget {
  final CattleMode mode;

  const ProfileScreen({super.key, required this.mode});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late CattleProfile _profile;

  late final TextEditingController _nameCtrl;
  late final TextEditingController _bwCtrl;
  late final TextEditingController _dwgCtrl;
  late final TextEditingController _milkCtrl;
  late final TextEditingController _fatCtrl;
  late final TextEditingController _proteinCtrl;
  late final TextEditingController _semenCtrl;

  @override
  void initState() {
    super.initState();
    _profile = CattleProfile(mode: widget.mode);
    _nameCtrl = TextEditingController();
    _bwCtrl = TextEditingController(text: '350');
    _dwgCtrl = TextEditingController(text: '0.5');
    _milkCtrl = TextEditingController(text: '10');
    _fatCtrl = TextEditingController(text: '4.0');
    _proteinCtrl = TextEditingController(text: '3.3');
    _semenCtrl = TextEditingController(text: '0');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _bwCtrl.dispose();
    _dwgCtrl.dispose();
    _milkCtrl.dispose();
    _fatCtrl.dispose();
    _proteinCtrl.dispose();
    _semenCtrl.dispose();
    super.dispose();
  }

  void _update(CattleProfile Function(CattleProfile) fn) {
    setState(() => _profile = fn(_profile));
  }

  @override
  Widget build(BuildContext context) {
    final isDairy = widget.mode == CattleMode.dairy;
    final lang = Provider.of<LanguageProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      appBar: AppBar(
        title: Text(
          isDairy
              ? lang.t('🐄 দুগ্ধবতী গরু', '🐄 Dairy Cow')
              : lang.t('🐂 মাংস উৎপাদন', '🐂 Beef Cattle'),
          style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _stepBadge(
            lang.t('ধাপ ১/৩', 'Step 1 of 3'),
            lang.t('পশুর তথ্য দিন', 'Enter animal details'),
          ),
          const SizedBox(height: 20),

          _sectionLabel(lang.t('পশুর নাম', 'ANIMAL NAME')),
          const SizedBox(height: 10),
          _card([
            TextField(
              controller: _nameCtrl,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: isDairy
                    ? lang.t('যেমন: লক্ষ্মী, গাভী #১২', 'e.g. Laxmi, Cow #12')
                    : lang.t('যেমন: ষাঁড় #৫', 'e.g. Bull #5'),
                hintStyle: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[300],
                ),
                prefixIcon: Icon(
                  Icons.pets_rounded,
                  color: AppTheme.primary,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Colors.grey[200]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Colors.grey[200]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppTheme.primary, width: 1.5),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
            ),
          ]),

          const SizedBox(height: 24),

          _sectionLabel(lang.t('শারীরিক তথ্য', 'BODY DETAILS')),
          const SizedBox(height: 10),
          _card([
            _inputRow(lang.t('শরীরের ওজন', 'Body Weight'), lang.t('কেজি', 'kg'), _bwCtrl, (v) {
              _update((p) => p.copyWith(bodyWeight: v));
            }),
            const Divider(height: 28, color: Color(0xFFF0F0F0)),
            _inputRow(lang.t('দৈনিক বৃদ্ধি', 'Daily Growth'), lang.t('কেজি', 'kg'), _dwgCtrl, (v) {
              _update((p) => p.copyWith(dailyWeightGain: v));
            }),
          ]),
          const SizedBox(height: 24),

          if (isDairy) ...[
            _sectionLabel(lang.t('দুধ উৎপাদন', 'MILK PRODUCTION')),
            const SizedBox(height: 10),
            _card([
              _inputRow(lang.t('দুধ/দিন', 'Milk / day'), lang.t('লিটার', 'Liters'), _milkCtrl, (v) {
                _update((p) => p.copyWith(milkProduction: v));
              }),
              const Divider(height: 28, color: Color(0xFFF0F0F0)),
              _inputRow(lang.t('চর্বি %', 'Fat %'), '%', _fatCtrl, (v) {
                _update((p) => p.copyWith(milkFat: v));
              }),
              const Divider(height: 28, color: Color(0xFFF0F0F0)),
              _inputRow(lang.t('প্রোটিন %', 'Protein %'), '%', _proteinCtrl, (v) {
                _update((p) => p.copyWith(milkProtein: v));
              }),
            ]),
            const SizedBox(height: 24),
            _sectionLabel(lang.t('গর্ভাবস্থা', 'PREGNANCY')),
            const SizedBox(height: 10),
            _card([_pregnancySelector(lang)]),
          ] else ...[
            _sectionLabel(lang.t('প্রজনন', 'REPRODUCTION')),
            const SizedBox(height: 10),
            _card([
              _inputRow(lang.t('বীর্য সংগ্রহ', 'Semen Collection'), lang.t('/সপ্তাহ', '/ week'), _semenCtrl, (v) {
                _update((p) => p.copyWith(semenCollectionsPerWeek: v.toInt()));
              }),
            ]),
          ],

          const SizedBox(height: 100),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final name = _nameCtrl.text.trim();
          if (name.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  lang.t('অনুগ্রহ করে পশুর নাম লিখুন', 'Please enter an animal name'),
                  style: GoogleFonts.inter(fontWeight: FontWeight.w500),
                ),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
            return;
          }
          final ingredients = getDefaultIngredients();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => IngredientsScreen(
                cattleName: name,
                profile: _profile,
                ingredients: ingredients,
              ),
            ),
          );
        },
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.arrow_forward_rounded),
        label: Text(
          lang.t('উপাদান নির্বাচন', 'Select Ingredients'),
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _stepBadge(String step, String desc) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.primary.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.primary,
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

  Widget _card(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF0F0F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _inputRow(
    String label,
    String unit,
    TextEditingController ctrl,
    ValueChanged<double> onChanged,
  ) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppTheme.textPrimary,
            ),
          ),
        ),
        SizedBox(
          width: 120,
          child: TextField(
            controller: ctrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textAlign: TextAlign.end,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
            ],
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
            decoration: InputDecoration(
              suffixText: ' $unit',
              suffixStyle: GoogleFonts.inter(
                fontSize: 12,
                color: Colors.grey[400],
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[200]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[200]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.primary, width: 1.5),
              ),
              filled: true,
              fillColor: Colors.grey[50],
            ),
            onChanged: (val) {
              final d = double.tryParse(val);
              if (d != null) onChanged(d);
            },
          ),
        ),
      ],
    );
  }

  Widget _pregnancySelector(LanguageProvider lang) {
    return Row(
      children: [
        Expanded(
          child: Text(
            lang.t('গর্ভাবস্থার ধাপ', 'Pregnancy Stage'),
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppTheme.textPrimary,
            ),
          ),
        ),
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<PregnancyTrimester>(
              value: _profile.pregnancyTrimester,
              icon: const Icon(Icons.arrow_drop_down_rounded),
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
              items: [
                DropdownMenuItem(
                  value: PregnancyTrimester.none,
                  child: Text(lang.t('নেই', 'None')),
                ),
                DropdownMenuItem(
                  value: PregnancyTrimester.first,
                  child: Text(lang.t('১ম ত্রৈমাসিক', '1st Trimester')),
                ),
                DropdownMenuItem(
                  value: PregnancyTrimester.second,
                  child: Text(lang.t('২য় ত্রৈমাসিক', '2nd Trimester')),
                ),
                DropdownMenuItem(
                  value: PregnancyTrimester.third,
                  child: Text(lang.t('৩য় ত্রৈমাসিক', '3rd Trimester')),
                ),
              ],
              onChanged: (val) {
                if (val != null) {
                  _update((p) => p.copyWith(pregnancyTrimester: val));
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
