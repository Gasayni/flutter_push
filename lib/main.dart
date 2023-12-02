import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String millisecondsText = "";
  GameState gameState = GameState.readyToStart;
  Timer? waitingTimer;
  Timer? stoppableTimer;
  // Color? color7th;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF282E3D),
      body: Stack(  // если у нас несколько виджетов на экране, то можно их добавить как стек
        children: [
          const Align(
            alignment: Alignment(0, -0.8),
            child: Text(
              "Test your \nreaction speed",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 38,
                  fontWeight: FontWeight.w900),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: ColoredBox(
              color: const Color(0xFF6D6D6D),
              child: SizedBox(
                height: 160,
                width: 300,
                child: Center(
                  child: Text(
                    millisecondsText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          ),
          Align(                                        // выравниватель
            alignment: const Alignment(0, 0.8),
            child: GestureDetector(
              onTap: () => setState(() {
                switch (gameState) {
                  case GameState.readyToStart:
                  // color7th = const Color(0xFF40CA88);
                    gameState = GameState.waiting;
                    millisecondsText = "0 ms";
                    _startWaitingTimer();
                    break;
                  case GameState.waiting:
                  // color7th = const Color(0xFFE0982D);
                    gameState = GameState.canBeStopped;
                    break;
                  case GameState.canBeStopped:
                  // color7th = const Color(0xFFE02D47);
                    gameState = GameState.readyToStart;
                    stoppableTimer?.cancel();
                    break;
                }
              }),
              child: ColoredBox( // создает фоновый цветовой квадратик
                color: _getButtonColor(),
                child: SizedBox( // можно выбрать размер квадратика выше
                  height: 200,
                  width: 200,
                  child: Center( // центрирует
                    child: Text(
                      _getButtonText(),
                      style: const TextStyle(  // определяет стиль текста
                          color: Colors.white,
                          fontSize: 38,
                          fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getButtonText() {
    switch (gameState) {   // так работает Switch
      case GameState.readyToStart:
        return "START";
      case GameState.canBeStopped:
        return "STOP";
      case GameState.waiting:
        return "WAIT";
    }
  }
  Color _getButtonColor() {
    switch (gameState) {   // так работает Switch
      case GameState.readyToStart:
        return const Color(0xFF40CA88);
      case GameState.canBeStopped:
        return const Color(0xFFE02D47);
      case GameState.waiting:
        return const Color(0xFFE0982D);
    }
  }

  void _startWaitingTimer() {
    final int randomMs = Random().nextInt(4000) + 1000;
    Timer(Duration(milliseconds: randomMs), () {
      setState(() {
        gameState = GameState.canBeStopped;
      });
      _startStoppableTimer();
    });
  }

  @override
  void dispose() {
    waitingTimer
        ?.cancel(); // сначала проверяет на 0, если 0 - то выполняться не будет
    super.dispose();
  }

  void _startStoppableTimer() {
    stoppableTimer = Timer.periodic(Duration(microseconds: 16), (timer) {
      setState(() {                  // в каждом методе нужно добавлять этот метод, чтобы просходили изменения
        millisecondsText = "${timer.tick * 16} ms";
      });
    });
  }
}

enum GameState { readyToStart, waiting, canBeStopped }
