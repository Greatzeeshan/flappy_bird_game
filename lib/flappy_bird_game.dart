
import 'dart:async';

import 'package:flutter/material.dart';

import 'barrier_widget.dart';
import 'bird.dart';

class FlabbyBird extends StatefulWidget {
  const FlabbyBird({super.key,});

  @override
  State<FlabbyBird> createState() => _FlabbyBirdState();
}

class _FlabbyBirdState extends State<FlabbyBird> {
  int score = 0;

  static double birdY = 0;
  double initialPos = birdY;
  double height = 0;
  double time = 0;
  bool gameHasStarted = false;

  /// how strong the gravity is
  double velocity = 3.5;

  /// how strong the jump is
  double gravity = -5.9;

  double birdWidth = 0.1;
  double birdHeight = 0.1;

  /// Barrier variables
  static List<double> barrierX = [2, 2 + 1.5];
  static double barrierWidth = 0.5;
  List<List<double>> barrierHeight = [
    [0.6, 0.4],
    [0.4, 0.6],
  ];

  void startGame() {
    gameHasStarted = true;
    Timer.periodic(const Duration(milliseconds: 20), (timer) {
      height = gravity * time * time + velocity * time;
      setState(() {
        birdY = initialPos - height;
      });
      if (birdIdDead()) {
        timer.cancel();
        _showDialog();
      }

      moveMap();

      time += 0.01;
    });
  }

  jump() {
    setState(() {
      time = 0;
      initialPos = birdY;
    });
  }

  moveMap() {
    for (int i = 0; i < barrierX.length; i++) {
      setState(() {
        barrierX[i] -= 0.015;
      });

      if (barrierX[i] < -1.5) {
        barrierX[i] += 3;
        score++;
      }
    }
  }

  bool birdIdDead() {
    if (birdY < -1 || birdY > 1) {
      return true;
    }

    for (int i = 0; i < barrierX.length; i++) {
      if (barrierX[i] <= birdWidth &&
          barrierX[i] + barrierWidth >= -birdWidth &&
          (birdY <= -1 + barrierHeight[i][0] ||
              birdY + birdHeight >= 1 - barrierHeight[i][1])) {
        return true;
      }
    }

    return false;
  }

  resetGame() {
    Navigator.pop(context);
    setState(() {
      score = 0;
      barrierX = [2, 2 + 1.5];
      barrierHeight = [
        [0.6, 0.4],
        [0.4, 0.6],
      ];
      gameHasStarted = false;
      birdY = 0;
      time = 0;
      initialPos = birdY;
    });
  }

  void _showDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Center(
              child: Text(
                "Game Over!",
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    resetGame();
                  },
                  child: const Text("Restart")),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF764b30),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Flappy bird",
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 6,
              child: GestureDetector(
                onTap: () => gameHasStarted ? jump() : startGame(),
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.cyan,
                        // image: DecorationImage(
                        //   image: AssetImage(
                        //     "assets/gifs/file.gif",
                        //   ),
                        //   fit: BoxFit.fill,
                        // )
                    ),
                    child: Stack(
                      children: [
                        /// Bird
                        BirdWidget(
                          birdY: birdY,
                          birdWidth: birdWidth,
                          birdHeight: birdHeight,
                        ),

                        /// Barrier list
                        BarrierWidget(
                          barrierX: barrierX[0],
                          barrierWidth: barrierWidth,
                          barrierHeight: barrierHeight[0][0],
                          isThisBottomBarrier: false,
                        ),
                        BarrierWidget(
                          barrierX: barrierX[0],
                          barrierWidth: barrierWidth,
                          barrierHeight: barrierHeight[0][1],
                          isThisBottomBarrier: true,
                        ),
                        BarrierWidget(
                          barrierX: barrierX[1],
                          barrierWidth: barrierWidth,
                          barrierHeight: barrierHeight[1][0],
                          isThisBottomBarrier: false,
                        ),
                        BarrierWidget(
                          barrierX: barrierX[1],
                          barrierWidth: barrierWidth,
                          barrierHeight: barrierHeight[1][1],
                          isThisBottomBarrier: true,
                        ),

                        /// tap to play
                        Container(
                          alignment: const Alignment(0, -0.5),
                          child: Text(
                            gameHasStarted ? " " : "T A P  T O  P L A Y",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                color: const Color(0xFF764b30),
                alignment: Alignment.center,
                child: Text(
                  "Score : $score",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
