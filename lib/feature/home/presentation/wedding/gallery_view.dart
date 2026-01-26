import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
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
                  context.push(
                    Uri(
                      path: '/gallery',
                      queryParameters: {'index': index.toString()},
                    ).toString(),
                    extra: imageUrls,
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

class GalleryPhotoView extends StatelessWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const GalleryPhotoView({
    super.key,
    required this.imageUrls,
    required this.initialIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: Container(
        color: Colors.black,
        child: PhotoViewGallery.builder(
          scrollPhysics: const BouncingScrollPhysics(),
          itemCount: imageUrls.length,
          builder: (BuildContext context, int index) {
            return PhotoViewGalleryPageOptions(
              imageProvider: AssetImage(imageUrls[index]),
              initialScale: PhotoViewComputedScale.contained,
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 2,
              heroAttributes: PhotoViewHeroAttributes(tag: imageUrls[index]),
            );
          },
          loadingBuilder: (context, event) => const Center(
            child: CircularProgressIndicator(),
          ),
          pageController: PageController(initialPage: initialIndex),
        ),
      ),
    );
  }
}