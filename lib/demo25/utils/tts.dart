import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  final FlutterTts _flutterTts = FlutterTts();

  void speak (String text) {
    _flutterTts.speak(text);
  }
}
