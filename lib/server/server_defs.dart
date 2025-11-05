import 'dart:io';

class ServerDefs {
  /// Requests to make a new game, no extra data required. Returns a json
  /// response of `{"hash": "HASH", "user": "USER1"}`
  static const String reqNew = 'new';

  /// Requests to join a game, required data `{"hash": "HASH"}`. Successful
  /// returns a json response of `{"hash": "HASH", "user": "USER2"}`
  static const String reqJoin = 'join';

  /// Requests to play on a given game, required data `{"hash": "HASH", "user":
  /// "USER", "pos": POS}` and returns `{"hash": "HASH", "game": GAME}`
  static const String reqPlay = 'play';

  static const int codeSucc = HttpStatus.ok;
  static const int codeAppErr = HttpStatus.badRequest;
  static const int codeUsrErr = HttpStatus.notFound;
}
