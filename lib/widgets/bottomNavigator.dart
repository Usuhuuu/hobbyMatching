import 'package:circular_bottom_navigation/tab_item.dart';
import 'package:client/components/zoom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
import 'package:client/components/dashboard.dart';

// Global controller for the bottom navigation
final CircularBottomNavigationController navigationController =
    CircularBottomNavigationController(0);

// Global tab items list
final List<TabItem> tabItems = List.of([
  TabItem(Icons.home, "Home", Colors.blueAccent,
      labelStyle: const TextStyle(fontWeight: FontWeight.normal)),
  TabItem(Icons.search, "Search", Colors.blueAccent,
      labelStyle: const TextStyle(
          color: Colors.blueAccent, fontWeight: FontWeight.bold)),
  TabItem(Icons.person, "Profile", Colors.blueAccent,
      labelStyle: const TextStyle(
          color: Colors.blueAccent, fontWeight: FontWeight.bold)),
]);

// Global function to generate the bottom navigator
CircularBottomNavigation bottomNavigator(BuildContext context) {
  return CircularBottomNavigation(
    tabItems,
    controller: navigationController,
    barBackgroundColor: Colors.white,
    normalIconColor: Colors.blueAccent,
    selectedCallback: (selectedPosition) {
      if (selectedPosition == 0) {
        Navigator.pushReplacement(
            context,
            PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) =>
                    const ZoomDrawerExample(),
                transitionsBuilder: (context, animation1, animation2, child) {
                  const begin = Offset(0.0, 1.0);
                  const end = Offset.zero;
                  const curve = Curves.easeInOut;

                  var tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: curve));
                  var offsetAnimation = animation1.drive(tween);
                  return SlideTransition(
                      position: offsetAnimation, child: child);
                }));
      } else if (selectedPosition == 2) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashboardAndSignUp()),
        );
      }
    },
  );
}
