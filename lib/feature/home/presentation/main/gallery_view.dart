import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_viewer_page/image_viewer_page.dart';


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


  final List<ImageTransitionStyle> transitionStyles = const [
    ImageTransitionStyle.slide,
    ImageTransitionStyle.fade,
    ImageTransitionStyle.scale,
    ImageTransitionStyle.flip,
    ImageTransitionStyle.cube,
    ImageTransitionStyle.rotate,
  ];

  @override
  Widget build(BuildContext context) {
    // return Container();
    return Column(
      children: [
        Text(
          "웨딩 사진",
          style: GoogleFonts.notoSans(
            fontSize: 40,
          ),
        ),
        const SizedBox(height: 15,),
        Padding(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: Divider(height: 1,)
        ),
        const SizedBox(height: 45,),
        GridView.builder(
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
                  ImageViewerNavigator.push(
                    context,
                    imageUrls: imageUrls,
                    initialIndex: index,
                    transitionStyle: ImageTransitionStyle.slide,
                  );
                  // Navigator.of(context).push(
                  //   PageRouteBuilder(
                  //     opaque: false,
                  //     barrierColor: Colors.black.withOpacity(0),
                  //     pageBuilder: (_, __, ___) => ImageViewerPage(
                  //       imageUrls: imageUrls,
                  //       initialIndex: index,
                  //       transitionStyle:
                  //           transitionStyles[index % transitionStyles.length],
                  //     ),
                  //     transitionsBuilder:
                  //         (context, animation, secondaryAnimation, child) {
                  //       return FadeTransition(
                  //         opacity: animation,
                  //         child: child,
                  //       );
                  //     },
                  //   ),
                  // );
                  /// For Getx navigator
                  // Get.to(
                  //   () => ImageViewerPage(
                  //     imageUrls: imageUrls,
                  //     initialIndex: index,
                  //     transitionStyle:
                  //         transitionStyles[index % transitionStyles.length],
                  //   ),
                  //   fullscreenDialog: true,
                  //   opaque: false, // <-- This is the key!
                  //   transition:
                  //       Transition.noTransition, // We'll control animation manually
                  //   popGesture: true,
                  //   curve: Curves.easeInOut,
                  // );
                },
                child: Hero(
                  tag: heroTag,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
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