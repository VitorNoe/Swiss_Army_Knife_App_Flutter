import 'package:flutter/material.dart';

class UnitConverterScreen extends StatefulWidget {
  @override
  _UnitConverterScreenState createState() => _UnitConverterScreenState();
}

class _UnitConverterScreenState extends State<UnitConverterScreen> {
  String selectedCategory = 'Length';
  String fromUnit = 'Meter';
  String toUnit = 'Kilometer';
  TextEditingController inputController = TextEditingController();
  double result = 0.0;

  final Map<String, Map<String, double>> conversionData = {
    'Length': {
      'Meter': 1.0,
      'Kilometer': 0.001,
      'Centimeter': 100.0,
      'Millimeter': 1000.0,
      'Inch': 39.3701,
      'Foot': 3.28084,
      'Yard': 1.09361,
      'Mile': 0.000621371,
    },
    'Weight': {
      'Kilogram': 1.0,
      'Gram': 1000.0,
      'Pound': 2.20462,
      'Ounce': 35.274,
      'Ton': 0.001,
    },
    'Temperature': {
      'Celsius': 1.0,
      'Fahrenheit': 1.0,
      'Kelvin': 1.0,
    },
    'Volume': {
      'Liter': 1.0,
      'Milliliter': 1000.0,
      'Gallon': 0.264172,
      'Quart': 1.05669,
      'Pint': 2.11338,
      'Cup': 4.22675,
    },
  };

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Unit Converter',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Convert between different units of measurement',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 24),
          
          // Category Selection
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Category',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: conversionData.keys.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value!;
                        fromUnit = conversionData[selectedCategory]!.keys.first;
                        toUnit = conversionData[selectedCategory]!.keys.skip(1).first;
                        _performConversion();
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          
          // Input Section
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
                            hintText: 'Enter value',
                          ),
                          onChanged: (value) => _performConversion(),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: fromUnit,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          items: conversionData[selectedCategory]!.keys.map((unit) {
                            return DropdownMenuItem(
                              value: unit,
                              child: Text(unit),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              fromUnit = value!;
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
          
          // Swap Button
          Center(
            child: IconButton(
              onPressed: () {
                setState(() {
                  String temp = fromUnit;
                  fromUnit = toUnit;
                  toUnit = temp;
                  _performConversion();
                });
              },
              icon: Icon(Icons.swap_vert, size: 32),
              color: Colors.red[700],
            ),
          ),
          
          // Result Section
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
                            result.toStringAsFixed(6),
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
                          value: toUnit,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          items: conversionData[selectedCategory]!.keys.map((unit) {
                            return DropdownMenuItem(
                              value: unit,
                              child: Text(unit),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              toUnit = value!;
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

  void _performConversion() {
    if (inputController.text.isEmpty) {
      setState(() {
        result = 0.0;
      });
      return;
    }

    double inputValue = double.tryParse(inputController.text) ?? 0.0;
    
    if (selectedCategory == 'Temperature') {
      result = _convertTemperature(inputValue, fromUnit, toUnit);
    } else {
      double fromMultiplier = conversionData[selectedCategory]![fromUnit]!;
      double toMultiplier = conversionData[selectedCategory]![toUnit]!;
      result = (inputValue / fromMultiplier) * toMultiplier;
    }
    
    setState(() {});
  }

  double _convertTemperature(double value, String from, String to) {
    // Convert to Celsius first
    double celsius;
    switch (from) {
      case 'Celsius':
        celsius = value;
        break;
      case 'Fahrenheit':
        celsius = (value - 32) * 5 / 9;
        break;
      case 'Kelvin':
        celsius = value - 273.15;
        break;
      default:
        celsius = value;
    }
    
    // Convert from Celsius to target
    switch (to) {
      case 'Celsius':
        return celsius;
      case 'Fahrenheit':
        return celsius * 9 / 5 + 32;
      case 'Kelvin':
        return celsius + 273.15;
      default:
        return celsius;
    }
  }
}


