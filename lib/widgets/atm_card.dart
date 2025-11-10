import 'package:flutter/material.dart';

class AtmCard extends StatelessWidget {
  final String bankName;
  final String cardNumber;
  final String holderName;
  final double balance;

  const AtmCard({required this.bankName, required this.cardNumber, required this.holderName, required this.balance, super.key});

  String _fmt(double v) {
    final s = v.toStringAsFixed(0);
    return 'Rp ' + s.replaceAllMapped(RegExp(r"\B(?=(\d{3})+(?!\d))"), (m) => '.');
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [primary, primary.withOpacity(0.9)]),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 8, offset: const Offset(0,4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(bankName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 14),
          Text(cardNumber, style: const TextStyle(color: Colors.white70, letterSpacing: 2)),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(holderName, style: const TextStyle(color: Colors.white70)),
              Text(_fmt(balance), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}
