import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class IntroOurselvesView extends StatelessWidget {
  const IntroOurselvesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          _introParents(),
          const SizedBox(height: 150,),
          _introOurselves(),
    ]);
  }

  Widget _introParents() {
    return Column(
      children: [
        Text(
          "부모님 소개",
          style: GoogleFonts.notoSans(
            fontSize: 40,
          ),
        ),
        const SizedBox(height: 15,),
        Padding(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: Divider(height: 1,)
        ),
        const SizedBox(height: 15,),
        Text(
          "저희의 시작을 사랑으로 응원해주신\n"
              "양가 부모님을 소개합니다.",
          textAlign: TextAlign.center,
          style: GoogleFonts.notoSans(
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 30,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _introCard(
              imagePath: 'assets/parent_kim.png',
              label: '신랑 김수길의 부모님',
              parentNames: '김윤규 ♡ 박인숙',
            ),
            _introCard(
              imagePath: 'assets/parent_you.png',
              label: '신부 유연정의 부모님',
              parentNames: '유용청 ♡ 전미용',
            ),
          ],
        )
      ],
    );
  }

  Widget _introOurselves() {
    return Column(
      children: [
        Text(
          "신랑 신부 소개",
          style: GoogleFonts.notoSans(
            fontSize: 40,
          ),
        ),
        const SizedBox(height: 15,),
        Padding(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: Divider(height: 1,)
        ),
        // const SizedBox(height: 15,),
        // Text(
        //   "저희의 시작을 사랑으로 응원해주신\n"
        //       "양가 부모님을 소개합니다.",
        //   textAlign: TextAlign.center,
        //   style: GoogleFonts.notoSans(
        //     fontSize: 20,
        //   ),
        // ),
        const SizedBox(height: 45,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _introCard(
              imagePath: 'assets/kim.jpg',
              label: '',
              parentNames: '신랑 김수길',
            ),
            _introCard(
              imagePath: 'assets/you.jpg',
              label: '',
              parentNames: '신부 유연정',
            ),
          ],
        )
      ],
    );
  }

  Widget _introCard({
    required String imagePath,
    required String label,
    required String parentNames,
  }) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            imagePath,
            width: 200,
            height: 350,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 15,),
        Text(
          label,
          style: GoogleFonts.notoSans(
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 5,),
        Text(
          parentNames,
          style: GoogleFonts.notoSans(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }
}