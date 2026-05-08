import 'dart:io';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import '../models/prayer_program.dart';

class PDFService {
  static Future<Uint8List> generate(PrayerProgram p) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          pw.Center(
            child: pw.Column(
              children: [
                pw.Text('🙏 PROGRAMME DE PRIERE', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 8),
                pw.Text(p.theme.toUpperCase(), style: pw.TextStyle(fontSize: 20, color: PdfColor.fromHex('#c9a227'))),
                pw.Divider(thickness: 2),
                pw.SizedBox(height: 20),
                pw.Text(p.content, style: const pw.TextStyle(fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
    return pdf.save();
  }

  static Future<void> share(PrayerProgram p) async {
    final bytes = await generate(p);
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/priere_${p.theme}.pdf');
    await file.writeAsBytes(bytes);
    await Share.shareXFiles([XFile(file.path)], text: '🙏 ${p.theme}');
  }
}
