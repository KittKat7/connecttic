import 'package:flutter/material.dart';
import 'package:kittkatflutterlibrary/kittkatflutterlibrary.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  /// Build and return the Home Screen.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(getLang("titleAbout")),
      ),
      // Aspect controls the aspect ratio.
      body: Aspect(
        child: Center(child: Marked(getLang("txtAbout"))),
      ),
    );
  }
}
