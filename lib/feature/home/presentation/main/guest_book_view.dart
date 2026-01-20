import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:cloud_firestore/cloud_firestore.dart'; // 파이어베이스
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';


class GuestBookPage extends StatefulWidget {
  const GuestBookPage({super.key});

  @override
  State<GuestBookPage> createState() => _GuestBookPageState();
}

class _GuestBookPageState extends State<GuestBookPage> {
  final List<Map<String, dynamic>> _dummyGuestBook = [
    {
      'name': '김철수',
      'message': '결혼 진심으로 축하한다! 행복하게 잘 살아~',
      'colorIndex': 0,
    },
    {
      'name': '이영희',
      'message': '너무 예쁜 커플이에요 ❤️ 결혼식 날 봐요!',
      'colorIndex': 1,
    },
    {
      'name': '박민수',
      'message': '신혼여행 어디로 가? 부럽다...',
      'colorIndex': 2,
    },
    {
      'name': '최지우',
      'message': '오래오래 행복하세요! 싸우지 말고~',
      'colorIndex': 3,
    },
    {
      'name': '익명',
      'message': '축하드립니다 🎉',
      'colorIndex': 0,
    },
  ];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _msgController = TextEditingController();

  final List<Color> _postItColors = [
    const Color(0xFFFFF8C4), // 연노랑
    const Color(0xFFE2F0CB), // 연두
    const Color(0xFFFFE0E0), // 연분홍
    const Color(0xFFE0F7FA), // 하늘
  ];

  // 메시지 전송 함수
  void _sendMessage() {
    if (_nameController.text.isEmpty || _msgController.text.isEmpty) return;

    // FirebaseFirestore.instance.collection('guestbook').add({
    //   'name': _nameController.text,
    //   'message': _msgController.text,
    //   'createdAt': FieldValue.serverTimestamp(),
    //   'colorIndex': Random().nextInt(4), // 저장할 때 색상도 랜덤 지정
    // });

    setState(() {
      _dummyGuestBook.add({
        'name': _nameController.text,
        'message': _msgController.text,
        'colorIndex': Random().nextInt(3),
      },);
    });

    _nameController.clear();
    _msgController.clear();
    Navigator.pop(context); // 입력 모달 닫기
  }

  void _showWriteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("축하 메시지 남기기"),
        content: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 350.w,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "이름", hintText: "누구신가요?"),
              ),
              SizedBox(height: 10.h),
              TextField(
                controller: _msgController,
                decoration: const InputDecoration(labelText: "메시지", hintText: "축하의 한마디!"),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("취소")),
          ElevatedButton(onPressed: _sendMessage, child: const Text("등록")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Center(
              child: Text(
                  '방명록',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 40.sp)),
            ),
            Positioned(
              top: 0,
              right: 0,
              bottom: 0,
              child: TextButton(
                  onPressed: _showWriteDialog,
                  child: Text(
                    '글남기기',
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: Colors.black
                    ),
                  )
              ),
            )
          ],
        ),
        SizedBox(height: 40.h),
        MasonryGridView.count(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: 2, // 2열 배치
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          itemCount: _dummyGuestBook.length, // 더미 데이터 개수만큼 생성
          itemBuilder: (context, index) {
            final data = _dummyGuestBook[index];
            final colorIndex = data['colorIndex'] as int;

            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                // _postItColors 변수가 위쪽에 정의되어 있어야 합니다
                color: _postItColors[colorIndex % _postItColors.length],
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 5,
                    offset: const Offset(2, 2),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['message'],
                    style: TextStyle(height: 1.4, fontSize: 14.sp),
                  ),
                  SizedBox(height: 10.w),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      "- ${data['name']} -",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12.sp,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
    // return Scaffold(
    //   backgroundColor: const Color(0xFFF6F2EA),
    //   floatingActionButton: FloatingActionButton.extended(
    //     onPressed: _showWriteDialog,
    //     label: const Text("축하글 쓰기 🖊️"),
    //     backgroundColor: const Color(0xFFD4C4B7),
    //   ),
    //   body: CustomScrollView(
    //     slivers: [
    //       const SliverToBoxAdapter(
    //         child: Padding(
    //           padding: EdgeInsets.all(30.0),
    //           child: Center(
    //             child: Text("GUEST BOOK", style: TextStyle(fontFamily: 'GreatVibes', fontSize: 40)),
    //           ),
    //         ),
    //       ),
    //
    //       // ✅ 실시간 데이터 스트림 (Firebase)
    //       StreamBuilder<QuerySnapshot>(
    //         stream: FirebaseFirestore.instance
    //             .collection('guestbook')
    //             .orderBy('createdAt', descending: true)
    //             .snapshots(),
    //         builder: (context, snapshot) {
    //           if (!snapshot.wasData) return const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator()));
    //
    //           final docs = snapshot.data!.docs;
    //
    //           // ✅ 핀터레스트/포스트잇 스타일 그리드
    //           return SliverPadding(
    //             padding: const EdgeInsets.symmetric(horizontal: 16),
    //             sliver: SliverMasonryGrid.count(
    //               crossAxisCount: 2, // 2열 배치
    //               mainAxisSpacing: 10,
    //               crossAxisSpacing: 10,
    //               childCount: docs.length,
    //               itemBuilder: (context, index) {
    //                 final data = docs[index].data() as Map<String, dynamic>;
    //                 final colorIndex = data['colorIndex'] ?? 0;
    //
    //                 return Container(
    //                   padding: const EdgeInsets.all(16),
    //                   decoration: BoxDecoration(
    //                     color: _postItColors[colorIndex % _postItColors.length],
    //                     borderRadius: BorderRadius.circular(12),
    //                     boxShadow: [
    //                       BoxShadow(
    //                         color: Colors.black.withOpacity(0.05),
    //                         blurRadius: 5,
    //                         offset: const Offset(2, 2),
    //                       )
    //                     ],
    //                   ),
    //                   child: Column(
    //                     crossAxisAlignment: CrossAxisAlignment.start,
    //                     children: [
    //                       Text(
    //                         data['message'] ?? '',
    //                         style: const TextStyle(height: 1.4, fontSize: 14),
    //                       ),
    //                       const SizedBox(height: 10),
    //                       Align(
    //                         alignment: Alignment.bottomRight,
    //                         child: Text(
    //                           "- ${data['name']} -",
    //                           style: const TextStyle(
    //                               fontWeight: FontWeight.bold,
    //                               fontSize: 12,
    //                               color: Colors.black54
    //                           ),
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                 );
    //               },
    //             ),
    //           );
    //         },
    //       ),
    //       const SliverToBoxAdapter(child: SizedBox(height: 100)),
    //     ],
    //   ),
    // );
  }
}