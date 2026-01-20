import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';


class GalleryView extends StatelessWidget {
  const GalleryView({super.key});

  final List<String> imageUrls = const [
    'assets/hero1.jpg',
    'assets/hero2.jpg',
    'assets/hero1.jpg',
    'assets/hero2.jpg',
    'assets/hero1.jpg',
    'assets/hero2.jpg',
    'assets/hero1.jpg',
    'assets/hero2.jpg',
    'assets/hero2.jpg',
    'assets/hero1.jpg',
    'assets/hero2.jpg',
    'assets/hero2.jpg',
    'assets/hero1.jpg',
    'assets/hero2.jpg',
    'assets/hero2.jpg',
    'assets/hero1.jpg',
    'assets/hero2.jpg',
    'assets/hero2.jpg',
    'assets/hero2.jpg',
    'assets/hero1.jpg',
    'assets/hero2.jpg',
  ];


  // final List<ImageTransitionStyle> transitionStyles = const [
  //   ImageTransitionStyle.slide,
  //   ImageTransitionStyle.fade,
  //   ImageTransitionStyle.scale,
  //   ImageTransitionStyle.flip,
  //   ImageTransitionStyle.cube,
  //   ImageTransitionStyle.rotate,
  // ];

  @override
  Widget build(BuildContext context) {
    // return Container();
    return Column(
      children: [
        Text(
          "웨딩 사진",
          style: TextStyle(
            fontSize: 40.sp,
          ),
        ),
        SizedBox(height: 15.h),
        Padding(
            padding: EdgeInsets.only(left: 15.w, right: 15.w),
            child: Divider(height: 1,)
        ),
        SizedBox(height: 15.h),
        GridView.builder(
          padding: EdgeInsets.all(0),
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: imageUrls.length,
            itemBuilder: (context, index) {
              final String heroTag = '${imageUrls[index]}_$index';

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Scaffold(
                        // 닫기 버튼을 위한 앱바 (선택사항)
                        appBar: AppBar(
                          backgroundColor: Colors.black,
                          leading: IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        body: Container(
                          color: Colors.black, // 배경 검은색
                          child: PhotoViewGallery.builder(
                            scrollPhysics: const BouncingScrollPhysics(),
                            builder: (BuildContext context, int index) {
                              return PhotoViewGalleryPageOptions(
                                // ✅ 핵심: 여기서 AssetImage라고 명시해줘야 합니다!
                                imageProvider: AssetImage(imageUrls[index]),

                                // 만약 나중에 인터넷 이미지라면 NetworkImage(imageUrls[index]) 쓰면 됨
                                initialScale: PhotoViewComputedScale.contained,
                                minScale: PhotoViewComputedScale.contained,
                                maxScale: PhotoViewComputedScale.covered * 2,
                                heroAttributes: PhotoViewHeroAttributes(tag: '${imageUrls[index]}_$index'),
                              );
                            },
                            itemCount: imageUrls.length,
                            loadingBuilder: (context, event) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            // 처음에 몇 번째 사진부터 보여줄지 설정
                            pageController: PageController(initialPage: index),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                child: Hero(
                  tag: heroTag,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Image.asset(
                      imageUrls[index],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            }
        ),
      ],
    );
  }
}