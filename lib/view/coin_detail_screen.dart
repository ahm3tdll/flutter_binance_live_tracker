import 'package:flutter/material.dart';
import 'package:flutter_binance_tracker/bloc/chart_bloc.dart';
import 'package:flutter_binance_tracker/bloc/chart_event.dart';
import 'package:flutter_binance_tracker/bloc/chart_state.dart';
import 'package:flutter_binance_tracker/widgets/chart_line.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CoinDetailScreen extends StatelessWidget {
  final String symbol;

  const CoinDetailScreen({super.key, required this.symbol});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChartBloc()..add(FetchChartData(symbol)),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '$symbol Detayı',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          backgroundColor: Colors.blueGrey[900],
        ),
        backgroundColor: const Color(0xFF2A2D34), // Gunmetal zemin
        body: BlocBuilder<ChartBloc, ChartState>(
          builder: (context, state) {
            if (state is ChartLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ChartLoaded) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF3A3D44), // Çerçeve rengi (bir ton açık)
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: ChartLine(data: state.data),
                    ),
                  ),
                ),
              );
            } else if (state is ChartError) {
              return Center(
                child: Text(
                  'Hata: ${state.message}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            } else {
              return const Center(
                child: Text(
                  'Veri bekleniyor...',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
