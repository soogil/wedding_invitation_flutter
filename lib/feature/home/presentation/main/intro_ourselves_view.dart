import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_view/photo_view.dart';
import 'package:wedding/core/router/app_pages.dart'; // photo_view 패키지 필요

class IntroOurselvesView extends StatelessWidget {
  const IntroOurselvesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _introParents(context),
        SizedBox(height: 150.h),
        _introOurselves(context),
      ],
    );
  }

  Widget _introParents(BuildContext context) {
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
            child: Divider(height: 1)),
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
        Row(
          children: [
            Expanded(
              child: _introCard(
                context,
                imagePath: 'assets/parent_kim.png',
                label: '신랑 김수길의 부모님',
                name: '김윤규 ♡ 박인숙',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _introCard(
                context,
                imagePath: 'assets/parent_you.png',
                label: '신부 유연정의 부모님',
                name: '유용청 ♡ 전미용',
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _introOurselves(BuildContext context) {
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
            child: Divider(height: 1)),
        SizedBox(height: 45.h),
        Row(
          children: [
            Expanded(
              child: _introCard(
                context,
                imagePath: 'assets/kim.jpg',
                label: '',
                name: '신랑 김수길',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _introCard(
                context,
                imagePath: 'assets/you.jpg',
                label: '',
                name: '신부 유연정',
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _introCard(
      BuildContext context, {
        required String imagePath,
        required String label,
        required String name,
      }) {
    final String heroTag = imagePath;

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            context.push(Uri(
              path: AppPage.photo.path,
              queryParameters: {
                'path': imagePath,
                'tag': heroTag,
              },
            ).toString());
          },
          child: Hero(
            tag: heroTag,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.asset(
                imagePath,
                width: 180,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
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
          name,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }
}

class SinglePhotoView extends StatelessWidget {
  final String imagePath;
  final String heroTag;

  const SinglePhotoView({super.key,
    required this.imagePath,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: PhotoView(
          imageProvider: AssetImage(imagePath),
          heroAttributes: PhotoViewHeroAttributes(tag: heroTag),
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered * 2.5,
          onTapUp: (context, details, controllerValue) {
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}