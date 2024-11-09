import 'package:flutter/material.dart';
import 'package:kittkatflutterlibrary/kittkatflutterlibrary.dart';

import 'modeselect_screen.dart';
import 'about_screen.dart';
import 'help_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  /// Build and return the Home Screen.
  @override
  Widget build(BuildContext context) {
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
                  thirdButton(
                    StyledButton(
                        text: getLang('btnStartGame'),
                        onPressed: () => Navigator.push(
                            context, genRoute(const ModeSelectScreen()))),
                  ),
                  const SizedBox(height: 10),
                  thirdButton(
                    StyledButton(
                        text: getLang('btnHelp'),
                        onPressed: () => Navigator.push(
                            context, genRoute(const HelpScreen()))),
                  ),
                  const SizedBox(height: 10),
                  thirdButton(
                    StyledButton(
                        text: getLang('btnAbout'),
                        onPressed: () => Navigator.push(
                            context, genRoute(const AboutScreen()))),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Row thirdButton(Widget button) {
    return Row(
      children: [
        const Expanded(
          flex: 1,
          child: SizedBox(),
        ),
        Expanded(
          flex: 1,
          child: button,
        ),
        const Expanded(
          flex: 1,
          child: SizedBox(),
        ),
      ],
    );
  }
}

class StyledButton extends StatelessWidget {
  const StyledButton({
    required this.onPressed,
    required this.text,
    super.key,
  });
  final void Function() onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Stack(
        alignment: Alignment.center, // Centers everything within the Stack
        children: [
          // Image background
          Image.asset(
            'assets/button.png', // Replace with your image path
            width: double.infinity, // You can adjust this size as needed
            fit: BoxFit.fill, // Makes sure the image covers the button area
            filterQuality: FilterQuality.none,
          ),
          // Centered text on top of the image
          Center(
              // TODO: Add a way to colorize text other than color filter
              child: ColorFiltered(
            colorFilter:
                const ColorFilter.mode(Colors.black, BlendMode.modulate),
            child: Marked(text, scale: 2),
          )),
        ],
      ),
    );
  }
}
