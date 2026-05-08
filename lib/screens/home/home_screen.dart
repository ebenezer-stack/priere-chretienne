import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../providers/prayer_provider.dart';
import '../../utils/theme.dart';
import '../../utils/helpers.dart';
import '../result/result_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _ctrl = TextEditingController();
  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<PrayerProvider>();

    return Scaffold(
      body: Container(
        decoration: AppTheme.luxuryGradient,
        child: Stack(
          children: [
            SafeArea(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.church_rounded, color: AppTheme.gold, size: 40)
                              .animate()
                              .fade(duration: 600.ms)
                              .scale(),
                          const SizedBox(height: 16),
                          Text('Guide Spirituel', style: Theme.of(context).textTheme.displayLarge)
                              .animate()
                              .fadeIn(delay: 200.ms, duration: 800.ms),
                          const SizedBox(height: 12),
                          Text(
                            'Créez votre programme de prière quotidien avec l\'aide de Gemini AI.',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ).animate().fadeIn(delay: 400.ms),
                        ],
                      ),
                    ),
                  ),
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(32),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Form(
                              key: _form,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text('Thème de prière', style: Theme.of(context).textTheme.titleLarge),
                                  const SizedBox(height: 20),
                                  TextFormField(
                                    controller: _ctrl,
                                    style: const TextStyle(color: AppTheme.midnight),
                                    decoration: InputDecoration(
                                      hintText: 'Ex: Protection, Paix, Guérison...',
                                      prefixIcon: const Icon(Icons.auto_awesome, color: AppTheme.gold),
                                      filled: true,
                                      fillColor: AppTheme.softGrey,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                    validator: (v) => v?.trim().isEmpty == true ? 'Veuillez saisir un thème' : null,
                                  ),
                                  const SizedBox(height: 32),
                                  ElevatedButton(
                                    onPressed: prov.loading ? null : _generate,
                                    child: prov.loading
                                        ? const SizedBox(
                                            width: 24,
                                            height: 24,
                                            child: CircularProgressIndicator(color: AppTheme.ivory, strokeWidth: 2),
                                          )
                                        : const Text('GÉNÉRER LE PROGRAMME'),
                                  ),
                                ],
                              ),
                            ),
                          ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.1),
                          const SizedBox(height: 40),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Suggestions', style: Theme.of(context).textTheme.titleLarge),
                          ),
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: suggestedThemes
                                .map((t) => InkWell(
                                      onTap: () => setState(() => _ctrl.text = t),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: _ctrl.text == t ? AppTheme.gold : Colors.white,
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(
                                            color: _ctrl.text == t ? AppTheme.gold : AppTheme.gold.withOpacity(0.2),
                                          ),
                                        ),
                                        child: Text(
                                          t,
                                          style: TextStyle(
                                            color: _ctrl.text == t ? Colors.white : AppTheme.midnight,
                                            fontWeight: _ctrl.text == t ? FontWeight.bold : FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _generate() async {
    if (!_form.currentState!.validate()) return;
    final prov = context.read<PrayerProvider>();
    
    try {
      await prov.generate(_ctrl.text.trim());
      if (prov.error.isNotEmpty && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(prov.error), backgroundColor: Colors.red),
        );
      } else if (prov.content.isNotEmpty && mounted) {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const ResultScreen()));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }
}
