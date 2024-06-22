import 'package:flutter/material.dart';
import 'package:madproject/Screens/studentSignin.dart';
import 'package:madproject/Screens/teacherSignin.dart';


class StudentTeacher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[600],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>studentSignin()));
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                minimumSize: Size(200, 50), // Size of the button
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              child: Text('Student'),
            ),
            SizedBox(height: 20), // Spacing between the buttons
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => teacherSignin(), // Replace null with actual parameters if needed
                  ),
                );
                },
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                minimumSize: Size(200, 50), // Size of the button
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              child: Text('Teacher'),
            ),
          ],
        ),
      ),
    );
  }
}
