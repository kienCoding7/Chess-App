import 'package:flutter/material.dart';
import 'dart:ui';

class GameDialog extends StatelessWidget {
  final String title;
  final String message;
  final List<Widget> actions;
  final Color accentColor;

  const GameDialog({super.key, required this.title, required this.message, required this.actions, this.accentColor = Colors.amber});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: AlertDialog(
        backgroundColor: const Color(0xFF1C1917),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(title, style: TextStyle(color: accentColor, fontWeight: FontWeight.bold)),
        content: Text(message, style: const TextStyle(color: Colors.white70)),
        actions: actions,
      ),
    );
  }
}