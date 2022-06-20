import 'dart:ui';

import 'package:flutter/material.dart';

import '../game.dart';

class GameOver extends StatefulWidget {
  static const String id = "GameOver";
  const GameOver({
    Key? key,
    required this.gameRef,
  }) : super(key: key);

  final ChickenShooteGame gameRef;

  @override
  State<GameOver> createState() => _GameOverState();
}

class _GameOverState extends State<GameOver> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            padding: EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.black38,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.yellow,
                width: 2,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "GAME OVER",
                  style: TextStyle(
                    fontSize: 32,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  Icons.home,
                  color: Colors.green,
                  size: 80,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
