import 'package:flutter/material.dart';

class MyPlayer extends StatelessWidget {
  final playerX;
  final playerWidth; //out of 2;

  MyPlayer({this.playerX, this.playerWidth});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment:
          Alignment((2 * playerX + playerWidth) / (2 - playerWidth), 0.9),
      child: ClipRRect(
        // the ClipRRect widget clips its child using a rounded rectangle. The "R" in ClipRRect stands for "rounded
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 10,
          width: MediaQuery.of(context).size.width * playerWidth / 2,
          color: Colors.deepPurple,
        ),
      ),
    );
  }
}
