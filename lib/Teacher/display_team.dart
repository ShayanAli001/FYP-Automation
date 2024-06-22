import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TeamPage extends StatelessWidget {
  final String? email;

  TeamPage(this.email);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[600],
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900], // Darker blue-grey
        title: Text('Team Details', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _getTeamData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('No data found'));
          }

          var teamData = snapshot.data!.data() as Map<String, dynamic>;
          return SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Divider(),
                    SizedBox(height: 10),
                    Text(
                      'Project ID: ${teamData['projectId']}',
                      style: TextStyle(fontSize: 30, color: Colors.white),
                      textAlign: TextAlign.start,
                    ),
                    Divider(),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white, // Light blue-grey
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Topic:${teamData['topicName']}',
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blueGrey[900]),
                      ),
                    ),
                  ],
                ),
                Divider(),
                SizedBox(height: 16),
                _buildSectionTitleWithIcon('Team Members', Icons.group),
                Divider(),
                for (var member in teamData['teamMembers']) _buildMemberTile(member),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<DocumentSnapshot> _getTeamData() async {
    try {
      var studentSnapshot = await FirebaseFirestore.instance
          .collection('studentinfo')
          .where('email', isEqualTo: email)
          .get();

      if (studentSnapshot.docs.isEmpty) {
        print('No student found with the given email');
        throw 'No student found with the given email';
      }

      var studentData = studentSnapshot.docs.first.data();
      var emaill = studentData['email'];
      print('Fetched teamId: $emaill');

      var teamSnapshot = await FirebaseFirestore.instance
          .collection('studentinfo')
          .doc(email)
          .get();

      if (!teamSnapshot.exists) {
        print('No team found with the given teamId');
        throw 'No team found with the given teamId';
      }

      return teamSnapshot;
    } catch (e) {
      print('Error fetching team data: $e');
      rethrow;
    }
  }

  Widget _buildSectionTitleWithIcon(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 40), // Darker blue-grey
        SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white), // Darker blue-grey
        ),
      ],
    );
  }

  Widget _buildMemberTile(String name) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      padding: EdgeInsets.all(12.0),
      margin: EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          CircleAvatar(
            child: Text(name[0]), // Display the first letter of the member's name
            backgroundColor: Colors.blueGrey[900], // Darker blue-grey
            foregroundColor: Colors.white,
          ),
          SizedBox(width: 12.0),
          Text(name, style: TextStyle(fontSize: 18, color: Colors.black87)),
        ],
      ),
    );
  }
}

