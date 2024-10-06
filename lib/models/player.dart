class Player {
  final String _username;
  String get username {
    return _username;
  }

  int lastx;
  int lasty;

  Player(String username)
      : _username = username,
        lastx = -1,
        lasty = -1 {
    if (!Player._isValidUsername(username)) throw Exception("Invalid username");
  }

  static bool _isValidUsername(String username) {
    if (username.isEmpty) return false;
    if (["-"].contains(username)) return false;
    return true;
  }
}
