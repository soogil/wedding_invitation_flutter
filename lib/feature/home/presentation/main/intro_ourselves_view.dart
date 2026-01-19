import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class IntroOurselvesView extends StatelessWidget {
  const IntroOurselvesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          _introParents(),
          SizedBox(height: 150.h),
          _introOurselves(),
    ]);
  }

  Widget _introParents() {
    return Column(
      children: [
        Text(
          "부모님 소개",
          style: TextStyle(
            fontSize: 40.sp,
          ),
        ),
        SizedBox(height: 15.h),
        Padding(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: Divider(height: 1,)
        ),
        SizedBox(height: 15.h),
        Text(
          "저희의 시작을 사랑으로 응원해주신\n"
              "양가 부모님을 소개합니다.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.sp,
          ),
        ),
        SizedBox(height: 30.h),
        // GridView.count(
        //   mainAxisSpacing: 10,
        //   physics: NeverScrollableScrollPhysics(),
        //   shrinkWrap: true,
        //   crossAxisCount: 2,
        //   children: [
        //     _introCard(
        //       imagePath: 'assets/parent_kim.png',
        //       label: '신랑 김수길의 부모님',
        //       parentNames: '김윤규 ♡ 박인숙',
        //     ),
        //     _introCard(
        //       imagePath: 'assets/parent_you.png',
        //       label: '신부 유연정의 부모님',
        //       parentNames: '유용청 ♡ 전미용',
        //     ),
        //   ],
        // ),

       
        Row(
          children: [
            Expanded(
              child: _introCard(
                imagePath: 'assets/parent_kim.png',
                label: '신랑 김수길의 부모님',
                parentNames: '김윤규 ♡ 박인숙',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _introCard(
                imagePath: 'assets/parent_you.png',
                label: '신부 유연정의 부모님',
                parentNames: '유용청 ♡ 전미용',
              ),
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
          style: TextStyle(
            fontSize: 40.sp,
          ),
        ),
        SizedBox(height: 15.h),
        Padding(
            padding: EdgeInsets.only(left: 15.w, right: 15.w),
            child: Divider(height: 1,)
        ),
        // const SizedBox(height: 15,),
        // Text(
        //   "저희의 시작을 사랑으로 응원해주신\n"
        //       "양가 부모님을 소개합니다.",
        //   textAlign: TextAlign.center,
        //   style: TextStyle(
        //     fontSize: 20,
        //   ),
        // ),
        SizedBox(height: 45.h),
        Row(
          children: [
            Expanded(
              child: _introCard(
                imagePath: 'assets/kim.jpg',
                label: '',
                parentNames: '신랑 김수길',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _introCard(
                imagePath: 'assets/you.jpg',
                label: '',
                parentNames: '신부 유연정',
              ),
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
          borderRadius: BorderRadius.circular(8.r),
          child: Image.asset(
            imagePath,
            width: 180,
            height: 250,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(height: 15.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 15.sp,
          ),
        ),
        SizedBox(height: 5.h),
        Text(
          parentNames,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }
}