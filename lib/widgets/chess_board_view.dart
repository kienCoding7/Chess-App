import 'package:flutter/material.dart';
import 'package:voice_chess/widgets/piece_widgets.dart';
import '../models/chess_piece_data.dart';

class ChessBoardView extends StatelessWidget {
  final Map<Offset, Piece> pieces;
  final Offset? selectedPos;
  final List<Offset> validTargets;
  final String theme;
  final Function(Offset) onSquareTap;

  const ChessBoardView({super.key, required this.pieces, this.selectedPos, required this.validTargets, required this.theme, required this.onSquareTap});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.brown[900]!, width: 4)),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
          itemCount: 64,
          itemBuilder: (context, index) {
            int row = index ~/ 8;
            int col = index % 8;
            Offset pos = Offset(col.toDouble(), row.toDouble());
            bool isLight = (row + col) % 2 == 0;

            return GestureDetector(
              onTap: () => onSquareTap(pos),
              child: Container(
                color: _getThemeColor(isLight),
                child: pieces.containsKey(pos)
                    ? PieceWidget(piece: pieces[pos]!, isSelected: selectedPos == pos, canBeCaptured: validTargets.contains(pos))
                    : (validTargets.contains(pos) ? Center(child: CircleAvatar(radius: 4, backgroundColor: Colors.red.withOpacity(0.5))) : null),
              ),
            );
          },
        ),
      ),
    );
  }

  Color _getThemeColor(bool isLight) {
    if (theme == 'green-blue') return isLight ? Colors.teal[200]! : Colors.blueGrey[700]!;
    if (theme == 'black-white') return isLight ? Colors.white : Colors.grey[800]!;
    return isLight ? const Color(0xFFFDE68A) : const Color(0xFF92400E);
  }
}