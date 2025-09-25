import 'package:flutter/material.dart';
import 'package:kittkatflutterlibrary/kittkatflutterlibrary.dart';

import '../models/player.dart';

class SelectPlayerLevel extends StatefulWidget {
  final Player player;
  const SelectPlayerLevel({super.key, required this.player});

  @override
  State<StatefulWidget> createState() => _SelectPlayerLevelState();
}

class _SelectPlayerLevelState extends State<SelectPlayerLevel> {
  void setCPU(PlayerLevel? v) {
    setState(() {
      widget.player.level = v ?? PlayerLevel.player;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(getLang('pmtAI')),
        Radio(
            value: PlayerLevel.player,
            groupValue: widget.player.level,
            onChanged: (v) => setCPU(v)),
        Radio(
            value: PlayerLevel.cpu1,
            groupValue: widget.player.level,
            onChanged: (v) => setCPU(v)),
        Radio(
            value: PlayerLevel.cpu2,
            groupValue: widget.player.level,
            onChanged: (v) => setCPU(v)),
        Radio(
            value: PlayerLevel.cpu3,
            groupValue: widget.player.level,
            onChanged: (v) => setCPU(v)),
      ],
    );
  }
}
