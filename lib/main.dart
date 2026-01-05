import 'package:flutter/material.dart';
import 'models/game_settings.dart';
import 'models/chess_piece_data.dart';
import 'logic/chess_engine.dart';
import 'widgets/chess_board_view.dart';
import 'widgets/modals.dart';
import 'dart:math';

void main() => runApp(const MaestroChessApp());

class MaestroChessApp extends StatelessWidget {
  const MaestroChessApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    theme: ThemeData.dark(),
    home: const GameController(),
  );
}

class GameController extends StatefulWidget {
  const GameController({super.key});
  @override
  State<GameController> createState() => _GameControllerState();
}

class _GameControllerState extends State<GameController> {
  String view = 'menu';
  GameSettings settings = GameSettings();
  Map<Offset, Piece> pieces = {};
  Offset? selectedPos;
  List<Offset> validTargets = [];
  int score = 0;
  int lives = 3;

  void startGame() {
    setState(() {
      view = 'playing';
      score = 0;
      lives = settings.maxLives;
      _generateLevel();
    });
  }

  void _generateLevel() {
    Map<Offset, Piece> newPieces = {};
    Random rand = Random();
    bool solvable = false;
    while (!solvable) {
      newPieces.clear();
      List<Offset> spots = List.generate(64, (i) => Offset((i % 8).toDouble(), (i ~/ 8).toDouble()))..shuffle();
      for (int i = 0; i < 8; i++) {
        newPieces[spots[i]] = Piece(type: i == 0 ? 'king' : ['queen','rook','bishop','knight','pawn'][rand.nextInt(5)], color: settings.pieceColor);
      }
      solvable = ChessEngine.isSolvable(newPieces);
    }
    setState(() => pieces = newPieces);
  }

  void _onSquareTap(Offset pos) {
    if (selectedPos != null && validTargets.contains(pos)) {
      setState(() {
        pieces[pos] = pieces[selectedPos!]!.captureCount == 0 ? pieces[selectedPos]! : pieces[selectedPos]!.copy();
        pieces[pos]!.captureCount++;
        pieces.remove(selectedPos);
        selectedPos = null;
        validTargets = [];
        if (pieces.length == 1) {
          score++;
          _generateLevel();
        }
      });
    } else if (pieces.containsKey(pos) && pieces[pos]!.captureCount < 3) {
      setState(() {
        selectedPos = pos;
        validTargets = pieces.keys.where((t) => t != pos && ChessEngine.canCapture(pos, t, pieces[pos]!.type, pieces)).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (view == 'menu') {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("MAESTRO CHESS", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.amber)),
              const SizedBox(height: 40),
              ElevatedButton(onPressed: startGame, child: const Text("START GAME")),
            ],
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text("Score: $score | Lives: $lives"), leading: IconButton(icon: const Icon(Icons.exit_to_app), onPressed: () => setState(() => view = 'menu'))),
      body: Center(child: ChessBoardView(pieces: pieces, selectedPos: selectedPos, validTargets: validTargets, theme: settings.boardTheme, onSquareTap: _onSquareTap)),
    );
  }
}