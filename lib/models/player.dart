class Player {
  final String _username;
  String get username {
    return _username;
  }

  final String _marker;
  String get marker => _marker;

  int lastx;
  int lasty;

  Player(String username, String marker)
      : _username = username,
        _marker = marker,
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
