import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'bible_verses_service.dart';

class AIService {
  static String get _apiKey => dotenv.env['GEMINI_API_KEY'] ?? '';

  static Future<String> generate(String theme) async {
    try {
      String dateStr;
      try {
        dateStr = DateFormat('EEEE dd MMMM yyyy', 'fr').format(DateTime.now());
      } catch (e) {
        dateStr = DateFormat('dd/MM/yyyy').format(DateTime.now());
      }
      
      // Générer une liste de 7 versets bibliques aléatoires pour les 7 prières
      final List<String> versets = List.generate(7, (_) => BibleVersesService.getRandomVerseAny());
      
      final url = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-flash-latest:generateContent';
      
      final body = {
        'contents': [
          {
            'parts': [
              {'text': _buildPrompt(theme, dateStr, versets)}
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

  static String _buildPrompt(String theme, String dateStr, List<String> versets) {
    final versetsText = versets.asMap().entries.map((e) => '${e.key + 1}. ${e.value}').join('\n');
    
    return '''Tu es un assistant spirituel. Génère un programme de prière pour aujourd'hui ($dateStr) sur le thème : "$theme".

Tu DOIS générer DEUX versions complètes l'une après l'autre : 
1. VERSION FRANÇAISE
2. ENGLISH VERSION

SÉPARATION : Utilise le texte "--- ENGLISH VERSION ---" pour séparer les deux langues.

RÈGLES DE FORMATAGE (TRÈS STRICTES) :
- INTERDICTION d'utiliser des emojis.
- INTERDICTION d'utiliser des astérisques (*) ou des traits.
- Laisse TROIS lignes vides entre chaque section.
- Pour les prières : Affiche d'abord l'horaire, puis reviens à la ligne pour afficher "Prière X".

VERSETS BIBLIQUES À UTILISER (un pour chaque prière) :
$versetsText

STRUCTURE À SUIVRE POUR CHAQUE LANGUE (TRÈS IMPORTANTE - RESPECTER EXACTEMENT) :

$dateStr


Prière d'ouverture 6:00-6:03


Adoration et louange 6:03-6:10


6:10-6:15

Prière 1: [Texte commençant par "Père, au nom de Jésus..."]
${versets[0]}


6:15-6:20

Prière 2: [Texte commençant par "Père, au nom de Jésus..."]
${versets[1]}


6:20-6:25

Prière 3: [Texte commençant par "Père, au nom de Jésus..."]
${versets[2]}


6:25-6:30

Prière 4: [Texte commençant par "Père, au nom de Jésus..."]
${versets[3]}


Louange intense 6:30-6:33


6:33-6:38

Prière 5: [Texte]
${versets[4]}


6:38-6:43

Prière 6: [Texte]
${versets[5]}


6:43-6:48

Prière 7: [Texte]
${versets[6]}


Supplication Personnelle 6:48-6:53


Louange intense 6:53-6:58


Clôture et Bénédiction finale 6:58-7:00

IMPORTANT : Seules les prières (1 à 7) ont du texte. Les autres sections n'ont QUE le titre et l'heure.
Utilise EXACTEMENT les versets bibliques fournis ci-dessus, ne les modifie pas et ne les invente pas.Aussi apres avoir mit les horaires fait un retour à la ligne avant de commencer le texte de la prière et pareil pour les versets.
''';
  }
}
