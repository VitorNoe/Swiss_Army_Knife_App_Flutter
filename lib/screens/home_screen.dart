import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Section
          Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.build, size: 32, color: Colors.red[700]),
                      SizedBox(width: 12),
                      Text(
                        'Welcome to Swiss Army Knife',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.red[700],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Your all-in-one utility app with powerful tools for everyday tasks. Choose from various converters, calculators, and utilities designed to make your life easier.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          
          // Tools Grid
          Text(
            'Available Tools',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          
          GridView.count(
            crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildToolCard(
                context,
                'Unit Converter',
                'Convert between different units',
                Icons.swap_horiz,
                Colors.blue,
                1,
              ),
              _buildToolCard(
                context,
                'Measurement Converter',
                'Imperial to metric conversions',
                Icons.straighten,
                Colors.green,
                2,
              ),
              _buildToolCard(
                context,
                'Text Tools',
                'Text manipulation utilities',
                Icons.text_fields,
                Colors.purple,
                3,
              ),
              _buildToolCard(
                context,
                'Calculator',
                'Basic and scientific calculator',
                Icons.calculate,
                Colors.orange,
                4,
              ),
              _buildToolCard(
                context,
                'Password Generator',
                'Generate secure passwords',
                Icons.lock,
                Colors.red,
                5,
              ),
              _buildToolCard(
                context,
                'Currency Converter',
                'Real-time currency conversion',
                Icons.monetization_on,
                Colors.amber,
                6,
              ),
              _buildToolCard(
                context,
                'Date & Time Tools',
                'Time zones and date calculators',
                Icons.access_time,
                Colors.teal,
                7,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToolCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color color,
    int index,
  ) {
    return Card(
      child: InkWell(
        onTap: () {
          // Navigate to specific screen using Navigator
          String routeName = '';
          switch (index) {
            case 1:
              routeName = '/unit-converter';
              break;
            case 2:
              routeName = '/measurement-converter';
              break;
            case 3:
              routeName = '/text-tools';
              break;
            case 4:
              routeName = '/calculator';
              break;
            case 5:
              routeName = '/password-generator';
              break;
            case 6:
              routeName = '/currency-converter';
              break;
            case 7:
              routeName = '/datetime-tools';
              break;
            default:
              routeName = '/home';
          }
          if (routeName.isNotEmpty) {
            Navigator.pushNamed(context, routeName);
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: color,
              ),
              SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 8),
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

