import 'package:brick_breaker/homepage.dart';
import 'package:flutter/material.dart';
// Import your actual game screen file

class GameOverScreen extends StatefulWidget {
  final bool isGameOver;

  GameOverScreen({required this.isGameOver});

  @override
  State<GameOverScreen> createState() => _GameOverScreenState();
}

class _GameOverScreenState extends State<GameOverScreen> {
  @override
  Widget build(BuildContext context) {
    return widget.isGameOver
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment(0, -0.3),
                child: Text(
                  'G A M E   O V E R',
                  style: TextStyle(fontSize: 30),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Navigate to a new instance of the game screen
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ),
                  );
                },
                child: Text(
                  'Play Again',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          )
        : Container();
  }
}
