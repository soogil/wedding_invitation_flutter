import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// 스크롤 시 fade-in + slide-up 애니메이션을 적용하는 위젯
/// 한번 보이면 visible 상태를 유지 (다시 스크롤 업해도 사라지지 않음)
class ScrollFadeIn extends StatefulWidget {
  const ScrollFadeIn({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 800),
    this.visibilityThreshold = 0.1,
    this.slideOffset = 30.0,
    this.curve = Curves.easeOutCubic,
  });

  /// 애니메이션할 자식 위젯
  final Widget child;

  /// 애니메이션 시작 전 지연 시간 (staggered 애니메이션용)
  final Duration delay;

  /// 애니메이션 지속 시간
  final Duration duration;

  /// 화면에 얼마나 보여야 애니메이션이 시작되는지 (0.0 ~ 1.0)
  final double visibilityThreshold;

  /// 슬라이드 업 거리 (픽셀)
  final double slideOffset;

  /// 애니메이션 커브
  final Curve curve;

  @override
  State<ScrollFadeIn> createState() => _ScrollFadeInState();
}

class _ScrollFadeInState extends State<ScrollFadeIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _slideAnimation;

  bool _hasAnimated = false;
  final String _visibilityKey = UniqueKey().toString();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    _slideAnimation = Tween<double>(
      begin: widget.slideOffset,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (_hasAnimated) return;

    if (info.visibleFraction >= widget.visibilityThreshold) {
      _hasAnimated = true;
      _startAnimation();
    }
  }

  void _startAnimation() {
    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) {
          _controller.forward();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(_visibilityKey),
      onVisibilityChanged: _onVisibilityChanged,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: Transform.translate(
              offset: Offset(0, _slideAnimation.value),
              child: child,
            ),
          );
        },
        child: widget.child,
      ),
    );
  }
}

extension ScrollFadeInExtension on Widget {
  Widget scrollFadeIn({
    int index = 0,
    Duration staggerDelay = const Duration(milliseconds: 100),
    Duration duration = const Duration(milliseconds: 800),
    double visibilityThreshold = 0.1,
    double slideOffset = 30.0,
    Curve curve = Curves.easeOutCubic,
  }) {
    return ScrollFadeIn(
      delay: staggerDelay * index,
      duration: duration,
      visibilityThreshold: visibilityThreshold,
      slideOffset: slideOffset,
      curve: curve,
      child: this,
    );
  }
}
