import 'package:connecttic/screens/about_screen.dart';
import 'package:flutter/material.dart';
import 'package:kittkatflutterlibrary/kittkatflutterlibrary.dart';

void showGreetingPopup(BuildContext context, void Function() onDismiss) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Aspect(
          child: GreetingPopup(onDismiss: onDismiss),
        );
      });
}

/// A popup that is displayed at the end of the game, announcing the winner
class GreetingPopup extends StatelessWidget {
  /// String with the username of the winning player.
  final void Function() onDismiss;

  /// Const constructor.
  const GreetingPopup({
    super.key,
    required this.onDismiss,
  });
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(getLang('titleApp')),
      content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Marked(getLang("txtGreeting"))]),
      actions: [
        TextButton(
            onPressed: () {
              onDismiss();
              Navigator.pop(context);
              Navigator.push(context, genRoute(const AboutScreen()));
            },
            child: Text(getLang('btnAbout'))),
        TextButton(
            onPressed: () {
              onDismiss();
              Navigator.pop(context);
            },
            child: Text(getLang('btnContinue'))),
      ],
    );
  }
}
