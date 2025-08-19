import 'package:flutter/material.dart';
import 'package:flutter_binance_tracker/bloc/rates_qubit.dart';
import 'package:flutter_binance_tracker/widgets/price_tile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/price_bloc.dart';
import '../bloc/price_state.dart';
import '../bloc/price_event.dart';

class PriceScreen extends StatelessWidget {
  const PriceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2A2D34),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Blocnance',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: Column(
        children: [
          // Para birimi dropdown (USD / TRY / EUR)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            color: Colors.blueGrey[800],
            child: BlocBuilder<RatesCubit, RatesState>(
              builder: (context, rstate) {
                return Row(
                  children: [
                    const Text('Para Birimi:', style: TextStyle(color: Colors.white70)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: rstate.selected,
                        dropdownColor: Colors.blueGrey[900],
                        underline: const SizedBox(),
                        style: const TextStyle(color: Colors.white),
                        items: const [
                          DropdownMenuItem(value: 'USD', child: Text('USD (\$)')),
                          DropdownMenuItem(value: 'TRY', child: Text('TRY (₺)')),
                          DropdownMenuItem(value: 'EUR', child: Text('EUR (€)')),
                        ],
                        onChanged: (v) {
                          if (v != null) context.read<RatesCubit>().changeSelected(v);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (rstate.loading)
                      const SizedBox(
                        width: 16, height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    if (rstate.error != null) ...[
                      const SizedBox(width: 8),
                      const Icon(Icons.error, size: 18, color: Colors.redAccent),
                    ],
                  ],
                );
              },
            ),
          ),

          // Fiyat listesi
          Expanded(
            child: BlocBuilder<PriceBloc, PriceState>(
              builder: (context, state) {
                if (state is PriceLoaded) {
                  return ListView.builder(
                    itemCount: state.prices.length,
                    itemBuilder: (context, index) {
                      return PriceTile(symbol: state.prices[index].symbol);
                    },
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }
}
