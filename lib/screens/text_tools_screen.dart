import 'package:flutter/material.dart';

class TextToolsScreen extends StatefulWidget {
  @override
  _TextToolsScreenState createState() => _TextToolsScreenState();
}

class _TextToolsScreenState extends State<TextToolsScreen> {
  TextEditingController inputController = TextEditingController();
  TextEditingController outputController = TextEditingController();
  
  String selectedTool = 'Character Count';
  Map<String, int> textStats = {
    'characters': 0,
    'charactersNoSpaces': 0,
    'words': 0,
    'lines': 0,
    'paragraphs': 0,
  };

  final List<String> textTools = [
    'Character Count',
    'Word Count',
    'Reverse Text',
    'Uppercase',
    'Lowercase',
    'Title Case',
    'Remove Extra Spaces',
    'Remove Line Breaks',
    'Text Statistics',
  ];

  @override
  void initState() {
    super.initState();
    inputController.addListener(_updateStats);
  }

  @override
  void dispose() {
    inputController.dispose();
    outputController.dispose();
    super.dispose();
  }

  void _updateStats() {
    String text = inputController.text;
    setState(() {
      textStats['characters'] = text.length;
      textStats['charactersNoSpaces'] = text.replaceAll(' ', '').length;
      textStats['words'] = text.isEmpty ? 0 : text.trim().split(RegExp(r'\s+')).length;
      textStats['lines'] = text.isEmpty ? 0 : text.split('\n').length;
      textStats['paragraphs'] = text.isEmpty ? 0 : text.split('\n\n').length;
    });
  }

  void _performTextOperation() {
    String inputText = inputController.text;
    String processedText = '';

    switch (selectedTool) {
      case 'Character Count':
        processedText = 'Characters: ${textStats['characters']}, No Spaces: ${textStats['charactersNoSpaces']}';
        break;
      case 'Word Count':
        processedText = 'Words: ${textStats['words']}';
        break;
      case 'Reverse Text':
        processedText = inputText.split('').reversed.join();
        break;
      case 'Uppercase':
        processedText = inputText.toUpperCase();
        break;
      case 'Lowercase':
        processedText = inputText.toLowerCase();
        break;
      case 'Title Case':
        processedText = inputText.split(' ').map((word) => word.isNotEmpty ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}' : '').join(' ');
        break;
      case 'Remove Extra Spaces':
        processedText = inputText.replaceAll(RegExp(r'\s+'), ' ').trim();
        break;
      case 'Remove Line Breaks':
        processedText = inputText.replaceAll(RegExp(r'\n|\r'), ' ');
        break;
      case 'Text Statistics':
        processedText = 'Characters: ${textStats['characters']}\n' +
                        'Characters (No Spaces): ${textStats['charactersNoSpaces']}\n' +
                        'Words: ${textStats['words']}\n' +
                        'Lines: ${textStats['lines']}\n' +
                        'Paragraphs: ${textStats['paragraphs']}';
        break;
      default:
        processedText = 'Select a tool';
    }
    setState(() {
      outputController.text = processedText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Text Tools',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Various text manipulation and analysis tools',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 24),
          
          // Tool Selection
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Tool',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: selectedTool,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: textTools.map((tool) {
                      return DropdownMenuItem(
                        value: tool,
                        child: Text(tool),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedTool = value!;
                        _performTextOperation();
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          
          // Input Text Area
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Input Text',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: inputController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter your text here',
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _performTextOperation,
                    child: Text('Process Text'),
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
          
          // Output Text Area
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Output / Result',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: outputController,
                    maxLines: 5,
                    readOnly: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Result will appear here',
                      fillColor: Colors.grey[100],
                      filled: true,
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
}


