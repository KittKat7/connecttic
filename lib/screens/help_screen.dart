import 'package:flutter/material.dart';
import 'package:kittkatflutterlibrary/kittkatflutterlibrary.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  /// Build and return the Home Screen.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        title: Text(getLang('titleHelp')),
      ),
      // Aspect controls the aspect ratio.
      body: Aspect(
        child: Center(child: Marked(getLang('txtHelp'))),
      ),
    );
  }
}
