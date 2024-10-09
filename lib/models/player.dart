import 'package:connecttic/models/tile.dart';
import 'package:flutter/material.dart';

class Player {
  final String _username;
  String get username {
    return _username;
  }

  final PlayerTile _tile;
  PlayerTile get tile => _tile;

  int lastx;
  int lasty;

  Player(String username, Widget marker)
      : _username = username,
        _tile = PlayerTile(id: username, marker: marker),
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
