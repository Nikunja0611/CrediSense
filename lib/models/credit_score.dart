class CreditScoreModel {
  final double score;
  final List<double> scoreTrend;        // e.g. last 6 months score trend
  final List<double> utilizationTrend;  // e.g. credit utilization %
  final int missedPayments;             // total missed payments
  final int onTimePayments;             // total on-time payments

  CreditScoreModel({
    required this.score,
    required this.scoreTrend,
    required this.utilizationTrend,
    required this.missedPayments,
    required this.onTimePayments,
  });

  // ✅ From JSON (API Response)
  factory CreditScoreModel.fromJson(Map<String, dynamic> json) {
    return CreditScoreModel(
      score: (json['score'] ?? 0).toDouble(),
      scoreTrend: (json['scoreTrend'] as List?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          [],
      utilizationTrend: (json['utilizationTrend'] as List?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          [],
      missedPayments: (json['missedPayments'] ?? 0) as int,
      onTimePayments: (json['onTimePayments'] ?? 0) as int,
    );
  }

  // ✅ From FinanceProvider (fallback if API not available)
  factory CreditScoreModel.fromProvider(dynamic finance) {
    return CreditScoreModel(
      score: (finance.creditScoreLgbm ?? 
              finance.creditScoreXgb ?? 
              finance.creditScore).toDouble(),
      scoreTrend: [],          // you can later link with historical scores
      utilizationTrend: [],    // link with utilization % trend if tracked
      missedPayments: 0,       // placeholder (to be fetched from backend/db)
      onTimePayments: 0,       // placeholder
    );
  }
}
