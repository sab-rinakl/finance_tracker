import 'package:flutter/material.dart';
import '../app_state.dart';
import '../budget_category.dart';

class OverviewScreen extends StatelessWidget {
  final AppState appState;

  OverviewScreen({required this.appState});

  double getTotalSpent() {
    return appState.transactions.fold(0, (sum, transaction) => sum + transaction.amount);
  }

  Map<String, double> getSpentPerCategory() {
    Map<String, double> categorySpending = {};

    for (var category in appState.categories) {
      categorySpending[category.name] = 0.0;
    }

    for (var transaction in appState.transactions) {
      String categoryName = appState.categories.firstWhere(
              (cat) => cat.icon == transaction.icon,
          orElse: () => BudgetCategory(name: "Other", icon: Icons.blur_on)  
      ).name;

      if (categorySpending.containsKey(categoryName)) {
        categorySpending[categoryName] = categorySpending[categoryName]! + transaction.amount;
      } else {
        categorySpending[categoryName] = transaction.amount;
      }
    }

    return categorySpending;
  }


  @override
  Widget build(BuildContext context) {
    double totalSpent = getTotalSpent();
    Map<String, double> spentPerCategory = getSpentPerCategory();
    double totalIncome = appState.income;

    return Scaffold(
      appBar: AppBar(
        title: Text('Overview'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Total Spent: \$${totalSpent.toStringAsFixed(2)} / \$${totalIncome.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 20,
                  color: totalSpent > totalIncome ? Colors.red : Colors.black,
                ),
              ),
            ),
            ...appState.categories.map((category) {
              double spent = spentPerCategory[category.name] ?? 0.0;
              return ListTile(
                title: Text('${category.name}'),
                subtitle: Text(
                  '\$${spent.toStringAsFixed(2)} / \$${category.allocatedAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: spent > category.allocatedAmount ? Colors.red : Colors.black,
                  ),
                ),
                trailing: Icon(category.icon),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}