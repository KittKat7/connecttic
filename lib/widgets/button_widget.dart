import 'package:flutter/material.dart';
import 'package:kittkatflutterlibrary/kittkatflutterlibrary.dart';
import 'package:kittkatflutterlibrary/widgets/kkfl_widgets.dart';

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
            width: 300, // You can adjust this size as needed
            height: 75,
            fit: BoxFit.fill, // Makes sure the image covers the button area
            filterQuality: FilterQuality.none,
          ),
          // Centered text on top of the image
          Center(
              // TODO: Add a way to colorize text other than color filter
              child: ColorFiltered(
            colorFilter:
                const ColorFilter.mode(Colors.black, BlendMode.modulate),
            child: Marked(text, scale: 1.5),
          )),
        ],
      ),
    );
  }
}
