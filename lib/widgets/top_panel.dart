import 'dart:async';

import 'package:flutter/material.dart';

import '../game.dart';
import '../spref/spref.dart';

class TopPanelWidget extends StatefulWidget {
  static const String id = "Score";
  final ChickenShooteGame gameRef;

  const TopPanelWidget({
    Key? key,
    required this.gameRef,
  }) : super(key: key);

  @override
  State<TopPanelWidget> createState() => _TopPanelWidgetState();
}

class _TopPanelWidgetState extends State<TopPanelWidget> {
  int? timeRemaining;

  late Timer timer;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      int? seconds = await SPref.instance.getInt("seconds");

      if (seconds == null) {
        SPref.instance.setInt("seconds", 15);
        seconds = 15;
      }

      timeRemaining = seconds * 1000;

      timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
        setState(() {
          timeRemaining = timeRemaining! - 10;
        });

        if (timeRemaining! <= 0) {
          timer.cancel();
          widget.gameRef.endGame();
        }
      });
    });
  }

  @override
  void dispose() {
    if (timer.isActive) {
      // print("cancelling timer");
      timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.yellow,
                width: 2,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.timer_outlined,
                  color: Colors.yellow,
                  size: 32,
                ),
                Text(
                  timeRemaining == null
                      ? "0.00"
                      : "${(timeRemaining! / 1000).toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 32,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(
                  Icons.home_outlined,
                  color: Colors.green,
                  size: 36,
                ),
              ),
              Text(
                "${widget.gameRef.score} ⭐",
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.green,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
