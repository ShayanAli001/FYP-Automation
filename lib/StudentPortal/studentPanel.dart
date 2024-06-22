// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path/path.dart';
// import 'package:madproject/HomeScreen.dart';
//
// class StudentPanel extends StatefulWidget {
//   final String? email;
//   StudentPanel(this.email);
//
//   @override
//   _StudentPanelState createState() => _StudentPanelState();
// }
//
// class _StudentPanelState extends State<StudentPanel> {
//   Future<Map<String, dynamic>> _fetchStudentInfo() async {
//     try {
//       final snapshot = await FirebaseFirestore.instance
//           .collection('studentinfo')
//           .where('email', isEqualTo: widget.email)
//           .get();
//
//       if (snapshot.docs.isNotEmpty) {
//         return snapshot.docs.first.data();
//       } else {
//         return {};
//       }
//     } catch (e) {
//       throw Exception('Error fetching student info: $e');
//     }
//   }
//
//   Future<void> _uploadImage() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//
//     if (pickedFile != null) {
//       File file = File(pickedFile.path);
//       String fileName = basename(file.path);
//
//       try {
//         // Upload image to Firebase Storage
//         await FirebaseStorage.instance.ref('uploads/$fileName').putFile(file);
//         // Get the download URL of the uploaded image
//         String downloadURL = await FirebaseStorage.instance.ref('uploads/$fileName').getDownloadURL();
//
//         // Update Firestore with the new image URL
//         final studentInfoSnapshot = await FirebaseFirestore.instance
//             .collection('studentinfo')
//             .where('email', isEqualTo: widget.email)
//             .get();
//
//         if (studentInfoSnapshot.docs.isNotEmpty) {
//           String documentId = studentInfoSnapshot.docs.first.id;
//           await FirebaseFirestore.instance
//               .collection('studentinfo')
//               .doc(documentId)
//               .update({'imageUrl': downloadURL});
//
//           setState(() {}); // Refresh UI
//         }
//       } catch (e) {
//         print('Error uploading image: $e');
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[300],
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.grey[600]),
//           onPressed: () {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (context) => HomeScreen(widget.email)),
//             );
//           },
//         ),
//         title: Center(child: Text('Student Panel')),
//         backgroundColor: Colors.black,
//         foregroundColor: Colors.white,
//       ),
//       body: FutureBuilder<Map<String, dynamic>>(
//         future: _fetchStudentInfo(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text('No data found for this email'));
//           } else {
//             final studentInfo = snapshot.data!;
//             final name = studentInfo['name'] ?? 'No Name';
//             final imageUrl = studentInfo['imageUrl'] ?? '';
//
//             return SingleChildScrollView(
//               child: Column(
//                 children: [
//                   SizedBox(height: 20),
//                   Stack(
//                     children: [
//                       CircleAvatar(
//                         radius: 50,
//                         backgroundImage: imageUrl.isNotEmpty
//                             ? NetworkImage(imageUrl)
//                             : AssetImage('assets/images/default_profile.png') as ImageProvider,
//                         backgroundColor: Colors.black,
//                         onBackgroundImageError: (exception, stackTrace) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(content: Text('Error loading profile image')),
//                           );
//                         },
//                         child: imageUrl.isEmpty
//                             ? Icon(Icons.person, size: 50, color: Colors.white)
//                             : null,
//                       ),
//                       Positioned(
//                         bottom: 0,
//                         right: 0,
//                         child: IconButton(
//                           icon: Icon(Icons.camera_alt, color: Colors.grey[600]),
//                           onPressed: _uploadImage,
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 10),
//                   Text(
//                     name,
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Card(
//                       child: Column(
//                         children: [
//                           ListTile(
//                             title: Text('Project Progress'),
//                             subtitle: LinearProgressIndicator(
//                               value: 0.5,
//                               backgroundColor: Colors.grey[300],
//                               color: Colors.green,
//                             ),
//                             trailing: Text('50%'),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Column(
//                               children: [
//                                 Row(
//                                   children: [
//                                     Expanded(child: Text('Task: Add Scheduling Module')),
//                                   ],
//                                 ),
//                                 Row(
//                                   children: [
//                                     Expanded(
//                                       child: Text('Assigned To'),
//                                     ),
//                                     Expanded(
//                                       child: Text(
//                                         name,
//                                         textAlign: TextAlign.end,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 ElevatedButton(
//                                   onPressed: () {},
//                                   child: Text('Show Details'),
//                                 ),
//                                 Divider(),
//                                 Row(
//                                   children: [
//                                     Expanded(child: Text('Topic: Management System')),
//                                   ],
//                                 ),
//                                 Row(
//                                   children: [
//                                     Expanded(
//                                       child: Text('Fuzail Raza Team'),
//                                     ),
//                                     Expanded(
//                                       child: Text(
//                                         'Project PDF Link',
//                                         textAlign: TextAlign.end,
//                                         style: TextStyle(color: Colors.red),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
// }
