import 'package:flutter/material.dart';

class HobbyModel {
  String hobbyName; // Name of the hobby hobby
  IconData hobbyIcon; // Icon representing the hobby hobby
  List<String> subHobbies; // List of sub-hobbies for the hobby
  String hobbyDescription; // hobbyDescription of the hobby

  HobbyModel({
    required this.hobbyName,
    required this.hobbyIcon,
    required this.subHobbies,
    required this.hobbyDescription,
  });

  // Static method to get all the hobby hobbyModel with sub-hobbies and hobbyDescriptions
  static List<HobbyModel> getHobbyModel() {
    List<HobbyModel> hobbyModel = [];

    // Adding "Mental Hobbies"
    hobbyModel.add(
      HobbyModel(
        hobbyName: "Mental Hobbies",
        hobbyIcon: Icons.psychology,
        subHobbies: ['Reading', 'Meditation', 'Puzzles', 'Writing'],
        hobbyDescription:
            "Activities that stimulate your mind and enhance cognitive abilities.",
      ),
    );

    // Adding "Physical Hobbies"
    hobbyModel.add(
      HobbyModel(
        hobbyName: "Physical Hobbies",
        hobbyIcon: Icons.directions_run,
        subHobbies: ['Running', 'Yoga', 'Weightlifting', 'Cycling'],
        hobbyDescription:
            "Activities that engage physical fitness and improve health.",
      ),
    );

    // Adding "Creative Hobbies"
    hobbyModel.add(
      HobbyModel(
        hobbyName: "Creative Hobbies",
        hobbyIcon: Icons.brush,
        subHobbies: ['Painting', 'Photography', 'Sculpture', 'Writing'],
        hobbyDescription:
            "Activities that encourage creativity and artistic expression.",
      ),
    );

    // Adding "Musical Hobbies"
    hobbyModel.add(
      HobbyModel(
        hobbyName: "Musical Hobbies",
        hobbyIcon: Icons.music_note,
        subHobbies: [
          'Playing Instruments',
          'Singing',
          'Composing',
          'Listening to Music'
        ],
        hobbyDescription:
            "Activities related to music, playing instruments, or listening.",
      ),
    );

    // Adding "Collective Hobbies"
    hobbyModel.add(
      HobbyModel(
        hobbyName: "Collective Hobbies",
        hobbyIcon: Icons.groups,
        subHobbies: ['Team Sports', 'Board Games', 'Group Discussions'],
        hobbyDescription:
            "Activities that involve social interaction and teamwork.",
      ),
    );

    // Adding "Games & Puzzles"
    hobbyModel.add(
      HobbyModel(
        hobbyName: "Games & Puzzles",
        hobbyIcon: Icons.extension,
        subHobbies: ['Chess', 'Sudoku', 'Card Games', 'Jigsaw Puzzles'],
        hobbyDescription:
            "Activities that involve strategic thinking and problem solving.",
      ),
    );

    return hobbyModel;
  }
}
