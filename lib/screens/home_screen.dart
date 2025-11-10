import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/atm_card.dart';
import '../widgets/grid_menu_item.dart';
import '../widgets/transaction_item.dart';
import '../models/transaction_model.dart';
import '../db/db_helper.dart';
import 'add_transaction_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<TransactionModel> _transactions = [];

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    final data = await DBHelper.getAllTransactions();
    setState(() {
      _transactions = data;
    });
  }

  void _openAdd() async {
    final result = await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AddTransactionScreen()));
    if (result == true) {
      _loadTransactions();
    }
  }

  void _deleteTx(int id) async {
    await DBHelper.deleteTransaction(id);
    _loadTransactions();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Transaksi dihapus')));
  }

  String _format(double amt) {
    final f = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return f.format(amt);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWide = size.width > 600;
    final primary = Theme.of(context).colorScheme.primary;

    double totalBalance = _transactions.fold(0.0, (prev, e) => prev + e.amount);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Finance Dashboard - Merah Putih'),
        backgroundColor: primary,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAdd,
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with logo and balance
              Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 6, offset: const Offset(0,3))],
                    ),
                    child: Image.asset('assets/images/utb_logo.png'),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hai, M. Fikri M', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('Saldo: ' + _format(totalBalance), style: TextStyle(color: Colors.black87)),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 18),

              // ATM cards
              isWide
                  ? Row(
                      children: const [
                        Expanded(child: AtmCard(bankName: 'Bank Merah Putih', cardNumber: '5088 0000 1234 5678', holderName: 'M. Fikri M', balance: 7250000)),
                        SizedBox(width: 12),
                        Expanded(child: AtmCard(bankName: 'Bank Pertiwi', cardNumber: '5088 1111 2233 4455', holderName: 'M. Fikri M', balance: 289000)),
                      ],
                    )
                  : Column(
                      children: const [
                        AtmCard(bankName: 'Bank Merah Putih', cardNumber: '5088 0000 1234 5678', holderName: 'M. Fikri M', balance: 7250000),
                        SizedBox(height: 12),
                        AtmCard(bankName: 'Bank Pertiwi', cardNumber: '5088 1111 2233 4455', holderName: 'M. Fikri M', balance: 289000),
                      ],
                    ),
              const SizedBox(height: 20),

              // Grid menu
              GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children: const [
                  GridMenuItem(icon: Icons.send, label: 'Transfer'),
                  GridMenuItem(icon: Icons.payments, label: 'TopUp'),
                  GridMenuItem(icon: Icons.receipt_long, label: 'Bills'),
                  GridMenuItem(icon: Icons.bar_chart, label: 'Summary'),
                ],
              ),
              const SizedBox(height: 18),

              // Transactions header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Recent Transactions', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  TextButton.icon(onPressed: _loadTransactions, icon: const Icon(Icons.refresh), label: const Text('Refresh'))
                ],
              ),
              const SizedBox(height: 8),

              // transactions list
              _transactions.isEmpty
                  ? Center(child: Padding(padding: const EdgeInsets.all(24.0), child: Text('Belum ada transaksi. Tekan + untuk menambah.', style: TextStyle(color: Colors.black54))))
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _transactions.length,
                      itemBuilder: (context, idx) {
                        final tx = _transactions[idx];
                        return Dismissible(
                          key: ValueKey(tx.id),
                          background: Container(color: Colors.redAccent, alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 20), child: const Icon(Icons.delete, color: Colors.white)),
                          direction: DismissDirection.endToStart,
                          confirmDismiss: (direction) async {
                            final res = await showDialog<bool>(context: context, builder: (c) => AlertDialog(
                              title: const Text('Hapus transaksi?'),
                              content: const Text('Yakin ingin menghapus transaksi ini?'),
                              actions: [
                                TextButton(onPressed: () => Navigator.of(c).pop(false), child: const Text('Batal')),
                                TextButton(onPressed: () => Navigator.of(c).pop(true), child: const Text('Hapus')),
                              ],
                            ));
                            return res ?? false;
                          },
                          onDismissed: (_) {
                            if (tx.id != null) _deleteTx(tx.id!);
                          },
                          child: TransactionItem(name: tx.title, amount: tx.amount, date: DateFormat('dd MMM yyyy').format(DateTime.parse(tx.date))),
                        );
                      },
                    ),

            ],
          ),
        ),
      ),
    );
  }
}
