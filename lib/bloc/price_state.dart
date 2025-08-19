import 'package:flutter_binance_tracker/model/price_model.dart';

abstract class PriceState {}

class PriceInitial extends PriceState {}

class PriceLoaded extends PriceState {
  final List<PriceModel> prices;
  PriceLoaded(this.prices);
}
