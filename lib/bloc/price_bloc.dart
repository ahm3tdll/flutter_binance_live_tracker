import 'dart:async';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../model/price_model.dart';
import 'price_event.dart';
import 'price_state.dart';

class PriceBloc extends Bloc<PriceEvent, PriceState> {
  final List<PriceModel> _prices = [];
  WebSocketChannel? _channel;
  StreamSubscription? _subscription;

  // Her zaman USDT stream: BTC/ETH/DOGE/APT
  final List<String> _bases = ['BTC', 'ETH', 'DOGE', 'APT'];

  PriceBloc() : super(PriceInitial()) {
    on<StartListening>((event, emit) async {
      await _connect(emit);
    });

    // ChangeQuote artık kullanılmıyor; kalabilir ama etkisiz
    on<PriceUpdated>(_onPriceUpdated);
  }

  Future<void> _connect(Emitter<PriceState> emit) async {
    await _subscription?.cancel();
    await _channel?.sink.close();

    emit(PriceInitial()); // kısa spinner
    _prices.clear();

    final streams = _bases
        .map((b) => '${b.toLowerCase()}usdt@trade')
        .join('/');

    final url = 'wss://stream.binance.com:9443/stream?streams=$streams';
    _channel = WebSocketChannel.connect(Uri.parse(url));

    _subscription = _channel!.stream.listen((message) {
      final jsonData = jsonDecode(message);
      final price = PriceModel.fromJson(jsonData); // symbol: BTCUSDT, price: p
      add(PriceUpdated(price));
    });
  }

  void _onPriceUpdated(PriceUpdated event, Emitter<PriceState> emit) {
    final i = _prices.indexWhere((e) => e.symbol == event.price.symbol);
    if (i != -1) {
      _prices[i] = event.price;
    } else {
      _prices.add(event.price);
    }
    // her yeni fiyatla listeyi anında güncelle
    emit(PriceLoaded(List.from(_prices)));
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    await _channel?.sink.close();
    return super.close();
  }
}
