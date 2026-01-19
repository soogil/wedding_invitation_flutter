import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timeline_tile/timeline_tile.dart';


class TimeLineView extends StatelessWidget {
  const TimeLineView({super.key});

  @override
  Widget build(BuildContext context) {
    // 타임라인 데이터 (날짜, 제목, 설명, 이미지경로)
    final List<Map<String, String>> events = [
      {
        "date": "2021. 05. 21",
        "title": "우리의 첫 만남",
        "desc": "설레던 그날, 카페에서의 첫 대화",
        "image": "assets/hero1.jpg" // 이미지 경로 확인 필요
      },
      {
        "date": "2022. 12. 25",
        "title": "첫 번째 크리스마스",
        "desc": "눈 내리던 날의 따뜻한 저녁",
        "image": "assets/hero2.jpg"
      },
      {
        "date": "2024. 01. 01",
        "title": "함께 맞은 새해",
        "desc": "해돋이를 보며 했던 다짐들",
        "image": "assets/hero1.jpg"
      },
      {
        "date": "2026. 06. XX",
        "title": "Wedding Day",
        "desc": "평생을 약속하는 날",
        "image": "assets/hero2.jpg"
      },
    ];


    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: Center(
            child: Text(
              "연애 타임라인",
              style: TextStyle(
                fontSize: 40.sp
              )
            ),
          ),
        ),

        SizedBox(height: 15.h),
        Padding(
            padding: EdgeInsets.only(left: 15.w, right: 15.w),
            child: Divider(height: 1,)
        ),
        SizedBox(height: 15.h),
        ListView.builder(
          padding: EdgeInsets.all(0),
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final event = events[index];
            final isLeft = index % 2 == 0; // 짝수는 왼쪽, 홀수는 오른쪽

            return SizedBox(
              height: 200.h, // 각 타임라인 높이
              child: TimelineTile(
                alignment: TimelineAlign.center,
                // 중앙 정렬
                isFirst: index == 0,
                isLast: index == events.length - 1,

                // ✅ 타임라인 중앙 선 스타일
                beforeLineStyle: const LineStyle(
                  color: Color(0xFFD4C4B7),
                  thickness: 2,
                ),

                // ✅ 타임라인 중앙 아이콘 (하트)
                indicatorStyle: IndicatorStyle(
                  width: 30.w,
                  height: 30.w,
                  indicator: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF6F2EA),
                      border: Border.all(
                          color: const Color(0xFFD4C4B7), width: 2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                        Icons.favorite,
                        color: Color(0xFFFF8A80),
                        size: 16.sp
                    ),
                  ),
                  drawGap: true, // 선과 아이콘 사이 여백
                ),

                // ✅ 왼쪽 영역 (짝수: 내용 / 홀수: 날짜)
                startChild: isLeft
                    ? _buildContent(event, isLeft: true)
                    : _buildDate(event['date']!, isLeft: true),

                // ✅ 오른쪽 영역 (짝수: 날짜 / 홀수: 내용)
                endChild: isLeft
                    ? _buildDate(event['date']!, isLeft: false)
                    : _buildContent(event, isLeft: false),
              ),
            );
          },
          itemCount: events.length,
        ),
      ],
    );
  }

  Widget _buildDate(String date, {required bool isLeft}) {
    return Container(
      padding: EdgeInsets.only(
          left: isLeft ? 0 : 15,
          right: isLeft ? 15 : 0
      ),
      alignment: isLeft ? Alignment.centerRight : Alignment.centerLeft,
      child: Text(
        date,
        style: TextStyle(
          fontSize: 10.sp,
          color: Colors.grey[600],
          fontWeight: FontWeight.bold,
          fontFamily: 'NotoSerifKR', // 한글 폰트 추천
        ),
      ),
    );
  }

  Widget _buildContent(Map<String, String> event, {required bool isLeft}) {
    return Padding(
      padding: EdgeInsets.only(
        left: isLeft ? 20 : 15,
        right: isLeft ? 15 : 20,
        top: 10,
        bottom: 10,
      ),
      child: Column(
        crossAxisAlignment: isLeft ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 사진 둥글게
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Image.asset(
              event['image']!, // 실제 이미지가 없으면 에러나니 주의
              width: 300,
              height: 120,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            event['title']!,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp),
            textAlign: isLeft ? TextAlign.right : TextAlign.left,
          ),
          Text(
            event['desc']!,
            style: TextStyle(color: Colors.grey[600], fontSize: 11.sp),
            textAlign: isLeft ? TextAlign.right : TextAlign.left,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}