import 'package:flutter_binance_tracker/model/price_model.dart';

abstract class PriceEvent {}

class StartListening extends PriceEvent {}

class PriceUpdated extends PriceEvent {
  final PriceModel price;
  PriceUpdated(this.price);
}

class ChangeQuote extends PriceEvent {
  final String quote;
  ChangeQuote(this.quote);
}
