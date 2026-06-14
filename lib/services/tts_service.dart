import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  final FlutterTts _tts = FlutterTts();

  Future<void> initialize() async {

    await _tts.setLanguage("en-US");
    await _tts.setPitch(1.0);
    await _tts.setSpeechRate(0.45);

  }

  Future<void> speak(String text) async {
    await _tts.speak(text);
  }

  void onComplete(Function() callback) {
    _tts.setCompletionHandler(callback);
  }

  void onError(Function(String message) callback) {
    _tts.setErrorHandler((message) {
      callback(message);
    });
  }

  Future<void> stop() async {
    await _tts.stop();
  }
}