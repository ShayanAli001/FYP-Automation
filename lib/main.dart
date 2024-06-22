import 'package:flutter/material.dart';
import 'package:madproject/HomeScreen.dart';
import 'package:madproject/PhoneAuthentication/OTP.dart';
import 'package:madproject/PhoneAuthentication/phoneAuth.dart';
import 'package:madproject/Screens/OnBoardingScreen.dart';
import 'package:madproject/Screens/studentSignin.dart';
import 'package:madproject/Screens/teacherSignin.dart';
import 'package:madproject/Screens/teacherSignup.dart';
import 'package:madproject/StudentPortal/Notifications.dart';
import 'package:madproject/StudentPortal/atendence.dart';
import 'package:madproject/StudentPortal/chatbox.dart';
import 'package:madproject/StudentPortal/studentDatabase.dart';
import 'package:madproject/StudentPortal/appointment.dart';
import 'package:madproject/StudentPortal/studentPanel.dart';
import 'package:madproject/Teacher/Attendence.dart';
import 'package:madproject/Teacher/display_team.dart';
import 'package:madproject/Teacher/teacherDatabase.dart';
import 'package:madproject/Teacher/teamDatabase.dart';
import 'Screens/SplashScreen.dart';
import 'Screens/StudentorTeacher.dart';
import 'StudentPortal/stdntprofile.dart';
import 'Teacher/teacherProfile.dart';
import 'Teacher/techerPanel.dart';
import 'firebase_options.dart';
import 'PhoneAuthentication/emailAuth.dart';
import 'PhoneAuthentication/phoneAuth.dart';
import 'PhoneAuthentication/newPassword.dart';
import 'PhoneAuthentication/resetSuccessfull.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';




void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen ()
    );
  }
}