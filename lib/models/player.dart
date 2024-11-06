import 'package:connecttic/models/game_object.dart';
import 'package:flutter/material.dart';

class Player extends GameObject {
  /// Username for the player
  final String _username;
  String get username {
    return _username;
  }

  /// The x and y for the last played location
  int lastx, lasty;

  /// The tile widget which will be used to mark the player on the board widget
  final Widget _tile;

  /// Player constructor
  Player(String username, Widget tile, [Color color = Colors.grey])
      : _username = username,
        _tile = color == Colors.transparent
            ? tile
            : ColorFiltered(
                colorFilter: ColorFilter.mode(color, BlendMode.modulate),
                child: tile,
              ),
        lastx = -1,
        lasty = -1 {
    if (!Player._isValidUsername(username)) throw Exception("Invalid username");
  }

  @override
  Widget getTile() {
    return Transform.scale(scale: 0.75, child: _tile);
  }

  @override
  Widget getBigTile() {
    return _tile;
  }

  /// Checks if the username is a valid username. Return true if so, otherwise return false
  static bool _isValidUsername(String username) {
    if (username.isEmpty) return false;
    if (["-"].contains(username)) return false;
    return true;
  }
}
