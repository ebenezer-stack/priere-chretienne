import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/prayer_program.dart';
import '../services/ai_service.dart';
import '../services/database_helper.dart';
import '../services/pdf_service.dart';

class PrayerProvider extends ChangeNotifier {
  bool _loading = false;
  String _error = '';
  String _theme = '';
  String _content = '';
  PrayerProgram? _current;
  List<PrayerProgram> _history = [];

  bool get loading => _loading;
  String get error => _error;
  String get theme => _theme;
  String get content => _content;
  PrayerProgram? get current => _current;
  List<PrayerProgram> get history => _history;

  Future<void> generate(String theme, {bool useApi = true}) async {
    if (theme.trim().isEmpty) {
      _error = 'Saisissez un theme';
      notifyListeners();
      return;
    }
    _loading = true;
    _error = '';
    _theme = theme.trim();
    notifyListeners();

    try {
      _content = await AIService.generate(_theme);
      _current = await DatabaseHelper.instance.create(PrayerProgram(
        theme: _theme,
        content: _content,
        createdAt: DateTime.now().toIso8601String(),
      ));
      await loadHistory();
    } catch (e) {
      _error = e.toString();
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> loadHistory() async {
    _history = await DatabaseHelper.instance.readAll();
    notifyListeners();
  }

  Future<void> delete(int id) async {
    await DatabaseHelper.instance.delete(id);
    await loadHistory();
  }

  void select(PrayerProgram p) {
    _current = p;
    _theme = p.theme;
    _content = p.content;
    notifyListeners();
  }

  Future<void> copy() async {
    await Clipboard.setData(ClipboardData(text: _content));
    Fluttertoast.showToast(msg: 'Copie!');
  }

  Future<void> sharePdf() async {
    if (_current != null) await PDFService.share(_current!);
  }

  Future<void> updateContent(String newContent) async {
    if (_current != null) {
      _content = newContent;
      _current = _current!.copyWith(content: newContent);
      await DatabaseHelper.instance.update(_current!);
      await loadHistory();
      notifyListeners();
    }
  }
}
