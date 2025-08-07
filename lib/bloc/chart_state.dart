import 'package:flutter_binance_tracker/model/chart_model.dart';

abstract class ChartState {}

class ChartInitial extends ChartState {}

class ChartLoading extends ChartState {}

class ChartLoaded extends ChartState {
  final List<ChartDataModel> data;

  ChartLoaded(this.data);
}

class ChartError extends ChartState {
  final String message;

  ChartError(this.message);
}



