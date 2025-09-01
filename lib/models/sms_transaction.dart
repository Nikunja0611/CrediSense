class SMSTransaction {
  final String id;
  final String sender;
  final String message;
  final DateTime timestamp;
  final TransactionType type;
  final double? amount;
  final String? merchant;
  final String? category;
  final String? cardNumber;
  final String? accountNumber;
  final bool isProcessed;
  
  // Financial insights
  final bool isUPI;
  final bool isCreditCard;
  final bool isEMI;
  final bool isSalary;
  final bool isAutopay;
  final bool isBalanceAlert;
  final bool isOverdue;
  final bool isLateFee;

  SMSTransaction({
    required this.id,
    required this.sender,
    required this.message,
    required this.timestamp,
    required this.type,
    this.amount,
    this.merchant,
    this.category,
    this.cardNumber,
    this.accountNumber,
    this.isProcessed = false,
    this.isUPI = false,
    this.isCreditCard = false,
    this.isEMI = false,
    this.isSalary = false,
    this.isAutopay = false,
    this.isBalanceAlert = false,
    this.isOverdue = false,
    this.isLateFee = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender': sender,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'type': type.toString(),
      'amount': amount,
      'merchant': merchant,
      'category': category,
      'cardNumber': cardNumber,
      'accountNumber': accountNumber,
      'isProcessed': isProcessed,
      'isUPI': isUPI,
      'isCreditCard': isCreditCard,
      'isEMI': isEMI,
      'isSalary': isSalary,
      'isAutopay': isAutopay,
      'isBalanceAlert': isBalanceAlert,
      'isOverdue': isOverdue,
      'isLateFee': isLateFee,
    };
  }

  factory SMSTransaction.fromJson(Map<String, dynamic> json) {
    return SMSTransaction(
      id: json['id'],
      sender: json['sender'],
      message: json['message'],
      timestamp: DateTime.parse(json['timestamp']),
      type: TransactionType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => TransactionType.alert,
      ),
      amount: json['amount']?.toDouble(),
      merchant: json['merchant'],
      category: json['category'],
      cardNumber: json['cardNumber'],
      accountNumber: json['accountNumber'],
      isProcessed: json['isProcessed'] ?? false,
      isUPI: json['isUPI'] ?? false,
      isCreditCard: json['isCreditCard'] ?? false,
      isEMI: json['isEMI'] ?? false,
      isSalary: json['isSalary'] ?? false,
      isAutopay: json['isAutopay'] ?? false,
      isBalanceAlert: json['isBalanceAlert'] ?? false,
      isOverdue: json['isOverdue'] ?? false,
      isLateFee: json['isLateFee'] ?? false,
    );
  }
}

enum TransactionType {
  debit,
  credit,
  alert,
  statement,
  emi,
  salary,
  autopay,
  balance,
}
