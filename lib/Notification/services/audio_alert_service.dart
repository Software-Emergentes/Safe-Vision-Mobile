// lib/services/audio_alert_service.dart
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';
import '../models/alert_model.dart';

class AudioAlertService {
  static final AudioAlertService _instance = AudioAlertService._internal();
  factory AudioAlertService() => _instance;
  AudioAlertService._internal();

  final AudioPlayer _alertPlayer = AudioPlayer();
  final AudioPlayer _backgroundPlayer = AudioPlayer();

  bool _isEnabled = true;
  bool _isPlaying = false;
  AlertLevel? _currentAlertLevel;

  bool get isEnabled => _isEnabled;
  bool get isPlaying => _isPlaying;

  /// Configurar volumen al máximo
  Future<void> initialize() async {
    await _alertPlayer.setVolume(1.0);
    await _backgroundPlayer.setVolume(0.8);

    // Configurar modo de audio para alarma (bypass silencio y no molestar)
    await _alertPlayer.setReleaseMode(ReleaseMode.stop);
    await _backgroundPlayer.setReleaseMode(ReleaseMode.loop);

    print('🔊 Servicio de audio inicializado');
  }

  /// Activar/desactivar alertas sonoras
  void setEnabled(bool enabled) {
    _isEnabled = enabled;
    if (!enabled) {
      stopAllSounds();
    }
  }

  /// Reproducir alerta según el nivel
  Future<void> playAlert(AlertLevel level) async {
    if (!_isEnabled) return;

    // Si ya está reproduciendo el mismo nivel, no hacer nada
    if (_isPlaying && _currentAlertLevel == level) return;

    // Detener sonidos anteriores
    await stopAllSounds();

    _currentAlertLevel = level;
    _isPlaying = true;

    switch (level) {
      case AlertLevel.low:
        await _playLowAlert();
        break;
      case AlertLevel.medium:
        await _playMediumAlert();
        break;
      case AlertLevel.high:
        await _playHighAlert();
        break;
      case AlertLevel.critical:
        await _playCriticalAlert();
        break;
    }
  }

  /// Alerta BAJA - Sonido suave de advertencia
  Future<void> _playLowAlert() async {
    try {
      // Vibración suave
      if (await Vibration.hasVibrator() ?? false) {
        Vibration.vibrate(duration: 200);
      }

      // Sonido de notificación suave
      await _alertPlayer.play(AssetSource('sounds/alert_low.wav'));

      // Auto-detener después de reproducir
      await Future.delayed(const Duration(seconds: 2));
      _isPlaying = false;
    } catch (e) {
      print('Error reproduciendo alerta baja: $e');
      _isPlaying = false;
    }
  }

  /// Alerta MEDIA - Sonido de advertencia moderado
  Future<void> _playMediumAlert() async {
    try {
      // Vibración en patrón
      if (await Vibration.hasVibrator() ?? false) {
        Vibration.vibrate(
          pattern: [0, 300, 200, 300],
          intensities: [0, 128, 0, 128],
        );
      }

      // Sonido de alarma moderada (repetir 2 veces)
      for (int i = 0; i < 2; i++) {
        if (!_isPlaying) break;
        await _alertPlayer.play(AssetSource('sounds/alert_medium.wav'));
        await Future.delayed(const Duration(milliseconds: 1500));
      }

      _isPlaying = false;
    } catch (e) {
      print('Error reproduciendo alerta media: $e');
      _isPlaying = false;
    }
  }

  /// Alerta ALTA - Sonido de alarma fuerte
  Future<void> _playHighAlert() async {
    try {
      // Vibración intensa
      if (await Vibration.hasVibrator() ?? false) {
        Vibration.vibrate(
          pattern: [0, 500, 300, 500, 300, 500],
          intensities: [0, 255, 0, 255, 0, 255],
        );
      }

      // Alarma fuerte (repetir 3 veces)
      for (int i = 0; i < 3; i++) {
        if (!_isPlaying) break;
        await _alertPlayer.play(AssetSource('sounds/alert_high.wav'));
        await Future.delayed(const Duration(milliseconds: 1800));
      }

      _isPlaying = false;
    } catch (e) {
      print('Error reproduciendo alerta alta: $e');
      _isPlaying = false;
    }
  }

  /// Alerta CRÍTICA - Sonido tipo sismo/emergencia (muy fuerte e insistente)
  Future<void> _playCriticalAlert() async {
    try {
      // Vibración tipo emergencia (muy intensa)
      if (await Vibration.hasVibrator() ?? false) {
        // Patrón de emergencia continuo
        Vibration.vibrate(
          pattern: [0, 1000, 500, 1000, 500, 1000, 500, 1000],
          intensities: [0, 255, 0, 255, 0, 255, 0, 255],
        );
      }

      // Reproducir sonido de emergencia en loop
      await _backgroundPlayer.play(
        AssetSource('sounds/alert_critical.wav'),
        volume: 1.0,
      );
      await _backgroundPlayer.setReleaseMode(ReleaseMode.loop);

      // Mantener reproduciendo hasta que se detenga manualmente
      // No auto-detener, requiere acción del usuario
    } catch (e) {
      print('Error reproduciendo alerta crítica: $e');
      _isPlaying = false;
    }
  }

  /// Reproducir sonido de alerta sísmica/emergencia
  Future<void> playEmergencySiren() async {
    if (!_isEnabled) return;

    try {
      await stopAllSounds();
      _isPlaying = true;

      // Vibración continua muy intensa
      if (await Vibration.hasVibrator() ?? false) {
        Vibration.vibrate(duration: 5000, amplitude: 255);
      }

      // Sirena de emergencia
      await _alertPlayer.play(
        AssetSource('sounds/emergency_siren.wav'),
        volume: 1.0,
      );
      await _alertPlayer.setReleaseMode(ReleaseMode.loop);
    } catch (e) {
      print('Error reproduciendo sirena de emergencia: $e');
      _isPlaying = false;
    }
  }

  /// Detener todos los sonidos
  Future<void> stopAllSounds() async {
    _isPlaying = false;
    _currentAlertLevel = null;

    await _alertPlayer.stop();
    await _backgroundPlayer.stop();

    // Detener vibración
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.cancel();
    }
  }

  /// Pausar temporalmente (sin detener completamente)
  Future<void> pause() async {
    await _alertPlayer.pause();
    await _backgroundPlayer.pause();
  }

  /// Reanudar sonidos
  Future<void> resume() async {
    if (_isPlaying) {
      await _alertPlayer.resume();
      await _backgroundPlayer.resume();
    }
  }

  /// Liberar recursos
  void dispose() {
    _alertPlayer.dispose();
    _backgroundPlayer.dispose();
  }
}

// =======================================================
// EXTENSIÓN: Generar sonidos programáticamente si no tienes archivos
// =======================================================

class SynthesizedAlertSounds {
  /// Genera un beep sintético usando frecuencias
  /// Útil si no tienes archivos de audio
  static Future<void> playBeep({
    required int frequency,
    required int duration,
    required double volume,
  }) async {
    // Nota: Esto requiere implementación nativa o usar tone_generator
    // Por ahora, usar SystemSound como fallback
    await SystemSound.play(SystemSoundType.alert);
  }

  /// Simular alerta con sonidos del sistema
  static Future<void> playSystemAlert(AlertLevel level) async {
    switch (level) {
      case AlertLevel.low:
        await SystemSound.play(SystemSoundType.click);
        break;
      case AlertLevel.medium:
        for (int i = 0; i < 2; i++) {
          await SystemSound.play(SystemSoundType.alert);
          await Future.delayed(const Duration(milliseconds: 500));
        }
        break;
      case AlertLevel.high:
        for (int i = 0; i < 3; i++) {
          await SystemSound.play(SystemSoundType.alert);
          await Future.delayed(const Duration(milliseconds: 300));
        }
        break;
      case AlertLevel.critical:
        // Reproducir múltiples veces muy rápido
        for (int i = 0; i < 10; i++) {
          await SystemSound.play(SystemSoundType.alert);
          await Future.delayed(const Duration(milliseconds: 200));
        }
        break;
    }
  }
}
