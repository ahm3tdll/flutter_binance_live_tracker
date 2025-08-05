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
      backgroundColor: const Color(0xFF121212), // Sayfa arka planı koyu
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
        builder: (context, state) {
          if (state is PriceLoaded) {
            return ListView.builder(
              itemCount: state.prices.length,
              itemBuilder: (context, index) {
                final price = state.prices[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blueGrey[700], // Kabarcık arka plan rengi
                      borderRadius: BorderRadius.circular(20), // Yuvarlak köşeler
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
                        price.symbol.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      trailing: Text(
                        '${price.price.toStringAsFixed(2)} ₺',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.greenAccent,
                        ),
                      ),
                    ),
                  ),
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
