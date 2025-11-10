import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../db/db_helper.dart';
import '../models/transaction_model.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleC = TextEditingController();
  final _amountC = TextEditingController();
  DateTime _selected = DateTime.now();
  bool _isExpense = true;

  @override
  void dispose() {
    _titleC.dispose();
    _amountC.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final title = _titleC.text.trim();
    final amt = double.tryParse(_amountC.text.replaceAll(',', '')) ?? 0.0;
    final value = _isExpense ? -amt : amt;
    final model = TransactionModel(title: title, amount: value, date: _selected.toIso8601String());
    await DBHelper.insertTransaction(model);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Transaksi tersimpan')));
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Transaksi')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(controller: _titleC, decoration: const InputDecoration(labelText: 'Judul'), validator: (v) => v==null||v.trim().isEmpty ? 'Judul diperlukan' : null),
              const SizedBox(height: 12),
              TextFormField(controller: _amountC, decoration: const InputDecoration(labelText: 'Jumlah (angka)'), keyboardType: TextInputType.number, validator: (v) {
                if (v==null || v.trim().isEmpty) return 'Jumlah diperlukan';
                if (double.tryParse(v.replaceAll(',', ''))==null) return 'Masukkan angka yang valid';
                return null;
              }),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: Text('Tipe:')),
                  ChoiceChip(label: const Text('Pengeluaran'), selected: _isExpense, onSelected: (s) => setState(()=> _isExpense = true)),
                  const SizedBox(width: 8),
                  ChoiceChip(label: const Text('Pemasukan'), selected: !_isExpense, onSelected: (s) => setState(()=> _isExpense = false)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: Text('Tanggal: ' + DateFormat('dd MMM yyyy').format(_selected))),
                  TextButton(onPressed: () async {
                    final picked = await showDatePicker(context: context, initialDate: _selected, firstDate: DateTime(2000), lastDate: DateTime(2100));
                    if (picked!=null) setState(()=> _selected = picked);
                  }, child: const Text('Pilih')),
                ],
              ),
              const SizedBox(height: 18),
              ElevatedButton.icon(onPressed: _save, icon: const Icon(Icons.save), label: const Text('Simpan')),
            ],
          ),
        ),
      ),
    );
  }
}
