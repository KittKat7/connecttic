import 'package:flutter/material.dart';

abstract class Tile {
  String get id;
  bool highlight = false;
  Widget get marker;
}

class EmptyTile extends Tile {
  @override
  String get id => "";
  @override
  Widget get marker => const SizedBox();
}

class BlockerTile extends Tile {
  @override
  String get id => "";
  @override
  Widget get marker => const Icon(Icons.check_box_outline_blank_rounded);
}

class PlayerTile extends Tile {
  final String _id;
  final Widget _marker;
  PlayerTile({required String id, required Widget marker})
      : _id = id,
        _marker = marker;
  @override
  String get id => _id;
  @override
  Widget get marker =>
      highlight ? Transform.scale(scale: 1.5, child: _marker) : _marker;

  PlayerTile get clone => PlayerTile(id: _id, marker: _marker);
}
