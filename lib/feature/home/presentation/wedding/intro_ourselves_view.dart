import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_view/photo_view.dart';
import 'package:wedding/core/router/app_pages.dart';

class IntroOurselvesView extends StatelessWidget {
  const IntroOurselvesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _introParents(context),
        SizedBox(height: 120.h),
        _introOurselves(context),
      ],
    );
  }

  Widget _introParents(BuildContext context) {
    return Column(
      children: [
        Text(
          "부모님 소개",
          style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.w300),
        ),
        SizedBox(height: 15.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: const Divider(height: 1),
        ),
        SizedBox(height: 15.h),
        Text(
          "저희의 시작을 사랑으로 응원해주신\n양가 부모님을 소개합니다.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16.sp),
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
            SizedBox(width: 10.w),
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
          style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.w300),
        ),
        SizedBox(height: 15.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: const Divider(height: 1),
        ),
        SizedBox(height: 36.h),
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
            SizedBox(width: 10.w),
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
                width: 180.w,
                height: 250.h,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        SizedBox(height: 15.h),
        Text(
          label,
          style: TextStyle(fontSize: 13.sp),
        ),
        SizedBox(height: 5.h),
        Text(
          name,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}

class SinglePhotoView extends StatelessWidget {
  final String imagePath;
  final String heroTag;

  const SinglePhotoView({
    super.key,
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
