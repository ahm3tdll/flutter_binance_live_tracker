import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../model/price_model.dart';
import 'price_event.dart';
import 'price_state.dart';

class PriceBloc extends Bloc<PriceEvent, PriceState> {
  final List<PriceModel> _prices = [];
  late WebSocketChannel _channel;
  StreamSubscription? _subscription;

  PriceBloc() : super(PriceInitial()) {
    on<StartListening>(_onStartListening);
    on<PriceUpdated>(_onPriceUpdated);
  }

  void _onStartListening(StartListening event, Emitter<PriceState> emit) {
    _channel = WebSocketChannel.connect(
      Uri.parse('wss://stream.binance.com:9443/stream?streams=btcusdt@trade/ethusdt@trade/usdttry@trade/eurtry@trade/xautry@trade'),
    );

    _subscription = _channel.stream.listen((message) {
      final jsonData = jsonDecode(message);
      final price = PriceModel.fromJson(jsonData);
      add(PriceUpdated(price));
    });
  }

  void _onPriceUpdated(PriceUpdated event, Emitter<PriceState> emit) {
    final index = _prices.indexWhere((e) => e.symbol == event.price.symbol);

    if (index != -1) {
      _prices[index] = event.price;
    } else {
      _prices.add(event.price);
    }

    emit(PriceLoaded(List.from(_prices)));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    _channel.sink.close();
    return super.close();
  }
}
