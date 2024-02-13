import 'package:flutter/material.dart';
import 'package:m2l/pages/contactPage.dart';
import 'package:m2l/pages/homePage.dart';
import 'package:m2l/pages/profilPage.dart';
import 'package:rolling_bottom_bar/rolling_bottom_bar.dart';
import 'package:rolling_bottom_bar/rolling_bottom_bar_item.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: PageView(
          controller: _pageController,
          children: const <Widget>[
            HomePage(),
            ContactPage(),
            ProfilPage(),
          ],
        ),
        extendBody: true,
        bottomNavigationBar: RollingBottomBar(
          controller: _pageController,
          items: [
            RollingBottomBarItem(Icons.home, label: 'Home'),
            RollingBottomBarItem(Icons.group, label: 'Contact'),
            RollingBottomBarItem(Icons.person, label: 'Profil'),
          ],
          onTap: (index) {
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOut,
            );
          },
          color: Color.fromARGB(255, 255, 209, 5), // Background color of the bottom bar
          itemColor: Colors.black, // Color for inactive items
          activeItemColor: Colors.black, // Color for active item
          enableIconRotation: true,
        ),
      ),
    );
  }
}