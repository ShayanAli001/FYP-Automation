import 'package:flutter/material.dart';
import 'package:madproject/Teacher/Attendence.dart';
import 'package:madproject/Teacher/teacherProfile.dart';
import '../Screens/StudentorTeacher.dart';

class TeacherPanel extends StatelessWidget {
  final String teacherId;

  TeacherPanel(this.teacherId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[600],
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.logout),
          onPressed: () {
            _logout(context);
          },
        ),
        backgroundColor: Colors.blueGrey[900],
        foregroundColor: Colors.white,
        title: Text('Teacher Dashboard'),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: 2,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ContainerButton(
                    label: index == 0 ? 'Teacher Profile' : 'Enrolled Students',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => index == 0 ? teacherProfile(teacherId) : Attendence(teacherId)),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
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

class ContainerButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const ContainerButton({
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150.0, // Increase the height of the button
      decoration: BoxDecoration(
        color: Colors.grey[600],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }
}
