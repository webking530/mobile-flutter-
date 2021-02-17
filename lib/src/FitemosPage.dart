import 'package:flutter/material.dart';
import 'package:fitemos/src/workout/workoutPage.dart';
import 'package:fitemos/src/benchMark/benchMark.dart';
import 'package:fitemos/src/shop/shopPage.dart';
import 'package:fitemos/src/blog/blogPage.dart';
import 'package:fitemos/src/account/accountPage.dart';
import 'package:google_fonts/google_fonts.dart';

class FitnessNav extends StatefulWidget {
  FitnessNav({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _fitnessNavState createState() => _fitnessNavState();
}

class _fitnessNavState extends State<FitnessNav> {

  int _currentIndex = 0;
  final List<Widget> _children = [
    WorkoutPage(),
    BenchMark(),
    Blog(),
    Shop(),
    AccountPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: onTabTapped, // new
        currentIndex: _currentIndex,
        selectedItemColor: Color(0xffAFCA32),
        selectedFontSize: 12,
        unselectedItemColor: Color(0xffB9B7B7),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.favorite_border),
            title: new Text('Workout', style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w500)),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.insert_chart),
            title: new Text('Benchmarks', style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w500)),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.open_in_browser),
              title: Text('Blog', style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w500)),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_basket),
              title: Text('Shop', style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w500)),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('Cuenta', style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w500)),
          )
        ],
      ),
    );
  }
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
