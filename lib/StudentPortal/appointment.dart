
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:madproject/HomeScreen.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class Appointment extends StatefulWidget {
  final String? email;

  Appointment(this.email);

  @override
  State<Appointment> createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> {
  late String email;

  @override
  void initState() {
    super.initState();
    email = widget.email ?? '';
  }

  Future<List<Map<String, dynamic>>> _fetchTeachers() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('teachersinfo').get();
      return snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        data['teacherId'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      throw Exception('Error fetching teachers info: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[600],
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.grey),
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(email)));
          },
        ),
        title: Text('Available Teachers'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchTeachers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No teachers found'));
          } else {
            final teachers = snapshot.data!;
            return ListView.builder(
              itemCount: teachers.length,
              itemBuilder: (context, index) {
                final teacher = teachers[index];
                final name = teacher['name'] ?? 'No Name';
                final teacherId = teacher['teacherId'] ?? ''; // Retrieve the teacherId
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: Icon(Icons.person, size: 30),
                    ),
                    title: Text(name),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TeacherDetail(teacher: teacher, email: email),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class TeacherDetail extends StatefulWidget {
  final Map<String, dynamic> teacher;
  final String email; // Add email parameter

  TeacherDetail({required this.teacher, required this.email});

  @override
  _TeacherDetailState createState() => _TeacherDetailState();
}

class _TeacherDetailState extends State<TeacherDetail> {
  late String email;

  @override
  void initState() {
    super.initState();
    email = widget.email;
  }

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  TimeOfDay? _selectedTime;
  TextEditingController _timeController = TextEditingController();
  TextEditingController _appointmentNameController = TextEditingController();

  @override
  void dispose() {
    _timeController.dispose();
    _appointmentNameController.dispose();
    super.dispose();
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
        _timeController.text = picked.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400],
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.grey),
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Appointment(email)));
          },
        ),
        title: Text('${widget.teacher['name']}'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Calendar for 2024',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            TableCalendar(
              firstDay: DateTime(2024, 1, 1),
              lastDay: DateTime(2024, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: CalendarFormat.month,
              startingDayOfWeek: StartingDayOfWeek.monday,
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekendStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                weekdayStyle: TextStyle(fontWeight: FontWeight.bold),
              ),
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              availableGestures: AvailableGestures.all,
              calendarStyle: CalendarStyle(
                outsideDaysVisible: false,
                selectedDecoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Appointment Details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _appointmentNameController,
              decoration: InputDecoration(
                labelText: 'Name',
                hintText: 'Name of Appointment',
                prefixIcon: Icon(Icons.assignment),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _timeController,
              readOnly: true,
              onTap: () => _selectTime(context),
              decoration: InputDecoration(
                labelText: 'Time',
                hintText: 'Select a time',
                prefixIcon: Icon(Icons.timelapse),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _addAppointmentRequest(context);
                },
                child: Text('Add Appointment Request'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addAppointmentRequest(BuildContext context) async {
    if (_selectedDay != null &&
        _timeController.text.isNotEmpty &&
        _appointmentNameController.text.isNotEmpty) {
      try {
        final formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDay!);

        String teacherId = widget.teacher['teacherId'];
        String teacherName = widget.teacher['name']; // Fetch teacher name
        DocumentReference appointmentRef = FirebaseFirestore.instance.collection('appointment_requests').doc();

        await appointmentRef.set({
          'appointmentName': _appointmentNameController.text,
          'appointmentDate': formattedDate,
          'timeSlot': _timeController.text,
          'teacherId': teacherId,
          'teacherName': teacherName, // Store teacher name
          'email': email,
        });

        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Appointment request sent')),
        );

        // Clear fields after successful submission
        setState(() {
          _selectedDay = null;
          _appointmentNameController.clear();
          _timeController.clear();
        });
      } catch (e) {
        // Show an error message if something goes wrong
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add appointment request: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
    }
  }
}
