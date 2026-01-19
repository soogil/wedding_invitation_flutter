import 'package:flutter/material.dart';


class IntroOurselvesView extends StatelessWidget {
  const IntroOurselvesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: Text(
                "Our Love Story",
                style: TextStyle(
                  fontFamily: 'GreatVibes', // 아까 추천해드린 폰트
                  fontSize: 40,
                ),
              ),
            ),
          )
        ]);
  }
}