import 'dart:math';
import 'package:flutter/material.dart';

class PasswordGeneratorScreen extends StatefulWidget {
  @override
  _PasswordGeneratorScreenState createState() => _PasswordGeneratorScreenState();
}

class _PasswordGeneratorScreenState extends State<PasswordGeneratorScreen> {
  String _generatedPassword = '';
  double _passwordLength = 12;
  bool _includeUppercase = true;
  bool _includeLowercase = true;
  bool _includeNumbers = true;
  bool _includeSpecialChars = true;

  final String _uppercaseChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  final String _lowercaseChars = 'abcdefghijklmnopqrstuvwxyz';
  final String _numberChars = '0123456789';
  final String _specialChars = '!@#%^&*()_+-=[]{}|;:,.<>?';

  void _generatePassword() {
    String chars = '';
    if (_includeUppercase) chars += _uppercaseChars;
    if (_includeLowercase) chars += _lowercaseChars;
    if (_includeNumbers) chars += _numberChars;
    if (_includeSpecialChars) chars += _specialChars;

    if (chars.isEmpty) {
      setState(() {
        _generatedPassword = 'Select at least one character type';
      });
      return;
    }

    Random random = Random();
    String password = '';
    for (int i = 0; i < _passwordLength; i++) {
      password += chars[random.nextInt(chars.length)];
    }

    setState(() {
      _generatedPassword = password;
    });
  }

  @override
  void initState() {
    super.initState();
    _generatePassword(); // Generate initial password
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Password Generator',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Generate strong and secure passwords',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 24),
          
          // Password Display
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Generated Password',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SelectableText(
                      _generatedPassword,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: _generatePassword,
                    icon: Icon(Icons.refresh),
                    label: Text('Generate New Password'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[700],
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          
          // Options
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Options',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  ListTile(
                    title: Text('Password Length: ${_passwordLength.toInt()}'),
                    subtitle: Slider(
                      value: _passwordLength,
                      min: 4,
                      max: 32,
                      divisions: 28,
                      label: _passwordLength.toInt().toString(),
                      onChanged: (double value) {
                        setState(() {
                          _passwordLength = value;
                        });
                        _generatePassword();
                      },
                    ),
                  ),
                  CheckboxListTile(
                    title: Text('Include Uppercase Letters (A-Z)'),
                    value: _includeUppercase,
                    onChanged: (bool? value) {
                      setState(() {
                        _includeUppercase = value!;
                      });
                      _generatePassword();
                    },
                  ),
                  CheckboxListTile(
                    title: Text('Include Lowercase Letters (a-z)'),
                    value: _includeLowercase,
                    onChanged: (bool? value) {
                      setState(() {
                        _includeLowercase = value!;
                      });
                      _generatePassword();
                    },
                  ),
                  CheckboxListTile(
                    title: Text('Include Numbers (0-9)'),
                    value: _includeNumbers,
                    onChanged: (bool? value) {
                      setState(() {
                        _includeNumbers = value!;
                      });
                      _generatePassword();
                    },
                  ),
                  CheckboxListTile(
                    title: Text('Include Special Characters (!@#%^&*)'),
                    value: _includeSpecialChars,
                    onChanged: (bool? value) {
                      setState(() {
                        _includeSpecialChars = value!;
                      });
                      _generatePassword();
                    },
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


