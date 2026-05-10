import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'providers/prayer_provider.dart';
import 'screens/main_screen.dart';
import 'utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await initializeDateFormatting('fr_FR', null);
  await initializeDateFormatting('fr', null);
  runApp(
    ChangeNotifierProvider(
      create: (_) => PrayerProvider()..loadHistory(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: '🙏 Programme de Priere',
        theme: AppTheme.elegant,
        home: const MainScreen(),
      ),
    ),
  );
}
