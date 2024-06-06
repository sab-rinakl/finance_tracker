import 'package:flutter/material.dart';
import '../app_state.dart';
import '../budget_category.dart';  

class BudgetingScreen extends StatefulWidget {
  final AppState appState;

  BudgetingScreen({required this.appState});

  @override
  _BudgetingScreenState createState() => _BudgetingScreenState();
}

class _BudgetingScreenState extends State<BudgetingScreen> {
  final TextEditingController _incomeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize controller with current income
    _incomeController.text = widget.appState.income.toStringAsFixed(2);
  }

  double getRemainingIncome() {
    double allocated = widget.appState.categories.fold(0.0, (sum, cat) => sum + cat.allocatedAmount);
    return widget.appState.income - allocated;
  }

  @override
  Widget build(BuildContext context) {
    double remainingIncome = getRemainingIncome(); 
    return Scaffold(
      appBar: AppBar(
        title: Text('Budgeting'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _incomeController,
                decoration: InputDecoration(
                  labelText: 'Total Income',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.check),
                    onPressed: () {
                      final income = double.parse(_incomeController.text);
                      widget.appState.setIncome(income);
                      setState(() {}); // Ensure screen updates
                    },
                  ),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total Income: \$${widget.appState.income.toStringAsFixed(2)}', style: Theme.of(context).textTheme.subtitle1),
                  Text('Remaining: \$${remainingIncome.toStringAsFixed(2)}',
                    style: TextStyle(
                        color: remainingIncome < 0 ? Colors.red : Colors.black,  
                        fontSize: 16
                    ),
                  ),
                ],
              ),
            ),
            ...widget.appState.categories.map((category) {
              return ListTile(
                leading: Icon(category.icon),
                title: Text(category.name),
                trailing: Text('\$${category.allocatedAmount.toStringAsFixed(2)}'),
                onTap: () {
                  _showAllocationDialog(category);
                },
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  void _showAllocationDialog(BudgetCategory category) {
    final _controller = TextEditingController();
    _controller.text = category.allocatedAmount.toStringAsFixed(2);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Allocate Budget for ${category.name}'),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(labelText: 'Amount'),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                final amount = double.parse(_controller.text);
                widget.appState.allocateBudget(category.name, amount);
                Navigator.of(context).pop();
                setState(() {}); 
              },
            ),
          ],
        );
      },
    );
  }
}
