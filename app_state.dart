import 'package:flutter/material.dart';
import 'transaction_model.dart';  
import 'budget_category.dart';  

class AppState extends ChangeNotifier {
  List<Transaction> _transactions = [];
  List<BudgetCategory> _categories = [
    BudgetCategory(name: 'Groceries', icon: Icons.shopping_cart),
    BudgetCategory(name: 'Restaurants', icon: Icons.fastfood),
    BudgetCategory(name: 'Home', icon: Icons.home),  
    BudgetCategory(name: 'Gas', icon: Icons.local_gas_station),
    BudgetCategory(name: 'Entertainment', icon: Icons.movie),
    BudgetCategory(name: 'Clothing', icon: Icons.checkroom),
  ];
  double _income = 0.0;

  void Function()? onUpdate;

  List<Transaction> get transactions => List.unmodifiable(_transactions);
  List<BudgetCategory> get categories => List.unmodifiable(_categories);
  double get income => _income;

  void setIncome(double income) {
    _income = income;
    notifyListeners();
  }

  void addTransaction(Transaction transaction) {
    _transactions.add(transaction);
    notifyListeners();
    onUpdate?.call();
  }

  void allocateBudget(String category, double amount) {
    for (var cat in _categories) {
      if (cat.name == category) {
        cat.allocatedAmount = amount;
        notifyListeners();
        break;
      }
    }
  }

  double calculateTotal() {
    return _transactions.fold(0.0, (sum, item) => sum + item.amount);
  }
}
