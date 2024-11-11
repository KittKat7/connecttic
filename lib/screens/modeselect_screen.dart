import 'package:connecttic/widgets/localplaypopup_widget.dart';
import 'package:flutter/material.dart';
import 'package:kittkatflutterlibrary/kittkatflutterlibrary.dart';

import '../widgets/button_widget.dart';

class ModeSelectScreen extends StatelessWidget {
  const ModeSelectScreen({super.key});

  /// Build and return the Home Screen.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        title: Text(getLang('titleModeSelect')),
      ),
      // Aspect controls the aspect ratio.
      body: Aspect(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              StyledButton(
                text: getLang('btnLocalPlay'),
                onPressed: () => showDialog(
                    context: context,
                    builder: (BuildContext context) => const LocalPlayPopup()),
              ),
              const SizedBox(height: 10),
              StyledButton(
                text: getLang('btnOnlinePlay'),
                onPressed: () {},
              ),
              // const SizedBox(height: 10),
              // ElevatedButton(
              //   style: ElevatedButton.styleFrom(
              //     minimumSize: Size.fromHeight(40),
              //   ),
              //   onPressed: () =>
              //       Navigator.push(context, genRoute(AboutScreen())),
              //   child: Marked(getLang('btnAbout')),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class Button extends StatelessWidget {
  const Button({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size.fromHeight(40),
      ),
      onPressed: () {},
      child: Marked(getLang('btnOnlinePlay')),
    );
  }
}
