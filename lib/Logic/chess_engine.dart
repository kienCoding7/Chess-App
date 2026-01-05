import 'package:flutter/material.dart';
import '../models/chess_piece_data.dart';

class ChessEngine {
  static bool canCapture(Offset from, Offset to, String type, Map<Offset, Piece> pieces) {
    int rowDiff = (to.dy - from.dy).abs().toInt();
    int colDiff = (to.dx - from.dx).abs().toInt();

    bool isPathClear() {
      int rowStep = to.dy == from.dy ? 0 : (to.dy - from.dy).sign.toInt();
      int colStep = to.dx == from.dx ? 0 : (to.dx - from.dx).sign.toInt();
      var curr = from + Offset(colStep.toDouble(), rowStep.toDouble());
      while (curr != to) {
        if (pieces.containsKey(curr)) return false;
        curr += Offset(colStep.toDouble(), rowStep.toDouble());
      }
      return true;
    }

    switch (type) {
      case 'king': return rowDiff <= 1 && colDiff <= 1;
      case 'queen': return (rowDiff == colDiff || from.dy == to.dy || from.dx == to.dx) && isPathClear();
      case 'rook': return (from.dy == to.dy || from.dx == to.dx) && isPathClear();
      case 'bishop': return (rowDiff == colDiff) && isPathClear();
      case 'knight': return (rowDiff == 2 && colDiff == 1) || (rowDiff == 1 && colDiff == 2);
      case 'pawn': return rowDiff == 1 && colDiff == 1; // Simplified capture-only logic
      default: return false;
    }
  }

  static bool isSolvable(Map<Offset, Piece> pieces) {
    if (pieces.length == 1) return true;
    for (var from in pieces.keys) {
      var piece = pieces[from]!;
      if (piece.captureCount >= 3) continue;
      for (var to in pieces.keys) {
        if (from == to) continue;
        if (canCapture(from, to, piece.type, pieces)) {
          var nextState = Map<Offset, Piece>.from(pieces).map((k, v) => MapEntry(k, v.copy()));
          nextState[to] = nextState[from]! .. captureCount;
          nextState.remove(from);
          if (isSolvable(nextState)) return true;
        }
      }
    }
    return false;
  }
}