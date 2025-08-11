import 'package:flutter/material.dart';
import '../model/chart_model.dart';
import '../services/gemini_service.dart';

class AiInsightCard extends StatelessWidget {
  final String symbol;
  final List<ChartDataModel> data;

  const AiInsightCard({
    super.key,
    required this.symbol,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: GeminiService().insightForChart(symbol, data),
      builder: (context, snapshot) {
        final bg = const Color(0xFF3A3D44);

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'AI yorum hazırlanıyor...',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ],
            ),
          );
        }

        final err = snapshot.error;
        final text = snapshot.data ?? (err?.toString() ?? 'Yorum bulunamadı.');

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'AI Yorum (Gemini)',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                text,
                style: const TextStyle(color: Colors.white70, height: 1.4),
              ),
              const SizedBox(height: 6),
              const Text(
                'Uyarı: Bu bir yatırım tavsiyesi (financial advice) değildir.',
                style: TextStyle(color: Colors.redAccent, fontSize: 12),
              ),
            ],
          ),
        );
      },
    );
  }
}
