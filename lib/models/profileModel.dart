import 'package:client/components/dashboard.dart';
import 'package:client/components/profile/settings.dart';
import 'package:client/components/profile/userNestedScreen/favoriteHobbiesScreen.dart';
import 'package:client/components/profile/userNestedScreen/friendsScreen.dart';
import 'package:client/components/profile/userNestedScreen/helpScreen.dart';
import 'package:client/components/profile/userNestedScreen/userInfoScreen.dart';
import 'package:flutter/material.dart';

class ProfileModel {
  String components;
  IconData iconText;
  Widget destinationScreen;

  ProfileModel({
    required this.components,
    required this.iconText,
    required this.destinationScreen,
  });

  static List<ProfileModel> getProfileComponents() {
    List<ProfileModel> profileComponents = [];

    profileComponents.add(ProfileModel(
      components: "User Information",
      iconText: Icons.account_circle,
      destinationScreen: UserInfoScreen(),
    ));
    profileComponents.add(ProfileModel(
      components: "Favorite Hobbies",
      iconText: Icons.favorite,
      destinationScreen: FavoriteHobbiesScreen(),
    ));
    profileComponents.add(ProfileModel(
      components: "Friends",
      iconText: Icons.people,
      destinationScreen: FriendsScreen(),
    ));
    profileComponents.add(ProfileModel(
      components: "Settings",
      iconText: Icons.settings,
      destinationScreen: SettingsScreen(),
    ));
    profileComponents.add(ProfileModel(
      components: "Help",
      iconText: Icons.help,
      destinationScreen: HelpScreen(),
    ));

    return profileComponents;
  }
}
