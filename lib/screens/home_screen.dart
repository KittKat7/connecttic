import 'package:connecttic/screens/about_screen.dart';
import 'package:connecttic/screens/help_screen.dart';
import 'package:flutter/material.dart';
import 'package:kittkatflutterlibrary/kittkatflutterlibrary.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  /// Build and return the Home Screen.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(getLang('titleApp')),
      ),
      // Aspect controls the aspect ratio.
      body: Aspect(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(40),
                ),
                onPressed: () {},
                child: Marked(getLang('btnStartGame')),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(40),
                ),
                onPressed: () =>
                    Navigator.push(context, genRoute(HelpScreen())),
                child: Marked(getLang('btnHelp')),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(40),
                ),
                onPressed: () =>
                    Navigator.push(context, genRoute(AboutScreen())),
                child: Marked(getLang('btnAbout')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
