import 'package:flutter/material.dart';
import '../services/mock_service.dart';
import '../services/sms_parser_service.dart';
import '../services/sms_permission_service.dart';
import '../services/database_service.dart';
import '../models/transaction.dart';
import '../models/budget.dart';
import '../models/sms_transaction.dart';
import '../models/financial_aggregates.dart';
import 'dart:async';

class FinanceProvider extends ChangeNotifier {
  final MockService service;

  FinanceProvider(this.service);

  List<TransactionModel> get transactions => service.transactions;
  List<BudgetModel> get budgets => service.budgets;
  
  // SMS-related properties
  List<SMSTransaction> smsTransactions = [];
  FinancialAggregates? aggregates;
  bool isProcessingSMS = false;
  bool hasSMSPermission = false;

  double get totalBalance {
    double income = 0;
    double expense = 0;
    for (var t in transactions) {
      if (t.isExpense) expense += t.amount;
      else income += t.amount;
    }
    return income - expense + 45230; // mock baseline balance to match prototype feel
  }

  double get monthExpense {
    final now = DateTime.now();
    double total = 0;
    for (var t in transactions) {
      if (t.isExpense && t.date.month == now.month && t.date.year == now.year) {
        total += t.amount;
      }
    }
    return total;
  }

  int get creditScore {
    // Mock credit score logic (composite)
    final base = 650;
    final timelyPayment = 95; // %
    final utilizationPenalty = 20; // mock
    final score = (base + (timelyPayment * 0.5).round() - utilizationPenalty).clamp(300, 850).toInt();
    return score;
  }

  void addTransaction(TransactionModel t) {
    service.transactions.insert(0, t);
    notifyListeners();
  }

  // SMS Processing Methods
  Future<void> initializeSMSData() async {
    print('🔄 Initializing SMS data...');
    try {
      // Load existing SMS transactions from database
      smsTransactions = await DatabaseService.getSMSTransactions();
      print('📊 Loaded ${smsTransactions.length} existing SMS transactions');
      
      // Compute aggregates
      await computeAggregates();
      
      // Check SMS permission
      await checkSMSPermission();
      
      // Always parse new SMS on startup for ML/AI models
      print('🔄 Automatically parsing new SMS on startup...');
      await processSMSMessages();
      
      print('✅ SMS data initialization completed');
    } catch (e) {
      print('❌ Error initializing SMS data: $e');
    }
  }

  Future<void> checkSMSPermission() async {
    hasSMSPermission = await SMSPermissionService.hasSMSPermission();
    notifyListeners();
  }

  Future<void> requestSMSPermission() async {
    hasSMSPermission = await SMSPermissionService.requestSMSPermission();
    notifyListeners();
  }

  Future<void> processSMSMessages() async {
    print('🔄 Starting SMS processing...');
    
    setState(() {
      isProcessingSMS = true;
    });

    try {
      print('📱 Reading SMS messages...');
      // Read SMS messages
      final smsMessages = await SMSPermissionService.readSMSMessages(limit: 100);
      print('📊 Read ${smsMessages.length} SMS messages');
      
      // Parse each SMS
      final parsedTransactions = <SMSTransaction>[];
      print('🔍 Parsing SMS messages...');
      
      for (final sms in smsMessages) {
        final parsed = SMSParserService.parseSMS(
          sms.address,
          sms.body,
          sms.date,
        );
        
        if (parsed != null) {
          parsedTransactions.add(parsed);
          print('✅ Parsed transaction: ${parsed.type} - ${parsed.amount} - ${parsed.merchant}');
        } else {
          print('❌ Failed to parse SMS: ${sms.address} - ${sms.body.substring(0, sms.body.length > 30 ? 30 : sms.body.length)}...');
        }
      }

      print('💾 Storing ${parsedTransactions.length} transactions in database...');

      // Store in database
      for (final transaction in parsedTransactions) {
        await DatabaseService.insertSMSTransaction(transaction);
      }

      print('📊 Updating local transaction list...');
      // Update local list
      smsTransactions = await DatabaseService.getSMSTransactions();
      print('📈 Total transactions in database: ${smsTransactions.length}');
      
      print('🧮 Computing aggregates...');
      // Compute aggregates
      await computeAggregates();
      
      print('✅ SMS processing completed successfully');
      
    } catch (e) {
      print('❌ Error processing SMS messages: $e');
    } finally {
      setState(() {
        isProcessingSMS = false;
      });
      print('🔄 SMS processing finished');
    }
  }

  Future<void> computeAggregates() async {
    if (smsTransactions.isEmpty) {
      aggregates = FinancialAggregates(
        upiTxnCount7d: 0,
        upiTxnCount30d: 0,
        upiTxnCount90d: 0,
        upiSpend7d: 0,
        upiSpend30d: 0,
        upiSpend90d: 0,
        avgTxnAmount: 0,
        txnVariance: 0,
        categorySpend30d: {},
        categoryCount30d: {},
        cardMinDueRate90d: 0,
        lateFeeFlag90d: false,
        billPaidOnTimeRate90d: 0,
        creditUtilizationApprox: 0,
        emiPayments90d: 0,
        emiOverdue90d: 0,
        emiBouncedFlag: false,
        salaryDetected: false,
        autopayUsage30d: 0,
        autopayMerchants: [],
        balanceAlerts30d: 0,
        lowBalanceFlag: false,
        merchantDiversity30d: 0,
        topMerchants: [],
      );
      notifyListeners();
      return;
    }

    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(Duration(days: 7));
    final thirtyDaysAgo = now.subtract(Duration(days: 30));
    final ninetyDaysAgo = now.subtract(Duration(days: 90));

    // Filter transactions by date
    final upiTransactions7d = smsTransactions.where((t) => 
      t.isUPI && t.timestamp.isAfter(sevenDaysAgo)).toList();
    final upiTransactions30d = smsTransactions.where((t) => 
      t.isUPI && t.timestamp.isAfter(thirtyDaysAgo)).toList();
    final upiTransactions90d = smsTransactions.where((t) => 
      t.isUPI && t.timestamp.isAfter(ninetyDaysAgo)).toList();

    // Calculate UPI metrics
    final upiSpend7d = _calculateTotalSpend(upiTransactions7d);
    final upiSpend30d = _calculateTotalSpend(upiTransactions30d);
    final upiSpend90d = _calculateTotalSpend(upiTransactions90d);

    // Calculate category metrics
    final categorySpend30d = <String, double>{};
    final categoryCount30d = <String, int>{};
    
    for (final t in smsTransactions.where((t) => t.timestamp.isAfter(thirtyDaysAgo))) {
      if (t.category != null && t.amount != null) {
        categorySpend30d[t.category!] = (categorySpend30d[t.category!] ?? 0) + t.amount!;
        categoryCount30d[t.category!] = (categoryCount30d[t.category!] ?? 0) + 1;
      }
    }

    // Calculate other metrics
    final avgTxnAmount = _calculateAverageAmount(smsTransactions);
    final txnVariance = _calculateVariance(smsTransactions);
    
    final cardTransactions90d = smsTransactions.where((t) => 
      t.isCreditCard && t.timestamp.isAfter(ninetyDaysAgo)).toList();
    
    final emiTransactions90d = smsTransactions.where((t) => 
      t.isEMI && t.timestamp.isAfter(ninetyDaysAgo)).toList();

    aggregates = FinancialAggregates(
      upiTxnCount7d: upiTransactions7d.length,
      upiTxnCount30d: upiTransactions30d.length,
      upiTxnCount90d: upiTransactions90d.length,
      upiSpend7d: upiSpend7d,
      upiSpend30d: upiSpend30d,
      upiSpend90d: upiSpend90d,
      avgTxnAmount: avgTxnAmount,
      txnVariance: txnVariance,
      categorySpend30d: categorySpend30d,
      categoryCount30d: categoryCount30d,
      cardMinDueRate90d: _calculateMinDueRate(cardTransactions90d),
      lateFeeFlag90d: _hasLateFee(cardTransactions90d),
      billPaidOnTimeRate90d: _calculateOnTimeRate(cardTransactions90d),
      creditUtilizationApprox: _estimateCreditUtilization(cardTransactions90d),
      emiPayments90d: _countEMIPayments(emiTransactions90d),
      emiOverdue90d: _countEMIOverdue(emiTransactions90d),
      emiBouncedFlag: _hasEMIBounced(emiTransactions90d),
      salaryDetected: _hasSalary(smsTransactions),
      lastSalaryDate: _getLastSalaryDate(smsTransactions),
      autopayUsage30d: _countAutopayUsage(smsTransactions, thirtyDaysAgo),
      autopayMerchants: _getAutopayMerchants(smsTransactions),
      balanceAlerts30d: _countBalanceAlerts(smsTransactions, thirtyDaysAgo),
      lowBalanceFlag: _hasLowBalance(smsTransactions),
      merchantDiversity30d: _calculateMerchantDiversity(smsTransactions, thirtyDaysAgo),
      topMerchants: _getTopMerchants(smsTransactions, thirtyDaysAgo),
    );

    notifyListeners();
  }

  Future<void> refreshData() async {
    await checkSMSPermission();
    if (hasSMSPermission) {
      await processSMSMessages();
    }
  }

  // Real-time SMS monitoring
  Timer? _smsPollingTimer;
  bool _isMonitoringSMS = false;

  Future<void> startRealTimeMonitoring() async {
    if (_isMonitoringSMS) {
      print('⚠️ SMS monitoring already active');
      return;
    }

    print('🔄 Starting real-time SMS monitoring...');
    
    try {
      // First, parse any new SMS that arrived since last session
      print('🔄 Parsing new SMS on monitoring start...');
      await processSMSMessages();
      
      // Start listening to incoming SMS
      await SMSPermissionService.listenToIncomingSMS((smsMessage) {
        print('📨 Real-time SMS received: ${smsMessage.address} - ${smsMessage.body.substring(0, smsMessage.body.length > 30 ? 30 : smsMessage.body.length)}...');
        
        // Parse and store the new SMS
        final parsed = SMSParserService.parseSMS(
          smsMessage.address,
          smsMessage.body,
          smsMessage.date,
        );
        
        if (parsed != null) {
          _handleNewTransaction(parsed);
        }
      });

      // Start periodic polling as backup
      _smsPollingTimer = Timer.periodic(Duration(seconds: 30), (timer) async {
        await _checkForNewSMS();
      });

      _isMonitoringSMS = true;
      print('✅ Real-time SMS monitoring started');
      notifyListeners();
    } catch (e) {
      print('❌ Error starting real-time monitoring: $e');
    }
  }

  Future<void> stopRealTimeMonitoring() async {
    print('🛑 Stopping real-time SMS monitoring...');
    
    _smsPollingTimer?.cancel();
    _smsPollingTimer = null;
    
    await SMSPermissionService.stopListeningToSMS();
    
    _isMonitoringSMS = false;
    print('✅ Real-time SMS monitoring stopped');
    notifyListeners();
  }

  Future<void> _checkForNewSMS() async {
    try {
      print('🔍 Checking for new SMS...');
      
      // Get the latest SMS timestamp
      final latestTimestamp = smsTransactions.isNotEmpty 
          ? smsTransactions.map((t) => t.timestamp).reduce((a, b) => a.isAfter(b) ? a : b)
          : DateTime.now().subtract(Duration(days: 1));
      
      // Read SMS since the latest timestamp
      final newSMS = await SMSPermissionService.readSMSMessages(
        limit: 50,
        since: latestTimestamp,
      );
      
      if (newSMS.isNotEmpty) {
        print('📨 Found ${newSMS.length} new SMS messages');
        
        for (final sms in newSMS) {
          final parsed = SMSParserService.parseSMS(
            sms.address,
            sms.body,
            sms.date,
          );
          
          if (parsed != null) {
            _handleNewTransaction(parsed);
          }
        }
      }
    } catch (e) {
      print('❌ Error checking for new SMS: $e');
    }
  }

  void _handleNewTransaction(SMSTransaction transaction) async {
    print('💾 Storing new transaction: ${transaction.type} - ${transaction.amount} - ${transaction.merchant}');
    
    // Store in database
    await DatabaseService.insertSMSTransaction(transaction);
    
    // Update local list
    smsTransactions = await DatabaseService.getSMSTransactions();
    
    // Recompute aggregates
    await computeAggregates();
    
    print('✅ New transaction processed and stored');
    notifyListeners();
  }

  bool get isMonitoringSMS => _isMonitoringSMS;

  // Enhanced analytics methods for Phase 2
  Map<String, double> getSpendingByCategory() {
    final categorySpend = <String, double>{};
    
    for (final transaction in smsTransactions) {
      if (transaction.type == TransactionType.debit && transaction.amount != null && transaction.category != null) {
        categorySpend[transaction.category!] = (categorySpend[transaction.category!] ?? 0) + transaction.amount!;
      }
    }
    
    return categorySpend;
  }

  Map<String, int> getTransactionCountByCategory() {
    final categoryCount = <String, int>{};
    
    for (final transaction in smsTransactions) {
      if (transaction.category != null) {
        categoryCount[transaction.category!] = (categoryCount[transaction.category!] ?? 0) + 1;
      }
    }
    
    return categoryCount;
  }

  List<SMSTransaction> getRecentTransactions({int limit = 10}) {
    final sortedTransactions = List<SMSTransaction>.from(smsTransactions);
    sortedTransactions.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return sortedTransactions.take(limit).toList();
  }

  double getTotalSpend({int days = 30}) {
    final cutoffDate = DateTime.now().subtract(Duration(days: days));
    return smsTransactions
      .where((t) => t.type == TransactionType.debit && 
                    t.amount != null && 
                    t.timestamp.isAfter(cutoffDate))
      .fold(0.0, (sum, t) => sum + t.amount!);
  }

  double getTotalIncome({int days = 30}) {
    final cutoffDate = DateTime.now().subtract(Duration(days: days));
    return smsTransactions
      .where((t) => t.type == TransactionType.credit && 
                    t.amount != null && 
                    t.timestamp.isAfter(cutoffDate))
      .fold(0.0, (sum, t) => sum + t.amount!);
  }

  Map<String, double> getTopMerchants({int limit = 5}) {
    final merchantSpend = <String, double>{};
    
    for (final transaction in smsTransactions) {
      if (transaction.type == TransactionType.debit && 
          transaction.amount != null && 
          transaction.merchant != null) {
        merchantSpend[transaction.merchant!] = (merchantSpend[transaction.merchant!] ?? 0) + transaction.amount!;
      }
    }
    
    final sortedMerchants = merchantSpend.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return Map.fromEntries(sortedMerchants.take(limit));
  }

  void setState(VoidCallback fn) {
    fn();
    notifyListeners();
  }

  // Helper methods for aggregate calculations
  double _calculateTotalSpend(List<SMSTransaction> transactions) {
    return transactions
      .where((t) => t.type == TransactionType.debit && t.amount != null)
      .fold(0.0, (sum, t) => sum + t.amount!);
  }

  double _calculateAverageAmount(List<SMSTransaction> transactions) {
    final amounts = transactions
      .where((t) => t.amount != null)
      .map((t) => t.amount!)
      .toList();
    
    if (amounts.isEmpty) return 0.0;
    return amounts.reduce((a, b) => a + b) / amounts.length;
  }

  double _calculateVariance(List<SMSTransaction> transactions) {
    final amounts = transactions
      .where((t) => t.amount != null)
      .map((t) => t.amount!)
      .toList();
    
    if (amounts.isEmpty) return 0.0;
    
    final mean = amounts.reduce((a, b) => a + b) / amounts.length;
    final squaredDifferences = amounts.map((amount) => (amount - mean) * (amount - mean));
    return squaredDifferences.reduce((a, b) => a + b) / amounts.length;
  }

  double _calculateMinDueRate(List<SMSTransaction> transactions) {
    // Placeholder implementation
    return 0.0;
  }

  bool _hasLateFee(List<SMSTransaction> transactions) {
    return transactions.any((t) => t.isLateFee);
  }

  double _calculateOnTimeRate(List<SMSTransaction> transactions) {
    // Placeholder implementation
    return 0.0;
  }

  double _estimateCreditUtilization(List<SMSTransaction> transactions) {
    // Placeholder implementation
    return 0.0;
  }

  int _countEMIPayments(List<SMSTransaction> transactions) {
    return transactions.where((t) => t.isEMI && !t.isOverdue).length;
  }

  int _countEMIOverdue(List<SMSTransaction> transactions) {
    return transactions.where((t) => t.isEMI && t.isOverdue).length;
  }

  bool _hasEMIBounced(List<SMSTransaction> transactions) {
    // Placeholder implementation
    return false;
  }

  bool _hasSalary(List<SMSTransaction> transactions) {
    return transactions.any((t) => t.isSalary);
  }

  DateTime? _getLastSalaryDate(List<SMSTransaction> transactions) {
    final salaryTransactions = transactions.where((t) => t.isSalary).toList();
    if (salaryTransactions.isEmpty) return null;
    
    salaryTransactions.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return salaryTransactions.first.timestamp;
  }

  int _countAutopayUsage(List<SMSTransaction> transactions, DateTime since) {
    return transactions.where((t) => t.isAutopay && t.timestamp.isAfter(since)).length;
  }

  List<String> _getAutopayMerchants(List<SMSTransaction> transactions) {
    return transactions
      .where((t) => t.isAutopay && t.merchant != null)
      .map((t) => t.merchant!)
      .toSet()
      .toList();
  }

  int _countBalanceAlerts(List<SMSTransaction> transactions, DateTime since) {
    return transactions.where((t) => t.isBalanceAlert && t.timestamp.isAfter(since)).length;
  }

  bool _hasLowBalance(List<SMSTransaction> transactions) {
    return transactions.any((t) => t.isBalanceAlert);
  }

  int _calculateMerchantDiversity(List<SMSTransaction> transactions, DateTime since) {
    final merchants = transactions
      .where((t) => t.timestamp.isAfter(since) && t.merchant != null)
      .map((t) => t.merchant!)
      .toSet();
    return merchants.length;
  }

  List<String> _getTopMerchants(List<SMSTransaction> transactions, DateTime since) {
    final merchantCounts = <String, int>{};
    
    for (final t in transactions.where((t) => t.timestamp.isAfter(since) && t.merchant != null)) {
      merchantCounts[t.merchant!] = (merchantCounts[t.merchant!] ?? 0) + 1;
    }
    
    final sortedMerchants = merchantCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return sortedMerchants.take(5).map((e) => e.key).toList();
  }

  // Convert SMS transactions to TransactionModel for dashboard display
  List<TransactionModel> getRecentSMSTransactions({int limit = 6}) {
    final recentSMS = getRecentTransactions(limit: limit);
    
    return recentSMS.map((sms) => TransactionModel(
      id: sms.id,
      title: sms.merchant ?? 'Payment',
      category: sms.category ?? 'General',
      amount: sms.amount ?? 0.0,
      date: sms.timestamp,
      isExpense: sms.type == TransactionType.debit,
    )).toList();
  }
}
