import 'package:flutter/material.dart';
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
      buildWhen: (previous, current) {
        if (previous is PriceLoaded && current is PriceLoaded) {
          final oldPrice = previous.prices.firstWhere(
            (e) => e.symbol == symbol,
            orElse: () => PriceModel(symbol: symbol, price: 0),
          );

          final newPrice = current.prices.firstWhere(
            (e) => e.symbol == symbol,
            orElse: () => PriceModel(symbol: symbol, price: 0),
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
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                title: Text(
                  symbol.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                trailing: Text(
                  '${price.price.toStringAsFixed(2)} \$',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.greenAccent,
                  ),
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
