import 'package:equatable/equatable.dart';
 class PriceModel extends Equatable{
  
  final String symbol;
  final double price;

  const PriceModel({
    required this.symbol,
    required this.price
  });

  factory PriceModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return PriceModel(
      symbol: data['s'],
      price: data['p']);

  }
  
  @override
  List<Object?> get props => throw UnimplementedError();
}