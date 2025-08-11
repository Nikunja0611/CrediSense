class BudgetModel {
  final String category;
  final double spent;
  final double limit;

  BudgetModel({
    required this.category,
    required this.spent,
    required this.limit,
  });

  double get percent => (limit == 0) ? 0.0 : (spent / limit).clamp(0.0, 1.0);
}
