import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:madproject/HomeScreen.dart';

class StudentPanel extends StatelessWidget {
  final String? email;

  StudentPanel(this.email);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[600],
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen(email)));
          },
        ),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 80,
        title: Text(
          'Student Panel',
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('studentinfo').doc(email).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('No data found.'));
          }

          var data = snapshot.data!.data() as Map<String, dynamic>;
          double attendance = double.tryParse(data['attendancePercentage']?.toString() ?? '0') ?? 0;

          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  color: Colors.grey[100],
                  padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 70,
                        backgroundColor: Colors.black,
                        child: Icon(Icons.person, size: 100, color: Colors.grey[600]),
                      ),
                      SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data['name'] ?? 'No Name',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            data['role'] ?? 'No Role',
                            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    color: Colors.grey[100],
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          'Project Progress',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Attendance',
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              '${attendance.toStringAsFixed(2)}%',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        LinearProgressIndicator(
                          value: attendance / 100,
                          backgroundColor: Colors.grey[300],
                          color: Colors.green,
                          minHeight: 10,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                SectionTitle(title: 'Supervisors'),
                ...List<Widget>.generate(
                  data['supervisorName'] != null ? data['supervisorName'].length : 0,
                      (index) => ProfileCard(
                    name: data['supervisorName'][index],
                    role: data['supervisorRole'][index],
                    area: data['areaOfResearch'],
                  ),
                ),
                SectionTitle(title: 'Others Project'),
                ProjectDetails(
                  supervisor: data['supervisedBy'],
                  topic: data['topicName'],
                  team: List<String>.from(data['teamMembers']),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[500],
      width: double.infinity,
      padding: EdgeInsets.all(10),
      child: Center(
        child: Text(
          title,
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  final String name;
  final String role;
  final String area;

  ProfileCard({
    required this.name,
    required this.role,
    required this.area,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.black,
            child: Icon(Icons.person, size: 50, color: Colors.white),
          ),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(role, style: TextStyle(fontSize: 16)),
              SizedBox(height: 10),
              Text(
                'Area of Research',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(area, style: TextStyle(fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }
}

class ProjectDetails extends StatelessWidget {
  final String supervisor;
  final String topic;
  final List<String> team;

  ProjectDetails({
    required this.supervisor,
    required this.topic,
    required this.team,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Supervised by:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(supervisor, style: TextStyle(fontSize: 16)),
          SizedBox(height: 10),
          Text(
            'Topic:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(topic, style: TextStyle(fontSize: 16)),
          SizedBox(height: 10),
          Text(
            'Team:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          ...team.map((member) => Text(member, style: TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}
