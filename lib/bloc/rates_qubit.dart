import 'dart:async';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class RatesState {
  final String selected; // "USD" | "TRY" | "EUR"
  final Map<String, double> rates; // USD bazlı: {"USD":1, "TRY":xx, "EUR":yy}
  final bool loading;
  final String? error;

  const RatesState({
    required this.selected,
    required this.rates,
    this.loading = false,
    this.error,
  });

  RatesState copyWith({
    String? selected,
    Map<String, double>? rates,
    bool? loading,
    String? error,
  }) {
    return RatesState(
      selected: selected ?? this.selected,
      rates: rates ?? this.rates,
      loading: loading ?? this.loading,
      error: error,
    );
  }
}

class RatesCubit extends Cubit<RatesState> {
  Timer? _timer;

  RatesCubit()
      : super(const RatesState(
          selected: 'USD',
          rates: {'USD': 1.0, 'TRY': 1.0, 'EUR': 1.0},
          loading: false,
        )) {
    fetchRates();
    // Test için kısa periyot; prod'da 60 sn yapabilirsin
    _timer = Timer.periodic(const Duration(seconds: 15), (_) => fetchRates());
  }

  Future<void> fetchRates() async {
    emit(state.copyWith(loading: true, error: null));
    try {
      // 1) Birincil kaynak: open.er-api.com (API key gerektirmez)
      final uri = Uri.parse('https://open.er-api.com/v6/latest/USD');
      final resp = await http.get(uri);
      // ignore: avoid_print
      print('RatesCubit.fetchRates() er-api status=${resp.statusCode}');

      if (resp.statusCode == 200) {
        final body = jsonDecode(resp.body);
        final result = (body is Map) ? body['result'] : null;
        final ratesMap = (body is Map) ? body['rates'] : null;

        if (result == 'success' && ratesMap is Map) {
          final tryRaw = ratesMap['TRY'];
          final eurRaw = ratesMap['EUR'];
          if (tryRaw is num && eurRaw is num) {
            final tryRate = tryRaw.toDouble();
            final eurRate = eurRaw.toDouble();
            // ignore: avoid_print
            print('Rates (er-api) 👉 TRY=$tryRate EUR=$eurRate');

            emit(state.copyWith(
              loading: false,
              error: null,
              rates: {'USD': 1.0, 'TRY': tryRate, 'EUR': eurRate},
            ));
            return;
          }
        }
      }

      // 2) Fallback: exchangerate.host (güvenli parse)
      final fb = Uri.parse(
          'https://api.exchangerate.host/latest?base=USD&symbols=TRY,EUR');
      final resp2 = await http.get(fb);
      // ignore: avoid_print
      print('RatesCubit.fetchRates() fallback status=${resp2.statusCode}');

      if (resp2.statusCode == 200) {
        final body2 = jsonDecode(resp2.body);
        final rates2 = (body2 is Map) ? body2['rates'] : null;

        if (rates2 is Map) {
          final tryRaw = rates2['TRY'];
          final eurRaw = rates2['EUR'];
          if (tryRaw is num && eurRaw is num) {
            final tryRate = tryRaw.toDouble();
            final eurRate = eurRaw.toDouble();
            // ignore: avoid_print
            print('Rates (fallback) 👉 TRY=$tryRate EUR=$eurRate');

            emit(state.copyWith(
              loading: false,
              error: null,
              rates: {'USD': 1.0, 'TRY': tryRate, 'EUR': eurRate},
            ));
            return;
          }
        }
      }

      // 3) İkisi de olmadıysa hata bilgisi
      emit(state.copyWith(
        loading: false,
        error: 'Kur alınamadı',
      ));
    } catch (e) {
      // ignore: avoid_print
      print('Rates ERROR: $e');
      // Hata olsa da mevcut oranları koruyalım, UI bozulmasın
      emit(state.copyWith(loading: false, error: 'Kur hatası'));
    }
  }

  void changeSelected(String cur) {
    if (state.rates.containsKey(cur)) {
      emit(state.copyWith(selected: cur));
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
