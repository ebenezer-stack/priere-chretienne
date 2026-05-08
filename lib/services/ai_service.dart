import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class AIService {
  static const String _apiKey = 'AIzaSyBgJ9eKpeWy2cVKhEGfjbv6rc7-f1t0gNs';

  static Future<String> generate(String theme) async {
    try {
      String dateStr;
      try {
        dateStr = DateFormat('EEEE dd MMMM yyyy', 'fr').format(DateTime.now());
      } catch (e) {
        dateStr = DateFormat('dd/MM/yyyy').format(DateTime.now());
      }
      final url = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-flash-latest:generateContent';
      
      final body = {
        'contents': [
          {
            'parts': [
              {'text': _buildPrompt(theme, dateStr)}
            ]
          }
        ]
      };

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'x-goog-api-key': _apiKey,
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['candidates'][0]['content']['parts'][0]['text'];
      } else {
        throw Exception('Status ${response.statusCode}: ${response.body}');
      }
    } catch (e, stack) {
      debugPrint('AI Error: $e');
      debugPrint('Stack: $stack');
      if (e is SocketException) {
        throw Exception('Pas de connexion internet (SocketException: ${e.message})');
      }
      throw Exception('Erreur: $e');
    }
  }

  static String _buildPrompt(String theme, String dateStr) => '''
Tu es un assistant spirituel. Génère un programme de prière pour aujourd'hui ($dateStr) sur le thème : "$theme".

Tu DOIS générer DEUX versions complètes l'une après l'autre : 
1. VERSION FRANÇAISE
2. ENGLISH VERSION

SÉPARATION : Utilise le texte "--- ENGLISH VERSION ---" pour séparer les deux langues.

RÈGLES DE FORMATAGE (TRÈS STRICTES) :
- INTERDICTION d'utiliser des emojis.
- INTERDICTION d'utiliser des astérisques (*) ou des traits.
- Laisse TROIS lignes vides entre chaque section.
- Pour les prières : Affiche d'abord l'horaire, puis reviens à la ligne pour afficher "Prière X".

STRUCTURE À SUIVRE POUR CHAQUE LANGUE :

$dateStr


Prière d'ouverture 6:00-6:03


Adoration et louange 6:03-6:10


6:10-6:15
Prière 1: [Texte commençant par "Père, au nom de Jésus..."]
[Verset Biblique]


6:15-6:20
Prière 2: [Texte commençant par "Père, au nom de Jésus..."]
[Verset Biblique]


[... continuer ainsi pour les 7 prières ...]


Louange intense 6:30-6:33


6:33-6:38
Prière 5: [Texte]
[Verset]


Supplication Personnelle 6:48-6:53


Louange intense 6:53-6:58


Clôture et Bénédiction finale 6:58-7:00

IMPORTANT : Seules les prières (1 à 7) ont du texte. Les autres sections n'ont QUE le titre et l'heure.
''';
}
