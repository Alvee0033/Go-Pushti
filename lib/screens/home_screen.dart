import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import '../models/cattle_profile.dart';
import '../models/saved_assessment.dart';
import '../data/assessment_store.dart';
import '../providers/language_provider.dart';
import '../theme/app_theme.dart';
import 'profile_screen.dart';
import 'saved_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<SavedAssessment> _saved = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadSaved();
  }

  Future<void> _loadSaved() async {
    final list = await AssessmentStore.loadAll();
    if (mounted) {
      setState(() {
        _saved = list;
        _loading = false;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadSaved();
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context);
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF00897B).withValues(alpha: 0.05),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: _loadSaved,
            child: CustomScrollView(
              slivers: [
                // Header
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFF00897B), Color(0xFF26A69A)],
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF00897B).withValues(alpha: 0.3),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.grass_rounded,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      lang.t('গো-পুষ্টি', 'Go-Pushti'),
                                      style: lang.isBengali
                                          ? GoogleFonts.notoSansBengali(
                                              fontSize: 28,
                                              fontWeight: FontWeight.w700,
                                              color: const Color(0xFF1A1A1A),
                                            )
                                          : GoogleFonts.poppins(
                                              fontSize: 28,
                                              fontWeight: FontWeight.w700,
                                              color: const Color(0xFF1A1A1A),
                                            ),
                                    ),
                                    Text(
                                      lang.t('গবাদিপশু পুষ্টি বিশেষজ্ঞ', 'Cattle Nutrition Expert'),
                                      style: lang.isBengali
                                          ? GoogleFonts.notoSansBengali(
                                              fontSize: 12,
                                              color: Colors.grey[600],
                                              fontWeight: FontWeight.w500,
                                            )
                                          : GoogleFonts.inter(
                                              fontSize: 12,
                                              color: Colors.grey[600],
                                              fontWeight: FontWeight.w500,
                                            ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                // Language Toggle
                                GestureDetector(
                                  onTap: () => lang.toggleLanguage(),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF00897B).withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: const Color(0xFF00897B).withValues(alpha: 0.3),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          lang.isBengali ? 'বাং' : 'EN',
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF00897B),
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Icon(
                                          Icons.language_rounded,
                                          size: 16,
                                          color: const Color(0xFF00897B),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  onPressed: () => _showAboutDialog(context, lang),
                                  icon: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.info_outline_rounded, color: Colors.grey[700], size: 20),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Mode Cards
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lang.t('নতুন ফর্মুলেশন শুরু করুন', 'Start New Formulation'),
                          style: lang.isBengali
                              ? GoogleFonts.notoSansBengali(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF1A1A1A),
                                )
                              : GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF1A1A1A),
                                ),
                        ),
                        const SizedBox(height: 16),
                        _ModeCard(
                          title: lang.t('দুগ্ধবতী গরু', 'Dairy Cattle'),
                          subtitle: lang.t('Dairy Cattle', 'Milk Production'),
                          emoji: '🐄',
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF00897B), Color(0xFF26A69A)],
                          ),
                          isBengali: lang.isBengali,
                          onTap: () => _navigateToProfile(CattleMode.dairy),
                        ),
                        const SizedBox(height: 14),
                        _ModeCard(
                          title: lang.t('মাংস উৎপাদন', 'Beef Cattle'),
                          subtitle: lang.t('Beef Cattle', 'Meat Production'),
                          emoji: '🐂',
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF5C6BC0), Color(0xFF7986CB)],
                          ),
                          isBengali: lang.isBengali,
                          onTap: () => _navigateToProfile(CattleMode.beef),
                        ),
                      ],
                    ),
                  ),
                ),

                // Saved History Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
                    child: Row(
                      children: [
                        Text(
                          lang.t('সাম্প্রতিক ইতিহাস', 'Recent History'),
                          style: lang.isBengali
                              ? GoogleFonts.notoSansBengali(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF1A1A1A),
                                )
                              : GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF1A1A1A),
                                ),
                        ),
                        const Spacer(),
                        if (_saved.isNotEmpty)
                          GestureDetector(
                            onTap: () => _confirmClearAll(lang),
                            child: Text(
                              lang.t('সব মুছুন', 'Clear All'),
                              style: lang.isBengali
                                  ? GoogleFonts.notoSansBengali(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.deficit,
                                    )
                                  : GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.deficit,
                                    ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                // Saved items list
                if (_loading)
                  const SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(40),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  )
                else if (_saved.isEmpty)
                  SliverToBoxAdapter(child: _buildEmptyState(lang))
                else
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _buildHistoryCard(_saved[index]),
                      childCount: _saved.length,
                    ),
                  ),

                const SliverToBoxAdapter(child: SizedBox(height: 40)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToProfile(CattleMode mode) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ProfileScreen(mode: mode)),
    );
    _loadSaved();
  }

  Widget _buildEmptyState(LanguageProvider lang) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey[100]!),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.history_rounded, size: 32, color: Colors.grey[300]),
            ),
            const SizedBox(height: 16),
            Text(
              lang.t('কোনো সংরক্ষিত তথ্য নেই', 'No saved formulations'),
              style: lang.isBengali
                  ? GoogleFonts.notoSansBengali(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[400],
                    )
                  : GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[400],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryCard(SavedAssessment a) {
    final isDairy = a.isDairy;
    final color = isDairy 
        ? const Color(0xFF00897B) 
        : const Color(0xFF5C6BC0);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SavedDetailsScreen(
                assessment: a, 
                onDelete: _loadSaved
              ),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.grey[100]!),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDairy 
                      ? [const Color(0xFF00897B), const Color(0xFF26A69A)]
                      : [const Color(0xFF5C6BC0), const Color(0xFF7986CB)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    isDairy ? '🐄' : '🐂',
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      a.cattleName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${a.bodyWeight.toStringAsFixed(0)}kg · ${_formatDate(a.createdAt)}',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '৳${a.totalCostPerDay.toStringAsFixed(0)}',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _statusDot(a.meIsMet),
                      const SizedBox(width: 4),
                      _statusDot(a.cpIsMet),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusDot(bool isMet) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: isMet ? AppTheme.met : AppTheme.deficit,
        shape: BoxShape.circle,
      ),
    );
  }

  String _formatDate(DateTime d) {
    final now = DateTime.now();
    final diff = now.difference(d);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    return '${d.day}/${d.month}';
  }

  void _confirmClearAll(LanguageProvider lang) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          lang.t('সব মুছবেন?', 'Clear All?'),
          style: lang.isBengali
              ? GoogleFonts.notoSansBengali(fontWeight: FontWeight.w700)
              : GoogleFonts.poppins(fontWeight: FontWeight.w700),
        ),
        content: Text(lang.t(
          'এটি স্থায়ীভাবে সমস্ত সংরক্ষিত তথ্য মুছে দেবে।',
          'This will permanently delete all saved assessments.',
        )),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(lang.t('বাতিল', 'Cancel')),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await AssessmentStore.clearAll();
              _loadSaved();
            },
            style: FilledButton.styleFrom(backgroundColor: AppTheme.deficit),
            child: Text(lang.t('মুছুন', 'Delete')),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context, LanguageProvider lang) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF00897B), Color(0xFF26A69A)],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.grass_rounded,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                lang.t('গো-পুষ্টি', 'Go-Pushti'),
                style: lang.isBengali
                    ? GoogleFonts.notoSansBengali(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A1A1A),
                      )
                    : GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A1A1A),
                      ),
              ),
              Text(
                'v1.0.0 · AFRC Standard',
                style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[500]),
              ),
              const SizedBox(height: 24),
              Text(
                lang.t('উন্নয়নকারী', 'Developed by'),
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: Colors.grey[400],
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Morsalin Islam Alvee',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              Text(
                lang.t(
                  'ফুল স্ট্যাক ডেভেলপার ও এআই বিশেষজ্ঞ',
                  'Full Stack Developer & AI Specialist',
                ),
                textAlign: TextAlign.center,
                style: lang.isBengali
                    ? GoogleFonts.notoSansBengali(fontSize: 12, color: Colors.grey[500])
                    : GoogleFonts.inter(fontSize: 12, color: Colors.grey[500]),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _linkChip(
                    icon: Icons.language_rounded,
                    label: lang.t('পোর্টফোলিও', 'Portfolio'),
                    url: 'https://alvee-portfolio.web.app/',
                  ),
                  const SizedBox(width: 10),
                  _linkChip(
                    icon: Icons.code_rounded,
                    label: 'GitHub',
                    url: 'https://github.com/Alvee0033',
                  ),
                ],
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(lang.t('বন্ধ করুন', 'Close')),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _linkChip({required IconData icon, required String label, required String url}) {
    return GestureDetector(
      onTap: () async {
        final uri = Uri.parse(url);
        try {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } catch (_) {
          // Fallback: try without mode
          try {
            await launchUrl(uri);
          } catch (_) {}
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF00897B).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: const Color(0xFF00897B)),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF00897B)),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String emoji;
  final Gradient gradient;
  final bool isBengali;
  final VoidCallback onTap;

  const _ModeCard({
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.gradient,
    required this.isBengali,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: gradient.colors.first.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(emoji, style: const TextStyle(fontSize: 32)),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: isBengali
                        ? GoogleFonts.notoSansBengali(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          )
                        : GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: isBengali
                        ? GoogleFonts.notoSansBengali(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withValues(alpha: 0.9),
                          )
                        : GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
