class ChartDataModel {
  final DateTime time;
  final double close;

  ChartDataModel({required this.time, required this.close});

  factory ChartDataModel.fromKline(List<dynamic> kline) {
    return ChartDataModel(
      time: DateTime.fromMillisecondsSinceEpoch(kline[0]),
      close: double.parse(kline[4]),
    );
  }
 
}