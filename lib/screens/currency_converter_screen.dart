import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CurrencyConverterScreen extends StatefulWidget {
  @override
  _CurrencyConverterScreenState createState() => _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState extends State<CurrencyConverterScreen> {
  String fromCurrency = 'USD';
  String toCurrency = 'BRL';
  TextEditingController inputController = TextEditingController();
  String result = '';
  List<String> currencies = ['USD', 'EUR', 'GBP', 'JPY', 'BRL', 'CAD', 'AUD', 'CHF', 'CNY', 'SEK', 'NZD']; // Example list

  @override
  void initState() {
    super.initState();
    _fetchCurrencies();
  }

  Future<void> _fetchCurrencies() async {
    // In a real app, you would fetch a comprehensive list of currencies from an API
    // For this example, we'll use a predefined list.
    // Example API: https://api.exchangerate-api.com/v4/latest/USD
    // You would parse the 'rates' key to get all available currencies.
  }

  Future<void> _performConversion() async {
    if (inputController.text.isEmpty) {
      setState(() {
        result = '';
      });
      return;
    }

    double inputValue = double.tryParse(inputController.text) ?? 0.0;

    // Using a free API for exchange rates. Replace with your API key if needed.
    // For simplicity, this example uses a fixed base currency (USD) for fetching rates.
    // A more robust solution would allow dynamic base currency or use a more advanced API.
    final String apiUrl = 'https://api.exchangerate-api.com/v4/latest/$fromCurrency';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['rates'] != null && data['rates'][toCurrency] != null) {
          double rate = data['rates'][toCurrency];
          double convertedValue = inputValue * rate;
          setState(() {
            result = '${convertedValue.toStringAsFixed(2)} $toCurrency';
          });
        } else {
          setState(() {
            result = 'Error: Invalid currency or rate not found.';
          });
        }
      } else {
        setState(() {
          result = 'Error fetching rates: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        result = 'Error: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Currency Converter',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Convert between different currencies using real-time rates',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 24),
          
          // From Currency
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'From',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: inputController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter amount',
                          ),
                          onChanged: (value) => _performConversion(),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: fromCurrency,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          items: currencies.map((currency) {
                            return DropdownMenuItem(
                              value: currency,
                              child: Text(currency),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              fromCurrency = value!;
                              _performConversion();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          
          // To Currency
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'To',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[400]!),
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.grey[100],
                          ),
                          child: Text(
                            result.isEmpty ? '0.00' : result,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: toCurrency,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          items: currencies.map((currency) {
                            return DropdownMenuItem(
                              value: currency,
                              child: Text(currency),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              toCurrency = value!;
                              _performConversion();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


