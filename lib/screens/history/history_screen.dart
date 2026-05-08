import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/prayer_provider.dart';
import '../../utils/theme.dart';
import '../result/result_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => context.read<PrayerProvider>().loadHistory());
  }

  @override
  Widget build(BuildContext context) {
    final programs = context.watch<PrayerProvider>().history;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: const Text('HISTORIQUE')),
      body: Container(
        decoration: AppTheme.luxuryGradient,
        child: SafeArea(
          child: programs.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.history_toggle_off_rounded, 
                        size: 80, 
                        color: AppTheme.gold.withOpacity(0.2)
                      ).animate().scale(duration: 600.ms),
                      const SizedBox(height: 20),
                      Text(
                        'Aucun programme sauvegardé',
                        style: GoogleFonts.outfit(
                          color: AppTheme.midnight.withOpacity(0.4),
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Vos guides spirituels apparaîtront ici.',
                        style: GoogleFonts.outfit(
                          color: AppTheme.midnight.withOpacity(0.3),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  itemCount: programs.length,
                  itemBuilder: (_, i) {
                    final program = programs[i];
                    final date = DateTime.parse(program.createdAt);
                    
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Dismissible(
                        key: ValueKey(program.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(Icons.delete_outline, color: Colors.red),
                        ),
                        confirmDismiss: (direction) async {
                          return await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Confirmer la suppression'),
                              content: const Text('Voulez-vous vraiment supprimer ce programme ?'),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('ANNULER')),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('SUPPRIMER', style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          );
                        },
                        onDismissed: (_) => context.read<PrayerProvider>().delete(program.id!),
                        child: InkWell(
                          onTap: () {
                            context.read<PrayerProvider>().select(program);
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const ResultScreen()));
                          },
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: AppTheme.gold.withOpacity(0.1)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.03),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: AppTheme.softGrey,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.book_rounded, color: AppTheme.gold, size: 24),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        program.theme,
                                        style: const TextStyle(
                                          color: AppTheme.midnight,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        DateFormat('dd MMMM yyyy').format(date),
                                        style: TextStyle(
                                          color: AppTheme.midnight.withOpacity(0.4),
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(Icons.chevron_right_rounded, color: AppTheme.gold.withOpacity(0.5)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ).animate().fadeIn(delay: (i * 100).ms).slideX(begin: 0.1);
                  },
                ),
        ),
      ),
    );
  }
}
