import 'package:connecttic/models/audio_player.dart';
import 'package:connecttic/widgets/audio_mute_button.dart';
import 'package:connecttic/widgets/button_widget.dart';
import 'package:connecttic/widgets/greeting_popup_widget.dart';
import 'package:flutter/material.dart';
import 'package:kittkatflutterlibrary/kittkatflutterlibrary.dart';

import 'modeselect_screen.dart';
import 'about_screen.dart';
import 'help_screen.dart';

bool isFirstDisplay = true;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  /// Build and return the Home Screen.
  @override
  Widget build(BuildContext context) {
    if (isFirstDisplay) {
      isFirstDisplay = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showGreetingPopup(context,
            () => AppAudio.getInstance().playMusic(AppAudio.musicMenu));
      });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        title: Text(getLang('titleApp')),
      ),
      body: Stack(
        children: [
          ColorFiltered(
            colorFilter: ColorFilter.mode(
                colorScheme(context).primary, BlendMode.modulate),
            child: Image.asset(
              'assets/background.png',
              filterQuality: FilterQuality.none,
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
            ),
          ),
          Aspect(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/title.png',
                    filterQuality: FilterQuality.none,
                    fit: BoxFit.fitWidth,
                    width: double.infinity,
                  ),
                  const SizedBox(height: 10),
                  StyledButton(
                      text: getLang('btnStartGame'),
                      onPressed: () {
                        // AppAudio.getInstance().playMusic(AppAudio.musicMenu);
                        Navigator.push(
                            context, genRoute(const ModeSelectScreen()));
                      }),
                  const SizedBox(height: 10),
                  StyledButton(
                      text: getLang('btnHelp'),
                      onPressed: () => Navigator.push(
                          context, genRoute(const HelpScreen()))),
                  const SizedBox(height: 10),
                  StyledButton(
                      text: getLang('btnAbout'),
                      onPressed: () => Navigator.push(
                          context, genRoute(const AboutScreen()))),
                  const SizedBox(height: 10),
                  AudioMuteButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
