import 'dart:async';

import 'package:flutter/widgets.dart';

/// Обёртка для интерактивных элементов с визуальным откликом на нажатие.
///
/// Хранит состояние «нажато» и передаёт его в [builder]. Коллбэк [onTap]
/// вызывается сразу после отпускания пальца, а отжатое состояние при быстром
/// тапе удерживается ещё не менее [minPressedDuration], чтобы анимация
/// успела быть заметной — без задержки самого действия.
class Pressable extends StatefulWidget {
  /// Обработчик нажатия.
  final VoidCallback? onTap;

  /// Минимальное время отображения нажатого состояния при быстром тапе.
  final Duration minPressedDuration;

  /// Строит содержимое в зависимости от состояния нажатия.
  final Widget Function(BuildContext context, bool isPressed) builder;

  const Pressable({
    super.key,
    required this.onTap,
    required this.builder,
    this.minPressedDuration = Duration.zero,
  });

  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable> {
  final Stopwatch _pressStopwatch = Stopwatch();
  Timer? _releaseTimer;
  bool _isPressed = false;

  @override
  void dispose() {
    _releaseTimer?.cancel();
    super.dispose();
  }

  void _setPressed(bool value) {
    if (mounted && _isPressed != value) {
      setState(() => _isPressed = value);
    }
  }

  void _handleTapDown(TapDownDetails _) {
    _releaseTimer?.cancel();
    _pressStopwatch
      ..reset()
      ..start();
    _setPressed(true);
  }

  void _handleTapUp(TapUpDetails _) {
    final remaining = widget.minPressedDuration - _pressStopwatch.elapsed;
    if (remaining <= Duration.zero) {
      _setPressed(false);
    } else {
      _releaseTimer = Timer(remaining, () => _setPressed(false));
    }
  }

  void _handleTapCancel() {
    _releaseTimer?.cancel();
    _setPressed(false);
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: widget.onTap,
        child: widget.builder(context, _isPressed),
      ),
    );
  }
}
