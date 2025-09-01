class FinancialAggregates {
  final int upiTxnCount7d;
  final int upiTxnCount30d;
  final int upiTxnCount90d;
  final double upiSpend7d;
  final double upiSpend30d;
  final double upiSpend90d;
  final double avgTxnAmount;
  final double txnVariance;
  
  // Categories
  final Map<String, double> categorySpend30d;
  final Map<String, int> categoryCount30d;
  
  // Credit card insights
  final double cardMinDueRate90d;
  final bool lateFeeFlag90d;
  final double billPaidOnTimeRate90d;
  final double creditUtilizationApprox;
  
  // EMI insights
  final int emiPayments90d;
  final int emiOverdue90d;
  final bool emiBouncedFlag;
  
  // Salary insights
  final bool salaryDetected;
  final DateTime? lastSalaryDate;
  
  // Autopay insights
  final int autopayUsage30d;
  final List<String> autopayMerchants;
  
  // Balance insights
  final int balanceAlerts30d;
  final bool lowBalanceFlag;
  
  // Merchant insights
  final int merchantDiversity30d;
  final List<String> topMerchants;

  FinancialAggregates({
    required this.upiTxnCount7d,
    required this.upiTxnCount30d,
    required this.upiTxnCount90d,
    required this.upiSpend7d,
    required this.upiSpend30d,
    required this.upiSpend90d,
    required this.avgTxnAmount,
    required this.txnVariance,
    required this.categorySpend30d,
    required this.categoryCount30d,
    required this.cardMinDueRate90d,
    required this.lateFeeFlag90d,
    required this.billPaidOnTimeRate90d,
    required this.creditUtilizationApprox,
    required this.emiPayments90d,
    required this.emiOverdue90d,
    required this.emiBouncedFlag,
    required this.salaryDetected,
    this.lastSalaryDate,
    required this.autopayUsage30d,
    required this.autopayMerchants,
    required this.balanceAlerts30d,
    required this.lowBalanceFlag,
    required this.merchantDiversity30d,
    required this.topMerchants,
  });

  Map<String, dynamic> toJson() {
    return {
      'upiTxnCount7d': upiTxnCount7d,
      'upiTxnCount30d': upiTxnCount30d,
      'upiTxnCount90d': upiTxnCount90d,
      'upiSpend7d': upiSpend7d,
      'upiSpend30d': upiSpend30d,
      'upiSpend90d': upiSpend90d,
      'avgTxnAmount': avgTxnAmount,
      'txnVariance': txnVariance,
      'categorySpend30d': categorySpend30d,
      'categoryCount30d': categoryCount30d,
      'cardMinDueRate90d': cardMinDueRate90d,
      'lateFeeFlag90d': lateFeeFlag90d,
      'billPaidOnTimeRate90d': billPaidOnTimeRate90d,
      'creditUtilizationApprox': creditUtilizationApprox,
      'emiPayments90d': emiPayments90d,
      'emiOverdue90d': emiOverdue90d,
      'emiBouncedFlag': emiBouncedFlag,
      'salaryDetected': salaryDetected,
      'lastSalaryDate': lastSalaryDate?.toIso8601String(),
      'autopayUsage30d': autopayUsage30d,
      'autopayMerchants': autopayMerchants,
      'balanceAlerts30d': balanceAlerts30d,
      'lowBalanceFlag': lowBalanceFlag,
      'merchantDiversity30d': merchantDiversity30d,
      'topMerchants': topMerchants,
    };
  }

  factory FinancialAggregates.fromJson(Map<String, dynamic> json) {
    return FinancialAggregates(
      upiTxnCount7d: json['upiTxnCount7d'] ?? 0,
      upiTxnCount30d: json['upiTxnCount30d'] ?? 0,
      upiTxnCount90d: json['upiTxnCount90d'] ?? 0,
      upiSpend7d: (json['upiSpend7d'] ?? 0).toDouble(),
      upiSpend30d: (json['upiSpend30d'] ?? 0).toDouble(),
      upiSpend90d: (json['upiSpend90d'] ?? 0).toDouble(),
      avgTxnAmount: (json['avgTxnAmount'] ?? 0).toDouble(),
      txnVariance: (json['txnVariance'] ?? 0).toDouble(),
      categorySpend30d: Map<String, double>.from(json['categorySpend30d'] ?? {}),
      categoryCount30d: Map<String, int>.from(json['categoryCount30d'] ?? {}),
      cardMinDueRate90d: (json['cardMinDueRate90d'] ?? 0).toDouble(),
      lateFeeFlag90d: json['lateFeeFlag90d'] ?? false,
      billPaidOnTimeRate90d: (json['billPaidOnTimeRate90d'] ?? 0).toDouble(),
      creditUtilizationApprox: (json['creditUtilizationApprox'] ?? 0).toDouble(),
      emiPayments90d: json['emiPayments90d'] ?? 0,
      emiOverdue90d: json['emiOverdue90d'] ?? 0,
      emiBouncedFlag: json['emiBouncedFlag'] ?? false,
      salaryDetected: json['salaryDetected'] ?? false,
      lastSalaryDate: json['lastSalaryDate'] != null 
          ? DateTime.parse(json['lastSalaryDate']) 
          : null,
      autopayUsage30d: json['autopayUsage30d'] ?? 0,
      autopayMerchants: List<String>.from(json['autopayMerchants'] ?? []),
      balanceAlerts30d: json['balanceAlerts30d'] ?? 0,
      lowBalanceFlag: json['lowBalanceFlag'] ?? false,
      merchantDiversity30d: json['merchantDiversity30d'] ?? 0,
      topMerchants: List<String>.from(json['topMerchants'] ?? []),
    );
  }
}
