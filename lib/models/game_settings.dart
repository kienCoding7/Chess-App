class GameSettings {
  String pieceColor;
  String boardTheme;
  String difficulty;

  GameSettings({
    this.pieceColor = 'white',
    this.boardTheme = 'tan-brown',
    this.difficulty = 'easy',
  });

  int get maxLives => difficulty == 'easy' ? 3 : (difficulty == 'medium' ? 2 : 1);
}