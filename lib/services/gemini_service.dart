import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../model/chart_model.dart';

class GeminiService {
  final GenerativeModel _model;

  GeminiService()
      : _model = GenerativeModel(
          model: 'gemini-1.5-flash',
          apiKey: dotenv.env['GEMINI_API_KEY'] ?? '',
        );

  Future<String> insightForChart(String symbol, List<ChartDataModel> data) async {
    final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
    if (apiKey.isEmpty) {
      return 'AI yorumu için API anahtarı (API key) bulunamadı. Lütfen .env içine GEMINI_API_KEY ekleyin.';
    }

    final points = data
        .map((e) => {
              'date':
                  '${e.time.year}-${e.time.month.toString().padLeft(2, '0')}-${e.time.day.toString().padLeft(2, '0')}',
              'close': e.close
            })
        .toList();

    final prompt = '''
Aşağıda ${symbol.toUpperCase()} için son kapanış verileri var.
Görev: Türkçe kısa bir piyasa özeti (market summary) yaz.
- En fazla 3 kısa cümle yaz.
- Yükseliş/düşüş/sıkışma temposunu ve kabaca destek/direnç seviyelerini belirt.
- Kesin yatırım tavsiyesi (financial advice) verme, uyarı ekle.
Veri (date, close): $points
''';

    try {
      final response = await _model.generateContent([Content.text(prompt)]);
      final text = response.text?.trim();
      if (text == null || text.isEmpty) {
        return 'AI yorumu üretilemedi.';
      }
      return text;
    } catch (e) {
      return 'AI hata: $e';
    }
  }
}
