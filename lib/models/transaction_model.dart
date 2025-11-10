class TransactionModel {
  int? id;
  String title;
  double amount;
  String date; // store as ISO string

  TransactionModel({this.id, required this.title, required this.amount, required this.date});

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'title': title,
      'amount': amount,
      'date': date,
    };
    if (id != null) map['id'] = id;
    return map;
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'] as int?,
      title: map['title'] as String,
      amount: (map['amount'] as num).toDouble(),
      date: map['date'] as String,
    );
  }
}
