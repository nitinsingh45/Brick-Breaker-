import 'dart:async';

import 'package:brick_breaker/ball.dart';
import 'package:brick_breaker/brick.dart';
import 'package:brick_breaker/coverscreen.dart';
import 'package:brick_breaker/gameoverscreen.dart';
import 'package:brick_breaker/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

enum direction { UP, DOWN, LEFT, RIGHT }

class _HomePageState extends State<HomePage> {
  //ball varible
  double ballx = 0;
  double bally = 0;

  double ballXincrements = 0.02;
  double ballYincrements = 0.01;
  var ballXDirection = direction.LEFT;
  var ballYDirection = direction.DOWN;

  //player varibles

  double playerX = -0.2;
  double playerWidth = 0.4; // out of 2

  //brick variable
  static double firstBrickX = -1 + wallGap;
  static double firstBrickY = -0.9;
  static double brickWidth = 0.4;
  static double brickHeight = 0.05;
  static double brickGap = 0.1;
  static double numberOfBricksInRow = 3;

  static double wallGap = 0.5 *
      (2 -
          numberOfBricksInRow * brickWidth -
          (numberOfBricksInRow - 1) * brickGap);
  bool brickBroken = false;

  List MyBricks = [
    //[x,y,broken = true/false]
    [firstBrickX + 0 * (brickWidth + brickGap), firstBrickY, false],
    [firstBrickX + 1 * (brickWidth + brickGap), firstBrickY, false],
    [firstBrickX + 2 * (brickWidth + brickGap), firstBrickY, false],
  ];

  // game settings

  bool hasGamesStarted = false;
  bool isGameOver = false;

  void startGame() {
    hasGamesStarted = true;
    Timer.periodic(Duration(milliseconds: 10), (timer) {
      //update direction
      updateDirection();
      moveBall();

      // check the player is dead
      if (isPlayerDead()) {
        timer.cancel();
        isGameOver = true;
      }
      checkBrokenBricks();
    });
  }

  void checkBrokenBricks() {
    // check for when the ball hits bottom of the brick

    for (int i = 0; i < MyBricks.length; i++) {
      if (ballx >= MyBricks[i][0] &&
          ballx <= MyBricks[i][0] + brickWidth &&
          bally <= MyBricks[i][1] + brickHeight &&
          MyBricks[i][2] == false) {
        setState(() {
          MyBricks[i][2] = true;

          //sinnce the brick is broken update direction of the ball
          //based on which side of the brick it hit
          //to do this calculate the distance of the ball from each of the 4 side
          //the smallest distance is the side of ball has it
          double leftSideDist = (MyBricks[i][0] - ballx).abs();
          double rightSideDist = (MyBricks[i][0] + brickWidth - ballx).abs();
          double topSideDist = (MyBricks[i][1] - bally).abs();
          double bottomSideDist = (MyBricks[i][1] + brickHeight - bally).abs();
          String min =
              findMin(leftSideDist, rightSideDist, topSideDist, bottomSideDist);
          switch (min) {
            case 'left':
              ballXDirection = direction.LEFT;
              break;
            case 'right':
              ballXDirection = direction.RIGHT;
              break;
            case 'up':
              ballYDirection = direction.UP;
              break;
            case 'down':
              ballYDirection = direction.DOWN;
              break;
          }

          // Check if all bricks are broken
          if (areAllBricksBroken()) {
            showWinPopup();
          }

          // if ball hit bottom of the bricks then

          ballYDirection = direction.DOWN;

          // if ball hit top of the brick

          ballYDirection = direction.UP;
          //if the ball hit left side of the brick then
          ballXDirection = direction.LEFT;

          // if the ball hit right side of the brick then

          ballXDirection = direction.RIGHT;
        });
      }
    }
  }

  void showWinPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Congratulations!'),
          content: Text('You won!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  //return the smallest side
  String findMin(double a, double b, double c, double d) {
    List<double> myList = [a, b, c, d];
    double currentMin = a;
    for (int i = 0; i < myList.length; i++) {
      if (myList[i] < currentMin) {
        currentMin = myList[i];
      }
    }
    if ((currentMin - a).abs() < 0.01) {
      return 'left';
    } else if ((currentMin - b).abs() < 0.01) {
      return 'right';
    } else if ((currentMin - c).abs() < 0.01) {
      return 'top';
    } else if ((currentMin - d).abs() < 0.01) {
      return 'bottom';
    }
    return '';
  }

  // check if the brick is broken

  bool isPlayerDead() {
    if (bally >= 1) {
      return true;
    }
    return false;
  }

  //move ball
  void moveBall() {
    setState(() {
      // Move horizontally
      if (ballXDirection == direction.LEFT) {
        ballx -= ballXincrements;
      } else if (ballXDirection == direction.RIGHT) {
        ballx += ballXincrements;
      }

      // Move vertically
      if (ballYDirection == direction.DOWN) {
        bally += ballYincrements;
      } else if (ballYDirection == direction.UP) {
        bally -= ballYincrements;
      }
    });
  }

  void updateDirection() {
    setState(() {
      // ball goes up when it hits player
      if (bally >= 0.9 && ballx >= playerX && ballx <= playerX + playerWidth) {
        ballYDirection = direction.UP;
      }
      //ball goes down when it hits top of the screen
      else if (bally <= -1) {
        ballYDirection = direction.DOWN;
      }

      // ball goes left when it hits right wall

      if (ballx >= 1) {
        ballXDirection = direction.LEFT;
      }
      // ball goes right when it hits left wall
      else if (ballx <= -1.0) {
        ballXDirection = direction.RIGHT;
      }
    });
  }

  void moveLeft() {
    //only move left if mvoing left does't move player off the screen
    setState(() {
      if (!(playerX - 0.02 < -1)) {
        playerX -= 0.02;
      }
    });
  }

  void moveRight() {
    //only move right if mvoing right does't move player off the screen
    setState(() {
      if (!(playerX + 0.02 > 1)) {
        playerX += 0.02;
      }
    });
  }

  bool areAllBricksBroken() {
    for (int i = 0; i < MyBricks.length; i++) {
      if (MyBricks[i][2] == false) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: (event) {
        if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
          moveLeft();
        } else if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
          moveRight();
        }
      },
      child: GestureDetector(
        onTap: startGame,
        onPanUpdate: (details) {
          if (details.delta.dx > 0) {
            moveRight();
          } else if (details.delta.dx < 0) {
            moveLeft();
          }
        },
        child: Scaffold(
          backgroundColor: Colors.deepPurple[100],
          body: Center(
            child: Stack(
              children: [
                //tap to play
                CoverScreen(hasGameStarted: hasGamesStarted),
                GameOverScreen(isGameOver: isGameOver),
                //ball
                MyBall(
                  ballx: ballx,
                  bally: bally,
                ),
                // player
                MyPlayer(
                  playerX: playerX,
                  playerWidth: playerWidth,
                ),

                //bricks
                MyBrick(
                  brickHeight: brickHeight,
                  brickWidth: brickWidth,
                  brickX: MyBricks[0][0],
                  brickY: MyBricks[0][1],
                  brickBroken: MyBricks[0][2],
                ),
                MyBrick(
                  brickHeight: brickHeight,
                  brickWidth: brickWidth,
                  brickX: MyBricks[1][0],
                  brickY: MyBricks[1][1],
                  brickBroken: MyBricks[1][2],
                ),
                MyBrick(
                  brickHeight: brickHeight,
                  brickWidth: brickWidth,
                  brickX: MyBricks[2][0],
                  brickY: MyBricks[2][1],
                  brickBroken: MyBricks[2][2],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
