import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StdntDatabase extends StatefulWidget {
  @override
  _Database createState() => _Database();
}

class _Database extends State<StdntDatabase> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _attendanceController = TextEditingController();
  final TextEditingController _supervisorNameController = TextEditingController();
  final TextEditingController _supervisorRoleController = TextEditingController();
  final TextEditingController _areaOfResearchController = TextEditingController();
  final TextEditingController _supervisedByController = TextEditingController();
  final TextEditingController _topicNameController = TextEditingController();
  final TextEditingController _teamMembersController = TextEditingController();
  final TextEditingController _projectController = TextEditingController();

  Future<void> _uploadData() async {
    if (_emailController.text.isEmpty) {
      print('Email is required.');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email is required.')),
      );
      return;
    }

    try {
      // Get reference to the document
      DocumentReference docRef = FirebaseFirestore.instance.collection('studentinfo').doc(_emailController.text);
      DocumentSnapshot docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        // Update existing document
        Map<String, dynamic> updateData = {};

        if (_nameController.text.isNotEmpty) updateData['name'] = _nameController.text;
        if (_roleController.text.isNotEmpty) updateData['role'] = _roleController.text;
        if (_attendanceController.text.isNotEmpty) updateData['attendancePercentage'] = _attendanceController.text;
        if (_areaOfResearchController.text.isNotEmpty) updateData['areaOfResearch'] = _areaOfResearchController.text;
        if (_supervisedByController.text.isNotEmpty) updateData['supervisedBy'] = _supervisedByController.text;
        if (_topicNameController.text.isNotEmpty) updateData['topicName'] = _topicNameController.text;
        if (_projectController.text.isNotEmpty) updateData['projectId'] = _projectController.text;

        if (_supervisorNameController.text.isNotEmpty) {
          updateData['supervisorName'] = FieldValue.arrayUnion([_supervisorNameController.text]);
        }

        if (_supervisorRoleController.text.isNotEmpty) {
          updateData['supervisorRole'] = FieldValue.arrayUnion([_supervisorRoleController.text]);
        }

        if (_teamMembersController.text.isNotEmpty) {
          List<String> teamMembers = _teamMembersController.text.split(',');
          updateData['teamMembers'] = FieldValue.arrayUnion(teamMembers);
        }

        if (updateData.isNotEmpty) {
          await docRef.update(updateData);
          print('Data updated successfully');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Data updated successfully.')),
          );
        } else {
          print('No data to update.');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No data to update.')),
          );
        }
      } else {
        // Validate all fields for new document creation
        if (_nameController.text.isEmpty ||
            _roleController.text.isEmpty ||
            _attendanceController.text.isEmpty ||
            _supervisorNameController.text.isEmpty ||
            _supervisorRoleController.text.isEmpty ||
            _areaOfResearchController.text.isEmpty ||
            _supervisedByController.text.isEmpty ||
            _topicNameController.text.isEmpty ||
            _teamMembersController.text.isEmpty ||
            _projectController.text.isEmpty) {
          print('All fields are required for new document.');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('All fields are required for new document.')),
          );
          return;
        }

        List<String> teamMembers = _teamMembersController.text.split(',');

        await docRef.set({
          'name': _nameController.text,
          'email': _emailController.text,
          'role': _roleController.text,
          'attendancePercentage': _attendanceController.text,
          'supervisorName': [_supervisorNameController.text],
          'supervisorRole': [_supervisorRoleController.text],
          'areaOfResearch': _areaOfResearchController.text,
          'supervisedBy': _supervisedByController.text,
          'topicName': _topicNameController.text,
          'teamMembers': teamMembers,
          'projectId': _projectController.text,
        });

        print('Data uploaded successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data uploaded successfully.')),
        );
      }
    } catch (e) {
      print('Error uploading data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading data.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Data'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Enter your name'),
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Enter your email (Gmail)'),
              ),
              TextField(
                controller: _roleController,
                decoration: InputDecoration(labelText: 'Enter your role'),
              ),
              TextField(
                controller: _attendanceController,
                decoration: InputDecoration(labelText: 'Enter your attendance percentage'),
              ),
              TextField(
                controller: _supervisorNameController,
                decoration: InputDecoration(labelText: 'Enter supervisor name'),
              ),
              TextField(
                controller: _supervisorRoleController,
                decoration: InputDecoration(labelText: 'Enter supervisor role'),
              ),
              TextField(
                controller: _areaOfResearchController,
                decoration: InputDecoration(labelText: 'Enter area of research'),
              ),
              TextField(
                controller: _supervisedByController,
                decoration: InputDecoration(labelText: 'Enter supervised by'),
              ),
              TextField(
                controller: _topicNameController,
                decoration: InputDecoration(labelText: 'Enter topic name'),
              ),
              TextField(
                controller: _teamMembersController,
                decoration: InputDecoration(labelText: 'Enter team members (comma separated)'),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _projectController,
                decoration: InputDecoration(labelText: 'Enter Your Project ID'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _uploadData,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
