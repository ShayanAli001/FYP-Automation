import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class teamDatabase extends StatefulWidget {
  @override
  _TeamDatabaseState createState() => _TeamDatabaseState();
}

class _TeamDatabaseState extends State<teamDatabase> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _teamIdController = TextEditingController();
  final TextEditingController _teamController = TextEditingController();
  final TextEditingController _topicController = TextEditingController();
  final TextEditingController _membersController = TextEditingController();
  final TextEditingController _projectLinkController = TextEditingController();
  final TextEditingController _progressController = TextEditingController();
  final TextEditingController _previousTasksController = TextEditingController();

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final teamId = _teamIdController.text;
        final team = _teamController.text;
        final topic = _topicController.text;
        final members = _membersController.text.split(',').map((e) => e.trim()).toList();
        final projectLink = _projectLinkController.text;
        final progress = _progressController.text.split(',').map((e) => e.trim()).toList();
        final previousTasks = _previousTasksController.text.split(',').map((e) => e.trim()).toList();

        await FirebaseFirestore.instance.collection('teams').doc(teamId).set({
          'team': team,
          'topic': topic,
          'members': members,
          'projectLink': projectLink,
          'progress': progress,
          'previousTasks': previousTasks,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data saved successfully!')),
        );

        _formKey.currentState!.reset();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save data: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Team Information'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _teamIdController,
                  decoration: InputDecoration(labelText: 'Team ID'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the team ID';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _teamController,
                  decoration: InputDecoration(labelText: 'Team Name'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the team name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _topicController,
                  decoration: InputDecoration(labelText: 'Project Topic'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the topic';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _membersController,
                  decoration: InputDecoration(labelText: 'Members (comma-separated)'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the members';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _projectLinkController,
                  decoration: InputDecoration(labelText: 'Project Link'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the project link';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _progressController,
                  decoration: InputDecoration(labelText: 'Progress (comma-separated tasks with dates)'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the progress tasks';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _previousTasksController,
                  decoration: InputDecoration(labelText: 'Previous Tasks (comma-separated)'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the previous tasks';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Submit'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
