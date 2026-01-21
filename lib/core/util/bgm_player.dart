import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';


class AudioManager {
  static final AudioManager _instance = AudioManager._internal();

  factory AudioManager() {
    return _instance;
  }

  AudioManager._internal();

  final AudioPlayer _player = AudioPlayer();

  final ValueNotifier<bool> isPlayingNotifier = ValueNotifier<bool>(false);

  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    try {
      await _player.setAsset('assets/flac/couple.flac');
      await _player.setLoopMode(LoopMode.all);
      await _player.setVolume(0.3);

      _player.playerStateStream.listen((state) {
        isPlayingNotifier.value = state.playing;
      });

      _isInitialized = true;
    } catch (e) {
      debugPrint('fail audio init $e');
    }
  }

  Future<void> toggleMusic() async {
    if (_player.playing) {
      await _player.pause();
    } else {
      await _player.play();
    }
  }

  void dispose() async {
    await _player.stop();
    await _player.dispose();
  }
}