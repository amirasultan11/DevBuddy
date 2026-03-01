import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/locale_provider.dart';
import '../../data/datasources/dummy_data_source.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/models/resource_model.dart';

/// Resources Hub - Learning Resources with Tabbed Interface
/// Displays Problem Solving platforms, Books, Tools, and Competitions
class ResourcesScreen extends StatelessWidget {
  const ResourcesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final isArabic = localeProvider.locale.languageCode == 'ar';
    final allResources = DummyDataSource.getResources();
    final scholarships = DummyDataSource.getScholarships();

    return DefaultTabController(
      length: 5,
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 1.2,
              colors: [
                Color(0xFF1E293B), // Lighter Navy Center
                Color(0xFF020617), // Darkest Navy Edges
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          isArabic ? Icons.arrow_forward : Icons.arrow_back,
                          color: Colors.white,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isArabic ? 'مركز الموارد' : 'Resources Hub',
                        style: GoogleFonts.cairo(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                // Tab Bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withValues(alpha: 0.1),
                            Colors.white.withValues(alpha: 0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                          width: 1.5,
                        ),
                      ),
                      child: TabBar(
                        indicator: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.indigoAccent.withValues(alpha: 0.4),
                              Colors.purpleAccent.withValues(alpha: 0.3),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        indicatorPadding: const EdgeInsets.all(4),
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.white60,
                        labelStyle: GoogleFonts.cairo(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                        tabs: [
                          Tab(
                            icon: const Icon(Icons.code, size: 20),
                            text: isArabic ? 'حل المشاكل' : 'Coding',
                          ),
                          Tab(
                            icon: const Icon(Icons.book, size: 20),
                            text: isArabic ? 'كتب' : 'Books',
                          ),
                          Tab(
                            icon: const Icon(Icons.build, size: 20),
                            text: isArabic ? 'أدوات' : 'Tools',
                          ),
                          Tab(
                            icon: const Icon(Icons.emoji_events, size: 20),
                            text: isArabic ? 'مسابقات' : 'Contests',
                          ),
                          Tab(
                            icon: const Icon(Icons.school, size: 20),
                            text: isArabic ? 'منح' : 'Scholarships',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Tab Views
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildResourceList(
                        allResources
                            .where((r) => r.category == 'problem_solving')
                            .toList(),
                        isArabic,
                      ),
                      _buildResourceList(
                        allResources
                            .where((r) => r.category == 'books')
                            .toList(),
                        isArabic,
                      ),
                      _buildResourceList(
                        allResources
                            .where((r) => r.category == 'tools')
                            .toList(),
                        isArabic,
                      ),
                      _buildResourceList(
                        allResources
                            .where((r) => r.category == 'competitions')
                            .toList(),
                        isArabic,
                      ),
                      _buildResourceList(scholarships, isArabic),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResourceList(List<ResourceModel> resources, bool isArabic) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      physics: const BouncingScrollPhysics(),
      itemCount: resources.length,
      itemBuilder: (context, index) {
        return _buildResourceCard(context, resources[index], isArabic);
      },
    );
  }

  Widget _buildResourceCard(
    BuildContext context,
    ResourceModel resource,
    bool isArabic,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.1),
                  Colors.white.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Icon based on category
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            _getCategoryColor(
                              resource.category,
                            ).withValues(alpha: 0.4),
                            _getCategoryColor(
                              resource.category,
                            ).withValues(alpha: 0.2),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: _getCategoryColor(
                              resource.category,
                            ).withValues(alpha: 0.3),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Icon(
                        _getCategoryIcon(resource.category),
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  resource.title,
                                  style: GoogleFonts.cairo(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              // Free/Premium Badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: resource.isFree
                                      ? Colors.greenAccent.withValues(
                                          alpha: 0.3,
                                        )
                                      : Colors.orangeAccent.withValues(
                                          alpha: 0.3,
                                        ),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: resource.isFree
                                        ? Colors.greenAccent.withValues(
                                            alpha: 0.6,
                                          )
                                        : Colors.orangeAccent.withValues(
                                            alpha: 0.6,
                                          ),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  resource.isFree
                                      ? (isArabic ? 'مجاني' : 'Free')
                                      : (isArabic ? 'مدفوع' : 'Premium'),
                                  style: GoogleFonts.cairo(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: resource.isFree
                                        ? Colors.greenAccent
                                        : Colors.orangeAccent,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (resource.author != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              '${isArabic ? 'المؤلف' : 'by'} ${resource.author}',
                              style: GoogleFonts.cairo(
                                fontSize: 12,
                                color: Colors.white60,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  resource.description,
                  style: GoogleFonts.cairo(
                    fontSize: 13,
                    color: Colors.white70,
                    height: 1.5,
                  ),
                ),
                if (resource.url != null) ...[
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _launchURL(context, resource.url!),
                      icon: const Icon(Icons.open_in_new, size: 18),
                      label: Text(
                        isArabic ? 'زيارة' : 'Visit',
                        style: GoogleFonts.cairo(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigoAccent.withValues(
                          alpha: 0.3,
                        ),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: Colors.indigoAccent.withValues(alpha: 0.5),
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchURL(BuildContext context, String urlString) async {
    try {
      final Uri url = Uri.parse(urlString);
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $url');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch link: $urlString')),
        );
      }
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'problem_solving':
        return Icons.code;
      case 'books':
        return Icons.book;
      case 'tools':
        return Icons.build;
      case 'competitions':
        return Icons.emoji_events;
      case 'scholarships':
        return Icons.school;
      default:
        return Icons.star;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'problem_solving':
        return Colors.blueAccent;
      case 'books':
        return Colors.purpleAccent;
      case 'tools':
        return Colors.cyanAccent;
      case 'competitions':
        return Colors.amberAccent;
      case 'scholarships':
        return Colors.greenAccent;
      default:
        return Colors.indigoAccent;
    }
  }
}
