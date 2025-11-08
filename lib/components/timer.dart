import 'dart:async';
import 'package:flutter/material.dart';

class OneMinuteTimer extends StatefulWidget {
  const OneMinuteTimer({super.key});

  @override
  State<OneMinuteTimer> createState() => _OneMinuteTimerState();
}

class _OneMinuteTimerState extends State<OneMinuteTimer> {
  static const int _totalSeconds = 60;
  late int _remainingSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _remainingSeconds = _totalSeconds;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds <= 1) {
        timer.cancel();
        setState(() => _remainingSeconds = 0);
      } else {
        setState(() => _remainingSeconds--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get formattedTime {
    final minutes = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          formattedTime,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: _startTimer,
          child: const Text('Restart Timer'),
        ),
      ],
    );
  }
}
