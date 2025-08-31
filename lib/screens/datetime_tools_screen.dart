import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';

class DateTimeToolsScreen extends StatefulWidget {
  @override
  _DateTimeToolsScreenState createState() => _DateTimeToolsScreenState();
}

class _DateTimeToolsScreenState extends State<DateTimeToolsScreen> {
  // For Time Zone Converter
  String selectedTimezoneFrom = 'UTC';
  String selectedTimezoneTo = 'America/Sao_Paulo';
  DateTime? dateTimeToConvert = DateTime.now();
  String convertedTime = '';

  // For Date Difference Calculator
  DateTime? startDate = DateTime.now();
  DateTime? endDate = DateTime.now().add(Duration(days: 7));
  String dateDifference = '';

  // For Stopwatch
  bool _isRunningStopwatch = false;
  int _stopwatchSeconds = 0;
  late Stopwatch _stopwatch;
  late Ticker _stopwatchTicker;

  // For Timer
  bool _isRunningTimer = false;
  int _timerSeconds = 0;
  TextEditingController _timerInputController = TextEditingController();
  late Timer _timer;

  final List<String> timezones = [
    'UTC',
    'America/New_York',
    'America/Sao_Paulo',
    'Europe/London',
    'Asia/Tokyo',
    'Australia/Sydney',
  ];

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();
    _updateConvertedTime();
    _calculateDateDifference();
  }

  @override
  void dispose() {
    _timerInputController.dispose();
    if (_isRunningTimer) {
      _timer.cancel();
    }
    super.dispose();
  }

  // Time Zone Converter Logic
  void _updateConvertedTime() {
    if (dateTimeToConvert == null) return;

    // This is a simplified conversion. For accurate timezone conversion,
    // a package like 'timezone' would be needed.
    // Here, we'll just simulate by adjusting hours for demonstration.
    // In a real app, you'd get the offset for each timezone.
    int fromOffset = _getTimezoneOffset(selectedTimezoneFrom);
    int toOffset = _getTimezoneOffset(selectedTimezoneTo);

    DateTime tempDateTime = dateTimeToConvert!;
    // Convert to UTC first
    tempDateTime = tempDateTime.subtract(Duration(hours: fromOffset));
    // Then convert to target timezone
    tempDateTime = tempDateTime.add(Duration(hours: toOffset));

    setState(() {
      convertedTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(tempDateTime);
    });
  }

  int _getTimezoneOffset(String timezone) {
    switch (timezone) {
      case 'UTC': return 0;
      case 'America/New_York': return -5; // EST
      case 'America/Sao_Paulo': return -3; // BRT
      case 'Europe/London': return 0; // GMT/BST
      case 'Asia/Tokyo': return 9; // JST
      case 'Australia/Sydney': return 10; // AEST
      default: return 0;
    }
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: dateTimeToConvert ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(dateTimeToConvert ?? DateTime.now()),
      );
      if (pickedTime != null) {
        setState(() {
          dateTimeToConvert = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
        _updateConvertedTime();
      }
    }
  }

  // Date Difference Calculator Logic
  void _calculateDateDifference() {
    if (startDate == null || endDate == null) {
      setState(() {
        dateDifference = 'Select both dates';
      });
      return;
    }

    Duration difference = endDate!.difference(startDate!);
    setState(() {
      dateDifference = '${difference.inDays} days, ${difference.inHours % 24} hours, ${difference.inMinutes % 60} minutes, ${difference.inSeconds % 60} seconds';
    });
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != startDate) {
      setState(() {
        startDate = picked;
      });
      _calculateDateDifference();
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: endDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != endDate) {
      setState(() {
        endDate = picked;
      });
      _calculateDateDifference();
    }
  }

  // Stopwatch Logic
  void _startStopwatch() {
    setState(() {
      _isRunningStopwatch = true;
      _stopwatch.start();
    });
    _stopwatchTicker = Ticker((Duration elapsed) {
      setState(() {
        _stopwatchSeconds = _stopwatch.elapsed.inSeconds;
      });
    });
    _stopwatchTicker.start();
  }

  void _stopStopwatch() {
    setState(() {
      _isRunningStopwatch = false;
      _stopwatch.stop();
    });
    _stopwatchTicker.dispose();
  }

  void _resetStopwatch() {
    setState(() {
      _isRunningStopwatch = false;
      _stopwatch.reset();
      _stopwatchSeconds = 0;
    });
    _stopwatchTicker.dispose();
  }

  String _formatStopwatchTime(int totalSeconds) {
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;
    return '${hours.toString().padLeft(2, '0')}:' +
           '${minutes.toString().padLeft(2, '0')}:' +
           '${seconds.toString().padLeft(2, '0')}';
  }

  // Timer Logic
  void _startTimer() {
    int? inputSeconds = int.tryParse(_timerInputController.text);
    if (inputSeconds == null || inputSeconds <= 0) {
      // Optionally show an error to the user
      return;
    }

    setState(() {
      _timerSeconds = inputSeconds;
      _isRunningTimer = true;
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timerSeconds > 0) {
          _timerSeconds--;
        } else {
          _timer.cancel();
          _isRunningTimer = false;
          // Optionally show a notification that timer is done
        }
      });
    });
  }

  void _stopTimer() {
    setState(() {
      _isRunningTimer = false;
      _timer.cancel();
    });
  }

  void _resetTimer() {
    setState(() {
      _isRunningTimer = false;
      _timer.cancel();
      _timerSeconds = 0;
      _timerInputController.clear();
    });
  }

  String _formatTimerTime(int totalSeconds) {
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;
    return '${hours.toString().padLeft(2, '0')}:' +
           '${minutes.toString().padLeft(2, '0')}:' +
           '${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Date & Time Tools',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Convert timezones, calculate date differences, use stopwatch and timer',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 24),
          
          // Time Zone Converter
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Time Zone Converter',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  ListTile(
                    title: Text('Date and Time: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTimeToConvert ?? DateTime.now())}'),
                    trailing: Icon(Icons.edit),
                    onTap: () => _selectDateTime(context),
                  ),
                  DropdownButtonFormField<String>(
                    value: selectedTimezoneFrom,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'From Timezone',
                    ),
                    items: timezones.map((tz) {
                      return DropdownMenuItem(
                        value: tz,
                        child: Text(tz),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedTimezoneFrom = value!;
                      });
                      _updateConvertedTime();
                    },
                  ),
                  SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: selectedTimezoneTo,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'To Timezone',
                    ),
                    items: timezones.map((tz) {
                      return DropdownMenuItem(
                        value: tz,
                        child: Text(tz),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedTimezoneTo = value!;
                      });
                      _updateConvertedTime();
                    },
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Converted Time: $convertedTime',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          
          // Date Difference Calculator
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Date Difference Calculator',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  ListTile(
                    title: Text('Start Date: ${DateFormat('yyyy-MM-dd').format(startDate ?? DateTime.now())}'),
                    trailing: Icon(Icons.edit),
                    onTap: () => _selectStartDate(context),
                  ),
                  ListTile(
                    title: Text('End Date: ${DateFormat('yyyy-MM-dd').format(endDate ?? DateTime.now())}'),
                    trailing: Icon(Icons.edit),
                    onTap: () => _selectEndDate(context),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Difference: $dateDifference',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          
          // Stopwatch
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Stopwatch',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    _formatStopwatchTime(_stopwatchSeconds),
                    style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _isRunningStopwatch ? _stopStopwatch : _startStopwatch,
                        child: Text(_isRunningStopwatch ? 'Stop' : 'Start'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isRunningStopwatch ? Colors.orange : Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                      SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: _resetStopwatch,
                        child: Text('Reset'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          
          // Timer
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Timer',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: _timerInputController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter seconds for timer',
                      hintText: '60',
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    _formatTimerTime(_timerSeconds),
                    style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _isRunningTimer ? _stopTimer : _startTimer,
                        child: Text(_isRunningTimer ? 'Stop' : 'Start'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isRunningTimer ? Colors.orange : Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                      SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: _resetTimer,
                        child: Text('Reset'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
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


