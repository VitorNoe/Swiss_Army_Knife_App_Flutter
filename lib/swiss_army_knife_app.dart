import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'screens/home_screen.dart';
import 'screens/unit_converter_screen.dart';
import 'screens/measurement_converter_screen.dart';
import 'screens/text_tools_screen.dart';
import 'screens/calculator_screen.dart';
import 'screens/password_generator_screen.dart';
import 'screens/currency_converter_screen.dart';
import 'screens/datetime_tools_screen.dart';

class SwissArmyKnifeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swiss Army Knife',
      theme: ThemeData(
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Colors.grey[50],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.red[700],
          foregroundColor: Colors.white,
          elevation: 2,
        ),
      ),
      home: MainNavigationScreen(),
      routes: {
        '/home': (context) => HomeScreen(),
        '/unit-converter': (context) => UnitConverterScreen(),
        '/measurement-converter': (context) => MeasurementConverterScreen(),
        '/text-tools': (context) => TextToolsScreen(),
        '/calculator': (context) => CalculatorScreen(),
        '/password-generator': (context) => PasswordGeneratorScreen(),
        '/currency-converter': (context) => CurrencyConverterScreen(),
        '/datetime-tools': (context) => DateTimeToolsScreen(),
      },
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  @override
  _MainNavigationScreenState createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    UnitConverterScreen(),
    MeasurementConverterScreen(),
    TextToolsScreen(),
    CalculatorScreen(),
    PasswordGeneratorScreen(),
    CurrencyConverterScreen(),
    DateTimeToolsScreen(),
  ];

  final List<String> _titles = [
    'Swiss Army Knife',
    'Unit Converter',
    'Measurement Converter',
    'Text Tools',
    'Calculator',
    'Password Generator',
    'Currency Converter',
    'Date & Time Tools',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        centerTitle: true,
      ),
      drawer: _buildDrawer(),
      body: _screens[_selectedIndex],
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.red[700],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.build,
                  size: 48,
                  color: Colors.white,
                ),
                SizedBox(height: 8),
                Text(
                  'Swiss Army Knife',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Multi-purpose utility app',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          _buildDrawerItem(0, Icons.home, 'Home'),
          _buildDrawerItem(1, Icons.swap_horiz, 'Unit Converter'),
          _buildDrawerItem(2, Icons.straighten, 'Measurement Converter'),
          _buildDrawerItem(3, Icons.text_fields, 'Text Tools'),
          _buildDrawerItem(4, Icons.calculate, 'Calculator'),
          _buildDrawerItem(5, Icons.lock, 'Password Generator'),
          _buildDrawerItem(6, Icons.monetization_on, 'Currency Converter'),
          _buildDrawerItem(7, Icons.access_time, 'Date & Time Tools'),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(int index, IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: _selectedIndex == index ? Colors.red : null),
      title: Text(
        title,
        style: TextStyle(
          color: _selectedIndex == index ? Colors.red : null,
          fontWeight: _selectedIndex == index ? FontWeight.bold : null,
        ),
      ),
      selected: _selectedIndex == index,
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
        Navigator.pop(context);
      },
    );
  }
}

