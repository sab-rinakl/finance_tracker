import 'package:flutter/material.dart';
import '../app_state.dart';
import '../transaction_model.dart';

class TransactionsScreen extends StatefulWidget {
  final AppState appState;

  TransactionsScreen({required this.appState});

  @override
  _TransactionsScreenState createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  IconData? selectedIcon = Icons.shopping_cart; // Default icon

  @override
  void initState() {
    super.initState();
    widget.appState.onUpdate = () => setState(() {});
  }

  @override
  void dispose() {
    widget.appState.onUpdate = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _amountController,
              decoration: InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<IconData>(
              value: selectedIcon,
              onChanged: (IconData? newValue) {
                setState(() {
                  selectedIcon = newValue;
                });
              },
              items: <IconData>[
                Icons.shopping_cart, // Groceries
                Icons.fastfood,      // Restaurants
                Icons.home,          // Home
                Icons.local_gas_station, // Gas
                Icons.movie,         // Entertainment
                Icons.checkroom      // Clothing
              ].map<DropdownMenuItem<IconData>>((IconData value) {
                return DropdownMenuItem<IconData>(
                  value: value,
                  child: Icon(value),
                );
              }).toList(),
              isExpanded: true,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final transaction = Transaction(
                id: DateTime.now().toString(),
                title: _titleController.text,
                amount: double.parse(_amountController.text),
                date: DateTime.now(),
                icon: selectedIcon!,
              );
              widget.appState.addTransaction(transaction);
              _titleController.clear();
              _amountController.clear();
            },
            child: Text('Add Transaction'),
          ),
          Expanded(
            child: ListView(
              children: widget.appState.transactions.map((transaction) => ListTile(
                leading: Icon(transaction.icon),
                title: Text(transaction.title),
                subtitle: Text('${transaction.date.toIso8601String()}'),
                trailing: Text('\$${transaction.amount.toStringAsFixed(2)}'),
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
