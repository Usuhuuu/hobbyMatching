import 'package:client/components/home.dart';
import 'package:client/components/menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

class ZoomDrawerExample extends StatefulWidget {
  const ZoomDrawerExample({super.key});

  @override
  _ZoomDrawerExampleState createState() => _ZoomDrawerExampleState();
}

class _ZoomDrawerExampleState extends State<ZoomDrawerExample> {
  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      angle: 0.0,
      mainScreenScale: 0.2,
      menuScreen: const MenuScreen(),
      mainScreen: HomePage(),
      showShadow: true,
      slideWidth: MediaQuery.of(context).size.width * 0.75,
      openCurve: Curves.easeInOut,
      closeCurve: Curves.easeInOut,
    );
  }
}
