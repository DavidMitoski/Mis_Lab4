import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../providers/exam_provider.dart';
import 'add_exam_screen.dart';
import 'map_screen.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDate = DateTime.now();
  late Map<DateTime, List<dynamic>> _selectedEvents;
  late Timer _timer;
  String _currentTime = _getCurrentTime();

  @override
  void initState() {
    super.initState();
    _selectedEvents = {};
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = _getCurrentTime();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  static String _getCurrentTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final examProvider = Provider.of<ExamProvider>(context);
    final examsForSelectedDate = examProvider.getExamsForDate(_selectedDate);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Финки календар \n213221',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 8.0,
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.map, color: Colors.white),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => MapScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Тековно време: $_currentTime',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2025, 12, 31),
              focusedDay: _selectedDate,
              selectedDayPredicate: (day) => isSameDay(day, _selectedDate),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDate = selectedDay;
                  _selectedEvents = {selectedDay: examsForSelectedDate};
                });
              },
              onPageChanged: (focusedDay) {
                setState(() {
                  _selectedDate = focusedDay;
                });
              },
              eventLoader: (day) =>
                  examProvider.getExamsForDate(day).map((e) => e.title).toList(),
              calendarStyle: CalendarStyle(
                todayTextStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                selectedTextStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                todayDecoration: BoxDecoration(
                  color: Colors.pinkAccent,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.teal,
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                leftChevronIcon: Icon(
                  Icons.arrow_back,
                  color: Colors.teal,
                ),
                rightChevronIcon: Icon(
                  Icons.arrow_forward,
                  color: Colors.teal,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            if (examsForSelectedDate.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: examsForSelectedDate.length,
                  itemBuilder: (ctx, i) {
                    final exam = examsForSelectedDate[i];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      elevation: 6,
                      color: Colors.teal[50],
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16.0),
                        title: Text(
                          "Испит по: ${exam.title}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                        subtitle: Text(
                          'Време: ${exam.dateTime.hour.toString().padLeft(2, '0')}:${exam.dateTime.minute.toString().padLeft(2, '0')}\nЛокација: ${exam.locationName}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            else
              const Center(
                  child: Text(
                    'Нема испити за овој ден',
                    style: TextStyle(fontSize: 16),
                  )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => AddExamScreen()),
          );
        },
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
