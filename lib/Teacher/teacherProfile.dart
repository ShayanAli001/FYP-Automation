import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:madproject/Screens/StudentorTeacher.dart';
import 'package:madproject/Teacher/display_team.dart';
import 'package:madproject/Teacher/techerPanel.dart';

class teacherProfile extends StatelessWidget {
  final String teacherId;

  teacherProfile(this.teacherId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[600],
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => TeacherPanel(teacherId)));
          },
        ),
        title: Text("Teacher Profile"),
        backgroundColor: Colors.blueGrey[900], // Dark blue-grey app bar
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 16),
            _buildProfileSection(context),
            SizedBox(height: 16),
            Divider(color: Colors.blueGrey[900]),
            _buildCurrentScheduleSection(context),
            SizedBox(height: 16),
            Divider(color: Colors.blueGrey[900]),
            _buildAppointmentRequestsSection(context),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('teachersinfo')
          .doc(teacherId)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Center(child: Text('No record found for this teacher'));
        }

        var teacherData = snapshot.data!.data() as Map<String, dynamic>;
        String teacherName = teacherData['name'] ?? 'No name provided';
        String teacherRole = teacherData['role'] ?? 'No role provided';

        return Container(
          color: Colors.blueGrey[100], // Light blue-grey background
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors
                    .blueGrey[900], // Dark blue-grey for avatar background
                child: Icon(Icons.person, size: 80, color: Colors.white),
              ),
              SizedBox(height: 12),
              Text(
                teacherName,
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey[900]),
              ),
              SizedBox(height: 8),
              Text(
                teacherRole,
                style: TextStyle(fontSize: 18, color: Colors.blueGrey[900]),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCurrentScheduleSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Current Schedule',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
          SizedBox(height: 12),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('acceptedReq')
                .where('teacherId', isEqualTo: teacherId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              var scheduleDocs = snapshot.data!.docs;
              if (scheduleDocs.isEmpty) {
                return Center(child: Text('No accepted appointments found'));
              }

              return ListView.builder(
                shrinkWrap: true,
                itemCount: scheduleDocs.length,
                itemBuilder: (context, index) {
                  var data = scheduleDocs[index].data() as Map<String, dynamic>;
                  String appointmentName =
                      data['appointmentName'] ?? 'No name provided';
                  String timeSlot = data['timeSlot'] ?? 'No time slot provided';
                  String appointmentDate =
                      data['appointmentDate'] ?? 'No date provided';
                  return _buildScheduleCard(
                      context, appointmentName, appointmentDate, timeSlot);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleCard(
      BuildContext context, String name, String date, String timeSlot) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
            12), // Adding border radius for circular shape
      ),
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text(date,
                    style:
                        TextStyle(fontSize: 16, color: Colors.blueGrey[900])),
                Text(timeSlot,
                    style:
                        TextStyle(fontSize: 16, color: Colors.blueGrey[900])),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _showScheduleDetails(context, name, date, timeSlot);
            },
            child: Text('Show Details'),
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[600],
                foregroundColor: Colors.black), // Dark blue-grey button
          ),
        ],
      ),
    );
  }

  void _showScheduleDetails(BuildContext context, String appointmentName,
      String appointmentDate, String timeSlot) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('acceptedReq')
          .where('appointmentName', isEqualTo: appointmentName)
          .where('appointmentDate', isEqualTo: appointmentDate)
          .where('timeSlot', isEqualTo: timeSlot)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var data = querySnapshot.docs.first.data() as Map<String, dynamic>;
        String email = data['email'] ?? 'No email provided';

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Current Schedule'),
              content: Text('Do you want to see Students Information'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TeamPage(email)));
                  },
                  child: Text('Yes'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('No'),
                ),
              ],
            );
          },
        );
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Details not found')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Widget _buildAppointmentRequestCard(BuildContext context, String name,
      String date, String timeSlot, String docId) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
            12), // Adding border radius for circular shape
      ),
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text(date, style: TextStyle(fontSize: 16, color: Colors.red)),
              Text(timeSlot, style: TextStyle(fontSize: 16, color: Colors.red)),
            ],
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  _acceptAppointmentRequest(
                      context, docId, name, date, timeSlot);
                },
                child: Text('Accept'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green), // Green accept button
              ),
              SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  _rejectAppointmentRequest(
                      context, docId, name, date, timeSlot);
                },
                child: Text('Reject'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red), // Red reject button
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentRequestsSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Appointment Requests',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey[900])),
          SizedBox(height: 12),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('appointment_requests')
                .where('teacherId', isEqualTo: teacherId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              var appointmentDocs = snapshot.data!.docs;
              if (appointmentDocs.isEmpty) {
                return Center(child: Text('No appointment requests found'));
              }

              return Column(
                children: appointmentDocs.map((doc) {
                  var data = doc.data() as Map<String, dynamic>;
                  String appointmentName =
                      data['appointmentName'] ?? 'No name provided';
                  String appointmentDate =
                      data['appointmentDate'] ?? 'No date provided';
                  String timeSlot = data['timeSlot'] ?? 'No time slot provided';
                  return _buildAppointmentRequestCard(context, appointmentName,
                      appointmentDate, timeSlot, doc.id);
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  void _acceptAppointmentRequest(BuildContext context, String docId,
      String appointmentName, String appointmentDate, String timeSlot) async {
    try {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('appointment_requests')
          .doc(docId)
          .get();

      if (docSnapshot.exists) {
        Map<String, dynamic> requestData =
            docSnapshot.data() as Map<String, dynamic>;
        String appointmentRequestEmail = requestData['email'];

        await FirebaseFirestore.instance.collection('acceptedReq').add({
          'appointmentName':
              requestData['appointmentName'] ?? 'No name provided',
          'appointmentDate':
              requestData['appointmentDate'] ?? 'No date provided',
          'timeSlot': requestData['timeSlot'] ?? 'No time slot provided',
          'email': requestData['email'] ?? 'No email provided',
          'teacherId': requestData['teacherId'] ?? 'No teacherId provided',
          'teacherName': requestData['teacherName'] ?? 'No teacherId provided',
        });
        await FirebaseFirestore.instance
            .collection('appointment_requests')
            .doc(docId)
            .delete();
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Document not found')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void _rejectAppointmentRequest(BuildContext context, String docId,
      String appointmentName, String appointmentDate, String timeSlot) async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('appointment_requests')
          .doc(docId)
          .get();
      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        String email = data['email'];
        await FirebaseFirestore.instance.collection('rejReq').add({
          'appointmentName': data['appointmentName'] ?? 'No name provided',
          'appointmentDate': data['appointmentDate'] ?? 'No date provided',
          'timeSlot': data['timeSlot'] ?? 'No time slot provided',
          'email': data['email'] ?? 'No email provided',
          'teacherId': data['teacherId'] ?? 'No teacherId provided',
          'teacherName': data['teacherName'] ?? 'No teacherId provided',

        });
        await FirebaseFirestore.instance
            .collection('appointment_requests')
            .doc(docId)
            .delete();
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Request rejected')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }
}
