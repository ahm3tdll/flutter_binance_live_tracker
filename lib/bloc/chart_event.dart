abstract class ChartEvent {}

class FetchChartData extends ChartEvent {
  final String symbol;

  FetchChartData(this.symbol);

}