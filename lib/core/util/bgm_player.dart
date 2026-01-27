import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';


class AudioManager {
  static final AudioManager _instance = AudioManager._internal();

  factory AudioManager() {
    return _instance;
  }

  AudioManager._internal();

  AudioPlayer? _player;

  final ValueNotifier<bool> isPlayingNotifier = ValueNotifier<bool>(false);

  bool _isInitialized = false;
  bool _initFailed = false;

  Future<void> init() async {
    if (_isInitialized || _initFailed) return;

    try {
      _player = AudioPlayer();
      await _player!.setAsset('assets/flac/couple.flac');
      await _player!.setLoopMode(LoopMode.all);
      await _player!.setVolume(0.3);

      _player!.playerStateStream.listen((state) {
        isPlayingNotifier.value = state.playing;
      });

      _isInitialized = true;
    } catch (e) {
      _initFailed = true;
      debugPrint('fail audio init $e');
    }
  }

  Future<void> toggleMusic() async {
    if (_player == null || !_isInitialized) return;

    try {
      if (_player!.playing) {
        await _player!.pause();
      } else {
        await _player!.play();
      }
    } catch (e) {
      debugPrint('toggleMusic error: $e');
    }
  }

  Future<void> dispose() async {
    if (_player == null) return;

    try {
      await _player!.stop();
      await _player!.dispose();
    } catch (e) {
      debugPrint('dispose error: $e');
    }
  }
}