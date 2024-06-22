import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class teacherDatabase extends StatefulWidget {
  @override
  _TeacherDatabaseState createState() => _TeacherDatabaseState();
}

class _TeacherDatabaseState extends State<teacherDatabase> {
  final _formKey = GlobalKey<FormState>();

  String _teacherId = '';
  String _teacherName = '';
  String _teacherRole = '';

  Future<void> _saveTeacherData() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Teacher teacher = Teacher(
        id: _teacherId,
        name: _teacherName,
        role: _teacherRole,
      );

      await FirebaseFirestore.instance
          .collection('teachersinfo')
          .doc(_teacherId)
          .set(teacher.toMap());

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data Added Successfully')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[600],
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text('Teachers Database'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Teacher ID',
                    hintText: 'Enter Teacher ID',
                    prefixIcon: Icon(Icons.badge),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter teacher ID';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _teacherId = value!;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Teacher Name',
                    hintText: 'Enter Teacher Name',
                    prefixIcon: Icon(Icons.person),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter teacher name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _teacherName = value!;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Teacher Role',
                    hintText: 'Enter Teacher Role',
                    prefixIcon: Icon(Icons.work),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter teacher role';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _teacherRole = value!;
                  },
                ),
                SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: _saveTeacherData,
                    child: Text('Save Teacher Data'),
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

class Teacher {
  final String id;
  final String name;
  final String role;

  Teacher({
    required this.id,
    required this.name,
    required this.role,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'role': role,
    };
  }
}
