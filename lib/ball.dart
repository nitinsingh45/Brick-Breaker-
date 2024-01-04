import 'package:flutter/material.dart';

class MyBall extends StatelessWidget {
  final ballx;
  final bally;

  MyBall({this.ballx, this.bally});
  //const MyBall({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(ballx, bally),
      child: Container(
        height: 15,
        width: 15,
        decoration:
            BoxDecoration(color: Colors.deepPurple, shape: BoxShape.circle),
      ),
    );
  }
}
