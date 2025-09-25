class Pos {
  int x;
  int y;

  Pos({required this.x, required this.y});

  /// Returns the json objecct for the game
  Map<String, dynamic> toJson() => {
        'x': x,
        'y': y,
      };

  /// Returns a game from a json map
  Pos.fromJson(Map<String, dynamic> json)
      : x = json['x'],
        y = json['y'];
}
