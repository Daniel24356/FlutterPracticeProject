import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class VetSchedulePage extends StatefulWidget {
  @override
  _VetSchedulePageState createState() => _VetSchedulePageState();
}

class _VetSchedulePageState extends State<VetSchedulePage> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  // Dummy vet appointments
  final Map<String, List<Map<String, String>>> appointments = {
    "2025-09-19": [
      {
        "time": "08:30 AM - 09:30 AM",
        "title": "Dog Vaccination",
        "room": "Room 3, Vet Clinic",
        "doctor": "Dr. Goodman",
        "color": "0xFFFFFFFF"
      },
      {
        "time": "10:30 AM - 11:30 AM",
        "title": "Cat Check-up",
        "room": "Room 5, Vet Clinic",
        "doctor": "Dr. Melton",
        "color": "0xFFCCFFCC"
      },
      {
        "time": "01:00 PM - 02:00 PM",
        "title": "Parrot Surgery",
        "room": "Room 7, Vet Clinic",
        "doctor": "Dr. Hodge",
        "color": "0xFFE0E0FF"
      },
    ],
    "2025-09-20": [
      {
        "time": "09:00 AM - 10:00 AM",
        "title": "Rabbit Dental Cleaning",
        "room": "Room 2, Vet Clinic",
        "doctor": "Dr. Goodman",
        "color": "0xFFFFE0E0"
      }
    ],
  };

  List<Map<String, String>> getDayAppointments(DateTime day) {
    String key = DateFormat('yyyy-MM-dd').format(day);
    return appointments[key] ?? [];
  }

  void _openCalendar() async {
    DateTime? picked = await showDialog<DateTime>(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          padding: EdgeInsets.all(16),
          child: TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime(2020),
            lastDay: DateTime(2030),
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selected, focused) {
              setState(() {
                _selectedDay = selected;
                _focusedDay = focused;
              });
              Navigator.pop(context, selected);
            },
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
          ),
        ),
      ),
    );

    if (picked != null) {
      setState(() {
        _selectedDay = picked;
        _focusedDay = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> todaysAppointments = getDayAppointments(_selectedDay);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text("My Schedule", style: TextStyle(color: Colors.black)),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_month, color: Colors.black),
            onPressed: _openCalendar,
          ),
        ],
      ),
      body: Column(
        children: [
          // Horizontal date bar
          Container(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 14,
              itemBuilder: (context, index) {
                DateTime day = _focusedDay.add(Duration(days: index));
                bool isSelected = isSameDay(day, _selectedDay);

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDay = day;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.purple[200] : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? Colors.purple : Colors.grey[300]!,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(DateFormat("E").format(day),
                            style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black)),
                        SizedBox(height: 4),
                        Text("${day.day}",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color:
                                isSelected ? Colors.white : Colors.black)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Appointment list
          Expanded(
            child: todaysAppointments.isEmpty
                ? Center(
                child: Text("No appointments",
                    style: TextStyle(color: Colors.grey, fontSize: 16)))
                : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: todaysAppointments.length,
              itemBuilder: (context, index) {
                var appt = todaysAppointments[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 16),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(int.parse(appt["color"]!)),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(appt["title"]!,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      SizedBox(height: 4),
                      Text(appt["time"]!,
                          style: TextStyle(color: Colors.grey[700])),
                      SizedBox(height: 4),
                      Text(appt["room"]!,
                          style: TextStyle(color: Colors.grey[600])),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey[400],
                            child: Icon(Icons.pets, color: Colors.white),
                          ),
                          SizedBox(width: 8),
                          Text(appt["doctor"]!,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500)),
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

