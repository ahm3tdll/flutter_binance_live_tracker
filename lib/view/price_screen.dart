import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/price_bloc.dart';
import '../bloc/price_event.dart';
import '../bloc/price_state.dart';

class PriceScreen extends StatelessWidget {
  const PriceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<PriceBloc>().add(StartListening());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Canlı Fiyatlar'),
      ),
      body: BlocBuilder<PriceBloc, PriceState>(
        builder: (context, state) {
          if (state is PriceLoaded) {
            return ListView.builder(
              itemCount: state.prices.length,
              itemBuilder: (context, index) {
                final price = state.prices[index];
                return ListTile(
                  title: Text(price.symbol),
                  trailing: Text(price.price.toStringAsFixed(2)),
                );
              },
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
