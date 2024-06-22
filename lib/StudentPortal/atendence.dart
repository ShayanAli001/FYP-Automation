import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:madproject/HomeScreen.dart';

class CheckAttendance extends StatefulWidget {
  final String? email;

  CheckAttendance(this.email);

  @override
  State<CheckAttendance> createState() => _CheckAttendanceState();
}

class _CheckAttendanceState extends State<CheckAttendance> {
  List<Map<String, String>> attendanceList = [];

  @override
  void initState() {
    super.initState();
    fetchAttendance();
  }

  void fetchAttendance() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('attendance')
          .where('email', isEqualTo: widget.email)
          .get();

      setState(() {
        attendanceList = querySnapshot.docs.map((doc) {
          return {
            'date': doc['date'] as String,
            'status': doc['status'] as String,
          };
        }).toList();
      });
    } catch (error) {
      print("Failed to fetch attendance: $error");
      // Handle error state if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[600],
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: ()
          {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen(widget.email)));
          },
        ),
        title: const Text('Attendance'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.deepPurple.shade50,
        child: attendanceList.isEmpty
            ? Center(
          child: CircularProgressIndicator(
            color: Colors.deepPurple,
          ),
        )
            : ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: attendanceList.length,
          itemBuilder: (context, index) {
            var attendance = attendanceList[index];
            return Card(
              color: Colors.white,
              child: ListTile(
                leading: Icon(
                  Icons.date_range,
                  color: Colors.deepPurple,
                ),
                title: Text(
                  attendance['date'] ?? '',
                  style: TextStyle(
                    color: Colors.deepPurple.shade800,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  attendance['status'] ?? '',
                  style: TextStyle(
                    color: attendance['status'] == 'Present'
                        ? Colors.green
                        : attendance['status'] == 'Absent'
                        ? Colors.red
                        : Colors.orange,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
