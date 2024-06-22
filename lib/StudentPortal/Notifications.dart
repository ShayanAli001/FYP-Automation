import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:madproject/HomeScreen.dart';

class Notifications extends StatefulWidget {
  final String? email;

  Notifications(this.email);

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<Notifications>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late String? email;

  @override
  void initState() {
    super.initState();
    email = widget.email;
    _tabController = TabController(length: 3, vsync: this);
  }

  Future<List<Map<String, dynamic>>> _fetchPendingAppointments() async {
    if (email == null) return [];
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('appointment_requests')
          .where('email', isEqualTo: email)
          .get();

      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return {
          'appointmentName': data['appointmentName'] ?? 'No name provided',
          'appointmentDate': data['appointmentDate'] ?? 'No date provided',
          'timeSlot': data['timeSlot'] ?? 'No time slot provided',
          'email': data['email'] ?? 'No email provided',
          'teacherId': data['teacherId'] ?? 'No teacherId provided',
          'teacherName': data['teacherName'] ?? 'No teacherName provided',
        };
      }).toList();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> _fetchAcceptedAppointments() async {
    if (email == null) return [];
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('acceptedReq')
          .where('email', isEqualTo: email)
          .get();

      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return {
          'appointmentName': data['appointmentName'] ?? 'No name provided',
          'appointmentDate': data['appointmentDate'] ?? 'No date provided',
          'timeSlot': data['timeSlot'] ?? 'No time slot provided',
          'email': data['email'] ?? 'No email provided',
          'teacherId': data['teacherId'] ?? 'No teacherId provided',
          'teacherName': data['teacherName'] ?? 'No teacherName provided',
        };
      }).toList();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> _fetchRejectedAppointments() async {
    if (email == null) return [];
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('rejReq')
          .where('email', isEqualTo: email)
          .get();

      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return {
          'appointmentName': data['appointmentName'] ?? 'No name provided',
          'appointmentDate': data['appointmentDate'] ?? 'No date provided',
          'timeSlot': data['timeSlot'] ?? 'No time slot provided',
          'email': data['email'] ?? 'No email provided',
          'teacherId': data['teacherId'] ?? 'No teacherId provided',
          'teacherName': data['teacherName'] ?? 'No teacherName provided',
        };
      }).toList();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
      return [];
    }
  }

  Widget _buildAppointmentList(
      Future<List<Map<String, dynamic>>> futureAppointments, String type) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: futureAppointments,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No Appointments'));
        }

        return ListView(
          children: snapshot.data!.map((data) {
            String message;
            if (type == 'accepted') {
              message = 'Your appointment was accepted by${data['teacherName']}.';
            } else if (type == 'rejected') {
              message = 'Your appointment was rejected by ${data['teacherName']}.';
            } else {
              message = 'You have sent an appointment request to ${data['teacherName']}.';
            }

            return Container(
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dear ${data['email']},',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        message,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Appointment Name: ${data['appointmentName']}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Date: ${data['appointmentDate']}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Time: ${data['timeSlot']}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[600],
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => HomeScreen(email)));
          },
        ),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text('Notifications'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.yellow,
          unselectedLabelColor: Colors.white,
          tabs: [
            Tab(text: 'Pending'),
            Tab(text: 'Accepted'),
            Tab(text: 'Rejected'),
          ],
        ),
      ),
      body: email != null
          ? TabBarView(
        controller: _tabController,
        children: [
          _buildAppointmentList(_fetchPendingAppointments(), 'pending'),
          _buildAppointmentList(_fetchAcceptedAppointments(), 'accepted'),
          _buildAppointmentList(_fetchRejectedAppointments(), 'rejected'),
        ],
      )
          : Center(child: Text('Invalid email or no data found')),
    );
  }
}
