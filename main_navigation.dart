import 'package:flutter/material.dart';
import 'app_state.dart';
import 'screens/overview_screen.dart';
import 'screens/transactions_screen.dart';
import 'screens/budgeting_screen.dart';

class MainNavigation extends StatefulWidget {
  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;  // Current index of the selected tab
  late List<Widget> _pages;
  late AppState appState;

  @override
  void initState() {
    super.initState();
    appState = AppState();  // Initialize AppState
    _pages = [
      OverviewScreen(appState: appState),
      BudgetingScreen(appState: appState),
      TransactionsScreen(appState: appState),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Finance Tracker'),  
        backgroundColor: Colors.blue, 
      ),
      body: _pages[_selectedIndex],  // Display the current screen based on _selectedIndex
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Overview',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: 'Budgeting',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Transactions',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      backgroundColor: Color(0xFFF3E5F5), 
    );
  }
}
