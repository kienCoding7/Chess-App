import 'package:flutter/material.dart';

class Piece {
  final String type;
  final String color;
  int captureCount;

  Piece({required this.type, required this.color, this.captureCount = 0});

  Piece copy() => Piece(
    type: type,
    color: color,
    captureCount: captureCount,
  );
}