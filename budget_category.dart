import 'package:flutter/cupertino.dart';

class BudgetCategory {
  final String name;
  final IconData icon;
  double allocatedAmount;

  BudgetCategory({
    required this.name,
    required this.icon,
    this.allocatedAmount = 0.0,
  });
}