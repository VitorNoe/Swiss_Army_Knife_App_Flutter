import 'package:flutter/material.dart';

class MeasurementConverterScreen extends StatefulWidget {
  @override
  _MeasurementConverterScreenState createState() => _MeasurementConverterScreenState();
}

class _MeasurementConverterScreenState extends State<MeasurementConverterScreen> {
  String selectedSystem = 'Imperial to Metric';
  String selectedMeasurement = 'Length';
  TextEditingController inputController = TextEditingController();
  String result = '';

  final Map<String, Map<String, Map<String, dynamic>>> conversionSystems = {
    'Imperial to Metric': {
      'Length': {
        'Inch to Centimeter': {'factor': 2.54, 'symbol': 'cm'},
        'Foot to Meter': {'factor': 0.3048, 'symbol': 'm'},
        'Yard to Meter': {'factor': 0.9144, 'symbol': 'm'},
        'Mile to Kilometer': {'factor': 1.60934, 'symbol': 'km'},
      },
      'Weight': {
        'Pound to Kilogram': {'factor': 0.453592, 'symbol': 'kg'},
        'Ounce to Gram': {'factor': 28.3495, 'symbol': 'g'},
        'Stone to Kilogram': {'factor': 6.35029, 'symbol': 'kg'},
      },
      'Volume': {
        'Gallon to Liter': {'factor': 3.78541, 'symbol': 'L'},
        'Quart to Liter': {'factor': 0.946353, 'symbol': 'L'},
        'Pint to Milliliter': {'factor': 473.176, 'symbol': 'ml'},
        'Fluid Ounce to Milliliter': {'factor': 29.5735, 'symbol': 'ml'},
      },
    },
    'Metric to Imperial': {
      'Length': {
        'Centimeter to Inch': {'factor': 0.393701, 'symbol': 'in'},
        'Meter to Foot': {'factor': 3.28084, 'symbol': 'ft'},
        'Meter to Yard': {'factor': 1.09361, 'symbol': 'yd'},
        'Kilometer to Mile': {'factor': 0.621371, 'symbol': 'mi'},
      },
      'Weight': {
        'Kilogram to Pound': {'factor': 2.20462, 'symbol': 'lb'},
        'Gram to Ounce': {'factor': 0.035274, 'symbol': 'oz'},
        'Kilogram to Stone': {'factor': 0.157473, 'symbol': 'st'},
      },
      'Volume': {
        'Liter to Gallon': {'factor': 0.264172, 'symbol': 'gal'},
        'Liter to Quart': {'factor': 1.05669, 'symbol': 'qt'},
        'Milliliter to Pint': {'factor': 0.00211338, 'symbol': 'pt'},
        'Milliliter to Fluid Ounce': {'factor': 0.033814, 'symbol': 'fl oz'},
      },
    },
  };

  String selectedConversion = 'Inch to Centimeter';

  @override
  void initState() {
    super.initState();
    _updateAvailableConversions();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Measurement Converter',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Convert between Imperial and Metric systems',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 24),
          
          // System Selection
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Conversion System',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: selectedSystem,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: conversionSystems.keys.map((system) {
                      return DropdownMenuItem(
                        value: system,
                        child: Text(system),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedSystem = value!;
                        selectedMeasurement = conversionSystems[selectedSystem]!.keys.first;
                        _updateAvailableConversions();
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          
          // Measurement Type Selection
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Measurement Type',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: selectedMeasurement,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: conversionSystems[selectedSystem]!.keys.map((measurement) {
                      return DropdownMenuItem(
                        value: measurement,
                        child: Text(measurement),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedMeasurement = value!;
                        _updateAvailableConversions();
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          
          // Specific Conversion Selection
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Conversion',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: selectedConversion,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: conversionSystems[selectedSystem]![selectedMeasurement]!.keys.map((conversion) {
                      return DropdownMenuItem(
                        value: conversion,
                        child: Text(conversion),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedConversion = value!;
                        _performConversion();
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          
          // Input and Result
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Convert',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: inputController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter value to convert',
                      hintText: '0',
                    ),
                    onChanged: (value) => _performConversion(),
                  ),
                  SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      border: Border.all(color: Colors.blue[200]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Result:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[800],
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          result.isEmpty ? 'Enter a value to see the conversion' : result,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[900],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _updateAvailableConversions() {
    selectedConversion = conversionSystems[selectedSystem]![selectedMeasurement]!.keys.first;
    _performConversion();
  }

  void _performConversion() {
    if (inputController.text.isEmpty) {
      setState(() {
        result = '';
      });
      return;
    }

    double inputValue = double.tryParse(inputController.text) ?? 0.0;
    Map<String, dynamic> conversionData = conversionSystems[selectedSystem]![selectedMeasurement]![selectedConversion]!;
    
    double convertedValue = inputValue * conversionData['factor'];
    String symbol = conversionData['symbol'];
    
    setState(() {
      result = '${convertedValue.toStringAsFixed(4)} $symbol';
    });
  }
}


