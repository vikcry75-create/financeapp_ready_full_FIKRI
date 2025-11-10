import 'package:flutter/material.dart';

class TransactionItem extends StatelessWidget {
  final String name;
  final double amount;
  final String date;

  const TransactionItem({required this.name, required this.amount, required this.date, super.key});

  String _fmt(double amt) {
    final s = amt.abs().toStringAsFixed(0);
    return 'Rp ' + s.replaceAllMapped(RegExp(r"\B(?=(\d{3})+(?!\d))"), (m) => '.');
  }

  @override
  Widget build(BuildContext context) {
    final positive = amount >= 0;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: positive ? Colors.green.withOpacity(0.12) : Colors.red.withOpacity(0.12),
          child: Icon(positive ? Icons.arrow_upward : Icons.arrow_downward, color: positive ? Colors.green : Colors.red),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(date),
        trailing: Text((positive ? '+ ' : '- ') + _fmt(amount), style: TextStyle(color: positive ? Colors.green : Colors.red, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
