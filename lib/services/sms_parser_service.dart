import '../models/sms_transaction.dart';

class SMSParserService {
  // Indian Bank SMS Patterns
  static final RegExp bankDebitPattern = RegExp(
    r'(?:A/c|Account)\s*\*?(\d+)\s+(?:debited|charged)\s+(?:Rs\.?|INR)\s*(\d+(?:,\d+)*(?:\.\d{2})?)',
    caseSensitive: false
  );
  
  static final RegExp bankCreditPattern = RegExp(
    r'(?:Rs\.?|INR)\s*(\d+(?:,\d+)*(?:\.\d{2})?)\s+(?:credited|received)\s+(?:to|in)\s+(?:a/c|account)\s*\*?(\d+)',
    caseSensitive: false
  );
  
  // Alternative patterns for different bank formats
  static final RegExp bankDebitPattern2 = RegExp(
    r'(?:Rs\.?|INR)\s*(\d+(?:,\d+)*(?:\.\d{2})?)\s+(?:debited|charged)',
    caseSensitive: false
  );
  
  static final RegExp bankCreditPattern2 = RegExp(
    r'(?:Rs\.?|INR)\s*(\d+(?:,\d+)*(?:\.\d{2})?)\s+(?:credited|received)',
    caseSensitive: false
  );
  
  // UPI Patterns (enhanced for better merchant extraction)
  static final RegExp upiDebitPattern = RegExp(
    r'Rs\.?(\d+(?:,\d+)*(?:\.\d{2})?)\s+(?:debited|paid)\s+(?:to|from)\s+([A-Za-z0-9@.\s]+)',
    caseSensitive: false
  );
  
  static final RegExp upiCreditPattern = RegExp(
    r'Rs\.?(\d+(?:,\d+)*(?:\.\d{2})?)\s+(?:credited|received)\s+(?:from|by)\s+([A-Za-z0-9@.\s]+)',
    caseSensitive: false
  );
  
  // Additional UPI patterns for different formats
  static final RegExp upiPattern1 = RegExp(
    r'UPI.*?Rs\.?(\d+(?:,\d+)*(?:\.\d{2})?)\s+(?:debited|paid)',
    caseSensitive: false
  );
  
  static final RegExp upiPattern2 = RegExp(
    r'Rs\.?(\d+(?:,\d+)*(?:\.\d{2})?)\s+(?:debited|paid).*?UPI',
    caseSensitive: false
  );
  
  // Credit Card Patterns
  static final RegExp cardStatementPattern = RegExp(
    r'(?:MIN DUE|TOTAL DUE|OVERDUE|LATE FEE).*?Rs\.?(\d+(?:,\d+)*(?:\.\d{2})?)',
    caseSensitive: false
  );
  
  // EMI Patterns
  static final RegExp emiPaymentPattern = RegExp(
    r'(?:EMI paid|EMI overdue|bounced).*?Rs\.?(\d+(?:,\d+)*(?:\.\d{2})?)',
    caseSensitive: false
  );
  
  // Salary Patterns
  static final RegExp salaryPattern = RegExp(
    r'(?:credited salary|salary credited).*?Rs\.?(\d+(?:,\d+)*(?:\.\d{2})?)',
    caseSensitive: false
  );
  
  // Autopay Patterns
  static final RegExp autopayPattern = RegExp(
    r'(?:auto-debit|autopay).*?Rs\.?(\d+(?:,\d+)*(?:\.\d{2})?)',
    caseSensitive: false
  );
  
  // Balance Patterns
  static final RegExp balanceAlertPattern = RegExp(
    r'(?:Available balance is low|low balance|insufficient funds)',
    caseSensitive: false
  );
  
  // Enhanced Merchant categorization for Phase 2
  static final Map<String, String> merchantCategories = {
    // Utilities
    'electricity': 'Utilities',
    'gas': 'Fuel',
    'water': 'Utilities',
    'internet': 'Utilities',
    'phone': 'Utilities',
    'airtel': 'Utilities',
    'jio': 'Utilities',
    'vi': 'Utilities',
    'bsnl': 'Utilities',
    'mtnl': 'Utilities',
    
    // Fuel
    'petrol': 'Fuel',
    'diesel': 'Fuel',
    'gasoline': 'Fuel',
    'bp': 'Fuel',
    'shell': 'Fuel',
    'hp': 'Fuel',
    'indianoil': 'Fuel',
    
    // Shopping
    'amazon': 'Shopping',
    'flipkart': 'Shopping',
    'myntra': 'Shopping',
    'zudio': 'Shopping',
    'lenskart': 'Shopping',
    'nykaa': 'Shopping',
    'ajio': 'Shopping',
    'snapdeal': 'Shopping',
    'paytmmall': 'Shopping',
    
    // Food
    'swiggy': 'Food',
    'zomato': 'Food',
    'zepto': 'Food',
    'blinkit': 'Food',
    'dunzo': 'Food',
    'tacobell': 'Food',
    'mcdonalds': 'Food',
    'kfc': 'Food',
    'dominos': 'Food',
    'pizzahut': 'Food',
    'burgerking': 'Food',
    'subway': 'Food',
    
    // Travel
    'uber': 'Travel',
    'ola': 'Travel',
    'irctc': 'Travel',
    'makemytrip': 'Travel',
    'goibibo': 'Travel',
    'yatra': 'Travel',
    'cleartrip': 'Travel',
    'airindia': 'Travel',
    'indigo': 'Travel',
    'spicejet': 'Travel',
    'airasia': 'Travel',
    'vistara': 'Travel',
    
    // Entertainment
    'netflix': 'Entertainment',
    'amazonprime': 'Entertainment',
    'hotstar': 'Entertainment',
    'sonyliv': 'Entertainment',
    'zee5': 'Entertainment',
    'voot': 'Entertainment',
    'mxplayer': 'Entertainment',
    'bookmyshow': 'Entertainment',
    
    // Banking & Finance
    'hdfc': 'Banking',
    'axis': 'Banking',
    'sbi': 'Banking',
    'icici': 'Banking',
    'kotak': 'Banking',
    'yesbank': 'Banking',
    'pnb': 'Banking',
    'canara': 'Banking',
    'unionbank': 'Banking',
    
    // Healthcare
    'pharmeasy': 'Healthcare',
    '1mg': 'Healthcare',
    'netmeds': 'Healthcare',
    'medplus': 'Healthcare',
    'apollo': 'Healthcare',
    'fortis': 'Healthcare',
    'max': 'Healthcare',
    
    // Education
    'byjus': 'Education',
    'unacademy': 'Education',
    'vedantu': 'Education',
    'coursera': 'Education',
    'udemy': 'Education',
    'skillshare': 'Education',
    
    // Gaming
    'pubg': 'Gaming',
    'freefire': 'Gaming',
    'bgmi': 'Gaming',
    'cod': 'Gaming',
    'valorant': 'Gaming',
    
    // Insurance
    'lic': 'Insurance',
    'bajaj': 'Insurance',
    'hdfcergo': 'Insurance',
    'icicilombard': 'Insurance',
    'maxlife': 'Insurance',
  };
  
  static SMSTransaction? parseSMS(String sender, String message, DateTime timestamp) {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    
    // 1. Check for Indian Bank debit transactions
    final bankDebitMatch = bankDebitPattern.firstMatch(message);
    if (bankDebitMatch != null) {
      final accountNumber = bankDebitMatch.group(1);
      final amount = _extractAmount(bankDebitMatch.group(2)!);
      final merchant = _extractMerchantFromMessage(message);
      return SMSTransaction(
        id: id,
        sender: sender,
        message: message,
        timestamp: timestamp,
        type: TransactionType.debit,
        amount: amount,
        merchant: merchant,
        category: categorizeMerchant(merchant),
        accountNumber: accountNumber,
        isProcessed: true,
      );
    }
    
    // 2. Check for Indian Bank credit transactions
    final bankCreditMatch = bankCreditPattern.firstMatch(message);
    if (bankCreditMatch != null) {
      final amount = _extractAmount(bankCreditMatch.group(1)!);
      final accountNumber = bankCreditMatch.group(2);
      final merchant = _extractMerchantFromMessage(message);
      return SMSTransaction(
        id: id,
        sender: sender,
        message: message,
        timestamp: timestamp,
        type: TransactionType.credit,
        amount: amount,
        merchant: merchant,
        category: categorizeMerchant(merchant),
        accountNumber: accountNumber,
        isProcessed: true,
      );
    }
    
    // 3. Check for alternative bank debit patterns
    final bankDebitMatch2 = bankDebitPattern2.firstMatch(message);
    if (bankDebitMatch2 != null && !message.toLowerCase().contains('credited')) {
      final amount = _extractAmount(bankDebitMatch2.group(1)!);
      final merchant = _extractMerchantFromMessage(message);
      return SMSTransaction(
        id: id,
        sender: sender,
        message: message,
        timestamp: timestamp,
        type: TransactionType.debit,
        amount: amount,
        merchant: merchant,
        category: categorizeMerchant(merchant),
        isProcessed: true,
      );
    }
    
    // 4. Check for alternative bank credit patterns
    final bankCreditMatch2 = bankCreditPattern2.firstMatch(message);
    if (bankCreditMatch2 != null && message.toLowerCase().contains('credited')) {
      final amount = _extractAmount(bankCreditMatch2.group(1)!);
      final merchant = _extractMerchantFromMessage(message);
      return SMSTransaction(
        id: id,
        sender: sender,
        message: message,
        timestamp: timestamp,
        type: TransactionType.credit,
        amount: amount,
        merchant: merchant,
        category: categorizeMerchant(merchant),
        isProcessed: true,
      );
    }
    
    // 5. Check for UPI transactions (enhanced)
    final upiDebitMatch = upiDebitPattern.firstMatch(message);
    if (upiDebitMatch != null) {
      final amount = _extractAmount(upiDebitMatch.group(1)!);
      final merchant = upiDebitMatch.group(2)!.trim();
      return SMSTransaction(
        id: id,
        sender: sender,
        message: message,
        timestamp: timestamp,
        type: TransactionType.debit,
        amount: amount,
        merchant: merchant.isNotEmpty ? merchant : 'UPI Payment',
        category: categorizeMerchant(merchant.isNotEmpty ? merchant : 'UPI Payment'),
        isUPI: true,
        isProcessed: true,
      );
    }
    
    final upiCreditMatch = upiCreditPattern.firstMatch(message);
    if (upiCreditMatch != null) {
      final amount = _extractAmount(upiCreditMatch.group(1)!);
      final merchant = upiCreditMatch.group(2)!.trim();
      return SMSTransaction(
        id: id,
        sender: sender,
        message: message,
        timestamp: timestamp,
        type: TransactionType.credit,
        amount: amount,
        merchant: merchant.isNotEmpty ? merchant : 'UPI Payment',
        category: categorizeMerchant(merchant.isNotEmpty ? merchant : 'UPI Credit'),
        isUPI: true,
        isProcessed: true,
      );
    }
    
    // Check for additional UPI patterns
    final upiMatch1 = upiPattern1.firstMatch(message);
    if (upiMatch1 != null) {
      final amount = _extractAmount(upiMatch1.group(1)!);
      final merchant = _extractMerchantFromMessage(message);
      return SMSTransaction(
        id: id,
        sender: sender,
        message: message,
        timestamp: timestamp,
        type: TransactionType.debit,
        amount: amount,
        merchant: merchant,
        category: categorizeMerchant(merchant),
        isUPI: true,
        isProcessed: true,
      );
    }
    
    final upiMatch2 = upiPattern2.firstMatch(message);
    if (upiMatch2 != null) {
      final amount = _extractAmount(upiMatch2.group(1)!);
      final merchant = _extractMerchantFromMessage(message);
      return SMSTransaction(
        id: id,
        sender: sender,
        message: message,
        timestamp: timestamp,
        type: TransactionType.debit,
        amount: amount,
        merchant: merchant,
        category: categorizeMerchant(merchant),
        isUPI: true,
        isProcessed: true,
      );
    }
    
    // 6. Check for credit card statements
    final cardMatch = cardStatementPattern.firstMatch(message);
    if (cardMatch != null) {
      final amount = _extractAmount(cardMatch.group(1)!);
      return SMSTransaction(
        id: id,
        sender: sender,
        message: message,
        timestamp: timestamp,
        type: TransactionType.statement,
        amount: amount,
        isCreditCard: true,
        isOverdue: message.toLowerCase().contains('overdue'),
        isLateFee: message.toLowerCase().contains('late fee'),
        isProcessed: true,
      );
    }
    
    // 7. Check for EMI payments
    final emiMatch = emiPaymentPattern.firstMatch(message);
    if (emiMatch != null) {
      final amount = _extractAmount(emiMatch.group(1)!);
      return SMSTransaction(
        id: id,
        sender: sender,
        message: message,
        timestamp: timestamp,
        type: TransactionType.emi,
        amount: amount,
        isEMI: true,
        isOverdue: message.toLowerCase().contains('overdue'),
        isProcessed: true,
      );
    }
    
    // 8. Check for salary credits
    final salaryMatch = salaryPattern.firstMatch(message);
    if (salaryMatch != null) {
      final amount = _extractAmount(salaryMatch.group(1)!);
      return SMSTransaction(
        id: id,
        sender: sender,
        message: message,
        timestamp: timestamp,
        type: TransactionType.salary,
        amount: amount,
        isSalary: true,
        isProcessed: true,
      );
    }
    
    // 9. Check for autopay transactions
    final autopayMatch = autopayPattern.firstMatch(message);
    if (autopayMatch != null) {
      final amount = _extractAmount(autopayMatch.group(1)!);
      return SMSTransaction(
        id: id,
        sender: sender,
        message: message,
        timestamp: timestamp,
        type: TransactionType.autopay,
        amount: amount,
        isAutopay: true,
        isProcessed: true,
      );
    }
    
    // 10. Check for balance alerts
    final balanceMatch = balanceAlertPattern.firstMatch(message);
    if (balanceMatch != null) {
      return SMSTransaction(
        id: id,
        sender: sender,
        message: message,
        timestamp: timestamp,
        type: TransactionType.balance,
        isBalanceAlert: true,
        isProcessed: true,
      );
    }
    
    return null; // If no pattern matches
  }
  
  static String _extractMerchantFromMessage(String message) {
    // Try to extract merchant from common patterns in Indian bank SMS
    final lowerMessage = message.toLowerCase();
    
    // Check for common merchants
    for (final entry in merchantCategories.entries) {
      if (lowerMessage.contains(entry.key)) {
        return entry.key.toUpperCase();
      }
    }
    
    // Try to extract from sender (bank codes)
    if (message.contains('INDBNK')) return 'INDIAN BANK';
    if (message.contains('AXISBK')) return 'AXIS BANK';
    if (message.contains('HDFCBK')) return 'HDFC BANK';
    if (message.contains('SBIUPI')) return 'SBI';
    if (message.contains('AIRBIL')) return 'AIR INDIA';
    if (message.contains('AIRINF')) return 'AIR INDIA';
    if (message.contains('IRSMSA')) return 'IRCTC';
    if (message.contains('ICICIB')) return 'ICICI BANK';
    if (message.contains('KOTAKB')) return 'KOTAK BANK';
    if (message.contains('YESBNK')) return 'YES BANK';
    if (message.contains('PNBBANK')) return 'PNB';
    if (message.contains('CANARA')) return 'CANARA BANK';
    if (message.contains('UNIONBNK')) return 'UNION BANK';
    
    // Try to extract from common merchant patterns
    if (lowerMessage.contains('swiggy')) return 'SWIGGY';
    if (lowerMessage.contains('zomato')) return 'ZOMATO';
    if (lowerMessage.contains('zepto')) return 'ZEPTO';
    if (lowerMessage.contains('blinkit')) return 'BLINKIT';
    if (lowerMessage.contains('dunzo')) return 'DUNZO';
    if (lowerMessage.contains('uber')) return 'UBER';
    if (lowerMessage.contains('ola')) return 'OLA';
    if (lowerMessage.contains('netflix')) return 'NETFLIX';
    if (message.contains('amazon prime')) return 'AMAZON PRIME';
    if (lowerMessage.contains('hotstar')) return 'HOTSTAR';
    if (lowerMessage.contains('bookmyshow')) return 'BOOKMYSHOW';
    if (lowerMessage.contains('pharmeasy')) return 'PHARMEASY';
    if (lowerMessage.contains('1mg')) return '1MG';
    if (lowerMessage.contains('byjus')) return 'BYJUS';
    if (lowerMessage.contains('unacademy')) return 'UNACADEMY';
    
    // Enhanced fallback logic for better merchant names
    if (lowerMessage.contains('upi') || lowerMessage.contains('paytm') || lowerMessage.contains('phonepe')) {
      return 'UPI Payment';
    }
    if (lowerMessage.contains('atm') || lowerMessage.contains('cash withdrawal')) {
      return 'ATM Withdrawal';
    }
    if (lowerMessage.contains('pos') || lowerMessage.contains('card payment')) {
      return 'Card Payment';
    }
    if (lowerMessage.contains('online') || lowerMessage.contains('internet banking')) {
      return 'Online Payment';
    }
    if (lowerMessage.contains('transfer') || lowerMessage.contains('neft') || lowerMessage.contains('imps')) {
      return 'Bank Transfer';
    }
    
    // Check for specific transaction types and provide better defaults
    if (lowerMessage.contains('debited') || lowerMessage.contains('charged')) {
      // For debit transactions, try to identify the type
      if (lowerMessage.contains('account') || lowerMessage.contains('a/c')) {
        return 'Bank Debit';
      }
      if (lowerMessage.contains('card') || lowerMessage.contains('credit card')) {
        return 'Card Payment';
      }
      // Default for most debit transactions is UPI
      return 'UPI Payment';
    }
    
    if (lowerMessage.contains('credited') || lowerMessage.contains('received')) {
      // For credit transactions
      if (lowerMessage.contains('salary') || lowerMessage.contains('credited salary')) {
        return 'Salary Credit';
      }
      if (lowerMessage.contains('refund') || lowerMessage.contains('reversed')) {
        return 'Refund';
      }
      return 'Bank Credit';
    }
    
    // Final fallback - analyze the message structure
    if (lowerMessage.contains('rs.') || lowerMessage.contains('inr')) {
      // If it has amount but no clear merchant, it's likely a UPI transaction
      return 'UPI Payment';
    }
    
    return 'General Payment';
  }
  
  static String categorizeMerchant(String merchant) {
    final lowerMerchant = merchant.toLowerCase();
    
    for (final entry in merchantCategories.entries) {
      if (lowerMerchant.contains(entry.key)) {
        return entry.value;
      }
    }
    
    // Additional categorization logic
    if (lowerMerchant.contains('bank')) return 'Banking';
    if (lowerMerchant.contains('atm')) return 'Banking';
    if (lowerMerchant.contains('pos')) return 'Shopping';
    if (lowerMerchant.contains('online')) return 'Shopping';
    if (lowerMerchant.contains('payment')) return 'General';
    if (lowerMerchant.contains('transaction')) return 'General';
    
    return 'General';
  }
  
  static double _extractAmount(String amountStr) {
    // Remove commas and convert to double
    final cleanAmount = amountStr.replaceAll(',', '');
    return double.tryParse(cleanAmount) ?? 0.0;
  }
}
