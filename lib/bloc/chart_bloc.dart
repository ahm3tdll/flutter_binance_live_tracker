import 'dart:convert';

import 'package:flutter_binance_tracker/bloc/chart_event.dart';
import 'package:flutter_binance_tracker/bloc/chart_state.dart';
import 'package:flutter_binance_tracker/model/chart_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class ChartBloc extends Bloc<ChartEvent, ChartState> {
  ChartBloc() : super(ChartInitial()) {
    on<FetchChartData>(_onFetchChartData);
  }

  Future<void> _onFetchChartData(FetchChartData event, Emitter<ChartState> emit) async {
    emit(ChartLoading());
    try {
      final uri = Uri.parse(
        'https://api.binance.com/api/v3/klines?symbol=${event.symbol.toUpperCase()}&interval=1d&limit=30',
      );
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> rawData = jsonDecode(response.body);
        final data = rawData.map((e) => ChartDataModel.fromKline(e)).toList();
        emit(ChartLoaded(data));
      } else {
        emit(ChartError('Veri alınamadı'));
      }
    } catch (e) {
      emit(ChartError(e.toString()));
    }
  }
}