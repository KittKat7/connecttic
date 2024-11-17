import 'package:just_audio/just_audio.dart';

class AppAudio {
  static const String musicMenu = 'assets/music/track-tmp.mp3';
  static const String effectPop = 'assets/sound_effects/pop-tmp.mp3';

  static AppAudio? _instance;

  static bool get musicIsMuted {
    return getInstance()._musicIsMuted;
  }

  static set musicIsMuted(bool musicIsMuted) {
    AppAudio audio = getInstance();
    audio._musicIsMuted = musicIsMuted;
    audio._musicPlayer.setVolume(musicIsMuted ? 0.0 : 0.5);
  }

  static bool get effectsAreMuted {
    return getInstance()._effectsAreMuted;
  }

  static set effectsAreMuted(bool effectsAreMuted) {
    AppAudio audio = getInstance();
    audio._effectsAreMuted = effectsAreMuted;
    // TODO set volume for effects
  }

  static AppAudio getInstance() {
    _instance ??= AppAudio();
    return _instance!;
  }

  bool _musicIsMuted = false;
  bool _effectsAreMuted = false;

  List<AudioPlayer> effects = [];

  final _musicPlayer = AudioPlayer();

  AppAudio() {
    _musicPlayer.setVolume(0.5);
  }

  void playMusic(String track) async {
    await _musicPlayer.stop();
    _musicPlayer.setLoopMode(LoopMode.one);
    _musicPlayer.setAsset(track);
    _musicPlayer.play();
  }

  void playEffect(String sound) async {
    AudioPlayer effect = AudioPlayer();
    effect.setVolume(_effectsAreMuted ? 0.0 : 0.75);
    effects.add(effect);
    effect.setAsset(sound);
    effect.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) {
        effects.remove(effect);
        effect.dispose();
      }
    });
    effect.play();
  }

  void dispose() {
    _musicPlayer.dispose();
  }
}
