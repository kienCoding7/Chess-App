import 'package:flutter/material.dart';
import '../models/chess_piece_data.dart';

class PieceWidget extends StatelessWidget {
  final Piece piece;
  final bool isSelected;
  final bool canBeCaptured;

  const PieceWidget({super.key, required this.piece, this.isSelected = false, this.canBeCaptured = false});

  @override
  Widget build(BuildContext context) {
    final Map<String, String> symbols = {
      'king': '♚', 'queen': '♛', 'rook': '♜', 'bishop': '♝', 'knight': '♞', 'pawn': '♟'
    };

    return Stack(
      alignment: Alignment.center,
      children: [
        if (isSelected) Container(decoration: BoxDecoration(border: Border.all(color: Colors.greenAccent, width: 3), color: Colors.greenAccent.withOpacity(0.2))),
        if (canBeCaptured) Container(color: Colors.red.withOpacity(0.3)),
        Text(
          symbols[piece.type]!,
          style: TextStyle(
            fontSize: 40,
            color: piece.color == 'white' ? Colors.white : Colors.black,
            shadows: const [Shadow(blurRadius: 2, color: Colors.black26)],
          ),
        ),
        Positioned(
          bottom: 4,
          child: Row(
            children: List.generate(3, (i) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 1),
              width: 5, height: 5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: i < (3 - piece.captureCount) ? Colors.amber : Colors.grey[800],
              ),
            )),
          ),
        )
      ],
    );
  }
}