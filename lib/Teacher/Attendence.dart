import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:madproject/Teacher/techerPanel.dart';
import 'package:table_calendar/table_calendar.dart';

class Attendence extends StatefulWidget {
  final String teacherId;

  Attendence(this.teacherId);

  @override
  _AttendenceState createState() => _AttendenceState();
}

class _AttendenceState extends State<Attendence> {
  late Stream<QuerySnapshot> _studentsStream;

  @override
  void initState() {
    super.initState();
    _studentsStream = FirebaseFirestore.instance
        .collection('acceptedReq')
        .where('teacherId', isEqualTo: widget.teacherId)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: ()
          {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (contex)=>TeacherPanel(widget.teacherId)));
          },
        ),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text('Student List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _studentsStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No students found for this teacher.'),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((doc) {
              return ListTile(
                tileColor: Colors.grey[800],
                title: Text(
                  '${doc['appointmentName']}',
                  style: TextStyle(color: Colors.white),
                ),
                // subtitle: Text(
                //   doc['email'],
                //   style: TextStyle(color: Colors.white70),
                // ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CalendarScreen(
                        studentId: doc.id,
                        studentName: doc['appointmentName'],
                        studentEmail: doc['email'],
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

class CalendarScreen extends StatefulWidget {
  final String studentId;
  final String studentName;
  final String studentEmail;

  const CalendarScreen({
    Key? key,
    required this.studentId,
    required this.studentName,
    required this.studentEmail,
  }) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDay = DateTime.now();

  void _markAttendance(String status) async {
    final String formattedDate = "${_selectedDay.year}-${_selectedDay.month}-${_selectedDay.day}";

    try {
      await FirebaseFirestore.instance.collection('attendance').add({
        'name': widget.studentName,
        'email': widget.studentEmail,
        'date': formattedDate,
        'status': status,
        'studentId': widget.studentId,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Attendance marked as $status for ${widget.studentEmail} on $formattedDate')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error marking attendance: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900], // Darker blue-grey
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text('Calendar - Mark Attendance'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 16.0),
            TableCalendar(
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: _selectedDay,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                });
              },
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                todayTextStyle: TextStyle(color: Colors.white),
                selectedTextStyle: TextStyle(color: Colors.white),
                weekendTextStyle: TextStyle(color: Colors.red),
                defaultTextStyle: TextStyle(color: Colors.white),
                outsideTextStyle: TextStyle(color: Colors.grey),
              ),
              headerStyle: HeaderStyle(
                titleTextStyle: TextStyle(color: Colors.white, fontSize: 18),
                formatButtonTextStyle: TextStyle(color: Colors.black),
                formatButtonDecoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white),
                rightChevronIcon: Icon(Icons.chevron_right, color: Colors.white),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _markAttendance('Present'),
              child: Text('Mark Present (P)'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green,
                textStyle: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () => _markAttendance('Absent'),
              child: Text('Mark Absent (A)'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
                textStyle: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
