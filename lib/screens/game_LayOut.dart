import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pongball_game/screens/ball.dart';
import 'package:pongball_game/screens/bat.dart';
import 'dart:math';

class Pong extends StatefulWidget {
  @override
  _PongState createState() => _PongState();
}
class _PongState extends State<Pong> with SingleTickerProviderStateMixin
{
  double  width = 0;
  double height = 0;
  double posX = 0;
  double posY = 0;
  double batWidth = 0;
  double batHeight = 0;
  double batPosition = 0;
  double randX = 1;
  double randY = 1;
  int score = 0;

  // animation
  late Animation<double> animation;
  late AnimationController controller;
  //direction
  Direction vDir = Direction.down;
  Direction hDir = Direction.right;

  double increment = 5;

  void checkBorders() {
    double diameter = 55;
    if (posX <= 0 && hDir == Direction.left) {
      hDir = Direction.right;
      randX = randomNumber();
    }
    if (posX >= width - diameter && hDir == Direction.right) {
      hDir = Direction.left;
      randX = randomNumber();
    }
    if (posY >= height - diameter - batHeight && vDir == Direction.down) {
//check if the bat is here, otherwise loose
      if (posX >= (batPosition - diameter) && posX <= (batPosition +
          batWidth + diameter)) {
        vDir = Direction.up;
        randY = randomNumber();
        safeSetState(() {
          score++;
        });
      } else {
        controller.stop();
        showMessage(context);
      }
    }
    if (posY <= 0 && vDir == Direction.up) {
      vDir = Direction.down;
      randY = randomNumber();

    }
  }

  void moveBat(DragUpdateDetails update) {
    safeSetState(() {
      batPosition += update.delta.dx;
    });
  }

  void safeSetState(Function function) {
    if (mounted && controller.isAnimating) {
      setState(() {
        function();
      });
    }
  }

  void showMessage(BuildContext context)
  {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Game Over'),
            content: Text('Would you like to play again?'),
            actions: [
              TextButton(
                child: Text('Yes'),
                onPressed: () {
                  setState(() {
                    posX = 0;
                    posY = 0;
                    score = 0;
                  });
                  Navigator.of(context).pop();
                  controller.repeat();
                },
              ),
              TextButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(context).pop();
                  dispose();
                },
              ),

            ],
          );
        });
  }

  double randomNumber()
  {
    var ran =  Random();
    int myNum = ran.nextInt(101);
    return ((50 + myNum) / 100 );

  }


  @override

  void initState()
  {

    controller = AnimationController(

      duration: const Duration(minutes: 5 ),
        vsync: this,

    );
    animation = Tween<double>(begin: 0 , end: 100).animate(controller);
    animation.addListener(() {

      safeSetState(() {
        (hDir == Direction.right)
            ? posX += ((increment * randX).round())
            : posX -= ((increment * randX).round());
        (vDir == Direction.down)
            ? posY += ((increment * randY).round())
            : posY -= ((increment * randY).round());
      });
      checkBorders();
    });

    controller.forward();
      super.initState();

  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  Widget build(BuildContext context) {

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints)
        {
          height = constraints.maxHeight;
          width = constraints.maxWidth ;
          batHeight = (height / 25);
          batWidth = (width / 4);
          return Stack(
            children: [
              Positioned(child: Ball(), top: posY,left: posX,),
              Positioned(
                child: GestureDetector(
                    child: Bat(batHeight , batWidth),

                  onHorizontalDragUpdate: (DragUpdateDetails update)
                  => moveBat(update),

                ),
                left: batPosition,
                bottom: 0,
              ),
              Positioned(
                top: 0,
                right: 24,
                child: Text('Score: ' + score.toString(),
                  style: TextStyle(fontSize: 22 , fontWeight: FontWeight.bold),
                ),
              ),
        ],
      );
    });

  }}



enum Direction { up, down, left, right }