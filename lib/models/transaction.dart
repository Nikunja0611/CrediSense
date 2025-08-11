class TransactionModel {
  final String id;
  final String title;
  final String category;
  final double amount;
  final DateTime date;
  final bool isExpense;

  TransactionModel({
    required this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.date,
    required this.isExpense,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> j) {
    return TransactionModel(
      id: j['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: j['title'] ?? '',
      category: j['category'] ?? 'General',
      amount: (j['amount'] as num).toDouble(),
      date: DateTime.parse(j['date']),
      isExpense: j['isExpense'] ?? true,
    );
  }
}
