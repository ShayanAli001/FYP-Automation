import 'package:flutter/material.dart';
import 'package:madproject/Screens/StudentorTeacher.dart';
import 'studentSignin.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < 3; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: isActive ? 24.0 : 16.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.grey[600] : Colors.grey[300],
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _onNextPressed() {
    if (_currentPage != 2) {
      _pageController.nextPage(
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => StudentTeacher()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[600],
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                children: <Widget>[
                  OnboardingPage(
                    title: 'Welcome to MentorMate',
                    description: 'Get in touch with teacher and students', image: '',
                  ),
                  OnboardingPage(
                    title: 'Connect directly with Each other',
                    description: 'Both teacher and student can connect with each other', image: '',
                  ),
                  OnboardingPage(
                    title: 'Check your Attendance Details',
                    description: 'Both teacher and student can connect with each other', image: '',
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildPageIndicator(),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: _onNextPressed,
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                minimumSize: Size(150, 50), // Size of the button
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              child: Text(
                'Next',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                ),
              ),
            ),
            SizedBox(height: 40.0),
          ],
        ),
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String image;
  final String title;
  final String description;

  OnboardingPage({required this.image, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 20.0),
          RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
              children: <TextSpan>[
                TextSpan(text: 'Mentor', style: TextStyle(color: Colors.brown[600])),
                TextSpan(text: 'Mate', style: TextStyle(color: Colors.blue[900])),
              ],
            ),
          ),
          SizedBox(height: 20.0),
          Text(
            title,
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.black),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10.0),
          Text(
            description,
            style: TextStyle(fontSize: 16.0, color: Colors.black),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
