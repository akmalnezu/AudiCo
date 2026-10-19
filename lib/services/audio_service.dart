import 'package:audioplayers/audioplayers.dart';

class AudioService {
  AudioService() : _player = AudioPlayer() {
    _player.setReleaseMode(ReleaseMode.loop);
  }

  final AudioPlayer _player;

  String assetForScene(String scene) {
    if (scene == 'Hutan Senja') return 'audio/Forest.mp3';
    if (scene == 'Malam') return 'audio/Night.mp3';
    return 'audio/Rain.mp3';
  }

  Future<void> playScene(String scene) => _player.play(AssetSource(assetForScene(scene)));
  Future<void> pause() => _player.pause();
  Future<void> dispose() => _player.dispose();
}
