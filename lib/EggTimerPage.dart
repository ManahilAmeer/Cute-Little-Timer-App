import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:audioplayers/audioplayers.dart';
import 'RoundedProgress.dart';

class EggTimerPage extends StatefulWidget {
  final int seconds;
  final String label;
  final String imageAsset;

  final animationAsset;

  const EggTimerPage({
    Key? key,
    required this.seconds,
    required this.label,
    required this.imageAsset,
    required this.animationAsset
  }) : super(key: key);

  @override
  _EggTimerPageState createState() => _EggTimerPageState();
}

class _EggTimerPageState extends State<EggTimerPage> with TickerProviderStateMixin {
  late int _remaining;
  Timer? _timer;
  bool _done = false;
  final label = "Label";
  final _player = AudioPlayer();

  late AnimationController _boilController;

  @override
  void initState() {
    super.initState();
    _remaining = widget.seconds;
    // Timer countdown
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_remaining > 0) {
        setState(() => _remaining--);
      } else {
        t.cancel();
        _onTimerDone();
      }
    });

    // Boiling wiggle
    _boilController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
  }

  void _onTimerDone() async {
    setState(() => _done = true);
    await _player.play(AssetSource("egg-crack.mp3"));
  }
  void bounce() {
    _boilController.forward(from: 0.0);
  }


  @override
  void dispose() {
    _timer?.cancel();
    _player.dispose();
    _boilController.dispose();
    super.dispose();
  }

  double get _progress {
    return 1 - (_remaining / widget.seconds);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _done ? Colors.yellow[100] : Colors.white,
      appBar: AppBar(
        title: Text(widget.label),
        backgroundColor: _done ? Colors.yellow[100] : Colors.orange[100],
      ),
      body: Center(
        child: _done
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Crack animation
            Lottie.asset(widget.animationAsset, width: 400),
            const SizedBox(height: 30),

            Text('Your ${widget.label}  is ready! 🎉', style: const TextStyle(fontSize: 30)),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Back"),
            ),
          ],
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                RoundedProgress(progress: _progress),
                // ScaleTransition(scale: CurvedAnimation(
                //   parent: _boilController,
                //   curve: Curves.bounceOut
                // ),
                //   child: GestureDetector(
                //     onTap: bounce,
                //     child: Image.asset(widget.imageAsset, height: 120),
                //   ),
                // ),
                RotationTransition(
                  turns: Tween(begin: -0.03, end: 0.03).animate(_boilController),
                  child: Image.asset(widget.imageAsset, height: 120),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Your ${widget.label} will be ready in...',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            Text(
              _formatTime(_remaining),
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: _pauseOrResumeTimer,
              child: Text(!_isPaused == true ? "Pause Timer" : "Resume Timer"),
            )

          ],
        ),
      ),
    );
  }

  String _formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return "$m:$s";
  }
  bool _isPaused = false;


  void _pauseOrResumeTimer() {
    if (_isPaused) {
      // Resume
      _timer = Timer.periodic(const Duration(seconds: 1), (t) {
        if (_remaining > 0) {
          setState(() => _remaining--);
        } else {
          t.cancel();
          _onTimerDone();
        }
      });
    } else {
      // Pause
      _timer?.cancel();
    }

    setState(() {
      _isPaused = !_isPaused;
    });
  }


}
