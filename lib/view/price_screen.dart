import 'package:flutter/material.dart';
import 'package:flutter_binance_tracker/widgets/price_tile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/price_bloc.dart';
import '../bloc/price_state.dart';

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
      body: BlocBuilder<PriceBloc, PriceState>(
        buildWhen: (previous, current) => current is PriceLoaded,
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
    );
  }
}
