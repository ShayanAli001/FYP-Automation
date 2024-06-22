import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:madproject/Screens/studentSignin.dart';
import 'package:madproject/Screens/teacherSignin.dart';
import 'package:madproject/StudentPortal/studentPanel.dart';

import 'Screens/StudentorTeacher.dart';
import 'StudentPortal/Notifications.dart';
import 'StudentPortal/appointment.dart';
import 'StudentPortal/atendence.dart';
import 'StudentPortal/chatbox.dart';
import 'StudentPortal/stdntprofile.dart';

class HomeScreen extends StatelessWidget {
  final String? email;

  HomeScreen(this.email);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.grey[600],
      appBar: AppBar(
        title: Center(child: Text("DashBoard")),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.logout),
          onPressed: () {
            _logout(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.grey),
            onPressed: () {
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                _buildMenuItem(context, Icons.person, "Profile"),
                _buildMenuItem(context, Icons.assignment, "Attendance"),
                _buildMenuItem(context, Icons.calendar_today, "Chatbox"),
                _buildMenuItem(context, Icons.calendar_today, "Appointment"),
                _buildMenuItem(context, Icons.chat, "Notifications"),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
        ],
        onTap: (int index) {
          if (index == 1) {

          }
          else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen(email)),
            );
          }
          if (index == 3) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => StudentPanel(email)),
            );
          }
        },
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String title) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
        onTap: () async {
          if (title == "Profile") {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>StudentPanel(this.email)));
          } else if(title == "Appointment") {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Appointment(this.email)));
          }else if(title == "Chatbox") {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>gptScreen(this.email)));
          }else if(title == "Notifications") {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Notifications(this.email)));
          }else if(title == "Attendance") {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>CheckAttendance(this.email)));
          }else{
            // Handle other menu items
          }
        },
      ),
    );
  }

  Future<void> _checkEmailInFirestore(BuildContext context) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('studentinfo')
          .where('email', isEqualTo: email)
          .get();

      if (snapshot.docs.isNotEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => StudentPanel(email)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No Record Found')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error checking email: $e')),
      );
    }
  }
  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout Confirmation'),
          content: Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => StudentTeacher()),
                );
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
