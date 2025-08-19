import 'package:flutter/material.dart';
import 'package:flutter_binance_tracker/bloc/rates_qubit.dart';
import 'package:flutter_binance_tracker/view/coin_detail_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/price_bloc.dart';
import '../../../bloc/price_state.dart';
import '../../../model/price_model.dart';

class PriceTile extends StatelessWidget {
  final String symbol;

  const PriceTile({super.key, required this.symbol});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PriceBloc, PriceState>(
      // Fiyat akışı için filtre (aynı kaldı)
      buildWhen: (previous, current) {
        if (previous is PriceLoaded && current is PriceLoaded) {
          final oldPrice = previous.prices.firstWhere(
            (e) => e.symbol == symbol,
            orElse: () => const PriceModel(symbol: '', price: 0),
          );
          final newPrice = current.prices.firstWhere(
            (e) => e.symbol == symbol,
            orElse: () => const PriceModel(symbol: '', price: 0),
          );
          return oldPrice.price != newPrice.price;
        }
        return true;
      },
      builder: (context, state) {
        if (state is PriceLoaded) {
          final price = state.prices.firstWhere((e) => e.symbol == symbol);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blueGrey[700],
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CoinDetailScreen(symbol: symbol),
                    ),
                  );
                },
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                title: Text(
                  symbol.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                // 👇 Kur değişimlerini ayrı dinliyoruz: sadece bu kısım rebuild olur
                trailing: BlocBuilder<RatesCubit, RatesState>(
                  builder: (context, rstate) {
                    final rate = rstate.rates[rstate.selected] ?? 1.0;
                    final converted = price.price * rate;
                    final sign = rstate.selected == 'USD'
                        ? '\$'
                        : rstate.selected == 'TRY'
                            ? '₺'
                            : '€';
                    return Text(
                      '${converted.toStringAsFixed(2)} $sign',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.greenAccent,
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
