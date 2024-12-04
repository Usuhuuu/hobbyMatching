import 'package:client/components/home.dart';
import 'package:client/components/menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

class ZoomDrawerExample extends StatelessWidget {
  const ZoomDrawerExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      angle: 0.0,
      mainScreenScale: 0.2,
      menuScreen: const MenuScreen(), // Your custom menu screen
      mainScreen: HomePage(), // The primary content of the app
    );
  }
}
