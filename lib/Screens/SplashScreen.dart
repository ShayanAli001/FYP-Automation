import 'package:flutter/material.dart';
import 'OnBoardingScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState()
  {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => OnboardingScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[600],
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(150),
              ),
            ),
            RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                children: <TextSpan>[
                  TextSpan(text: 'Mentor', style: TextStyle(color: Colors.brown[600])),
                  TextSpan(text: 'Mate', style: TextStyle(color: Colors.blue[900])),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
