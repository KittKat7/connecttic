import 'package:flutter/material.dart';

import '../models/audio_player.dart';

class AudioMuteButton extends StatefulWidget {
  @override
  State<AudioMuteButton> createState() => _AudioMuteButtonState();
}

class _AudioMuteButtonState extends State<AudioMuteButton> {
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      GestureDetector(
        onTap: () =>
            setState(() => AppAudio.musicIsMuted = !AppAudio.musicIsMuted),
        child: Stack(
          alignment: Alignment.center, // Centers everything within the Stack
          children: [
            // Image background
            Image.asset(
              'assets/coins/coin_pixel.png', // Replace with your image path
              width: 70, // You can adjust this size as needed
              height: 70,
              fit: BoxFit.fill, // Makes sure the image covers the button area
              filterQuality: FilterQuality.none,
            ),
            // Centered text on top of the image
            Center(
                child: Icon(
                    size: 50,
                    color: Colors.black,
                    AppAudio.musicIsMuted
                        ? Icons.music_off
                        : Icons.music_note)),
          ],
        ),
      ),
      GestureDetector(
        onTap: () => setState(
            () => AppAudio.effectsAreMuted = !AppAudio.effectsAreMuted),
        child: Stack(
          alignment: Alignment.center, // Centers everything within the Stack
          children: [
            // Image background
            Image.asset(
              'assets/coins/coin_pixel.png', // Replace with your image path
              width: 70, // You can adjust this size as needed
              height: 70,
              fit: BoxFit.fill, // Makes sure the image covers the button area
              filterQuality: FilterQuality.none,
            ),
            // Centered text on top of the image
            Center(
                child: Icon(
                    size: 50,
                    color: Colors.black,
                    AppAudio.effectsAreMuted
                        ? Icons.volume_off
                        : Icons.volume_up)),
          ],
        ),
      )
    ]);
  }
}
