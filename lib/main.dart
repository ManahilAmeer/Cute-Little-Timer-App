import 'dart:async';
import 'package:flutter/material.dart';
import 'package:itsy_timer/main_page.dart';
import 'package:lottie/lottie.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const EggTimerApp());
}

class EggTimerApp extends StatelessWidget {
  const EggTimerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Cute Egg Timer",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow),
        useMaterial3: true,
        textTheme: GoogleFonts.pressStart2pTextTheme()
      ),
      home: MainPage(),
    );
  }
}

class EggTimerHome extends StatefulWidget {
  const EggTimerHome({super.key});

  @override
  State<EggTimerHome> createState() => _EggTimerHomeState();
}

class _EggTimerHomeState extends State<EggTimerHome>
    with TickerProviderStateMixin {
  int _selectedTime = 0; // seconds
  int _remaining = 0;
  Timer? _timer;

  late AnimationController _wiggleController;
  final player = AudioPlayer();

  final eggOptions = {
    "Soft 🥚": {
      "time": .25 * 60,
      "color": Colors.pink[100],
    },
    "Medium 🍳": {
      "time": 7 * 60,
      "color": Colors.orange[100],
    },
    "Hard 🍽️": {
      "time": 10 * 60,
      "color": Colors.brown[100],
    },
  };

  @override
  void initState() {
    super.initState();

    // Wiggle animation
    _wiggleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  void _startTimer() {
    if (_selectedTime == 0) return;
    setState(() {
      _remaining = _selectedTime;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remaining > 0) {
          _remaining--;
        } else {
          timer.cancel();
          _showCrackAnimation();
          _playSound();
        }
      });
    });
  }

  void _playSound() async {
    await player.play(AssetSource("egg-crack.mp3")); // add cute sound in assets
  }

  void _showCrackAnimation() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.yellow[50],
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset("assets/animations/egg_crack.json", // add cute egg crack animation
              repeat: true,
              height: 150,
            ),
            const SizedBox(height: 12),
            const Text(
              "Yay! Your egg is ready 🍳✨",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Enjoy 💛"),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  @override
  Widget build(BuildContext context) {
    // background based on selected egg type
    Color? bg = Colors.yellow[50];
    if (_selectedTime != 0) {
      final entry = eggOptions.values
          .firstWhere((e) => e["time"] == _selectedTime, orElse: () => {});
      bg = entry["color"] as Color?;
    }

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: const Text("🥚 Cute Egg Timer"),
        centerTitle: true,
      ),
      body:
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Egg options
          Wrap(
            spacing: 12,
            children: eggOptions.entries.map((entry) {
              return ChoiceChip(
                label: Text(entry.key),
                selected: _selectedTime == entry.value["time"],
                onSelected: (_) {
                  setState(() {
                    _selectedTime = entry.value["time"] as int;
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 40),

          // Egg wiggle + timer
          RotationTransition(
            turns: Tween(begin: -0.02, end: 0.02).animate(_wiggleController),
            child: Image.asset(
              "assets/images/egg.png", // cute egg icon
              height: 120,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            _formatTime(_remaining),
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.brown,
            ),
          ),

          const SizedBox(height: 40),

          // Start Button
          ElevatedButton(
            onPressed: _startTimer,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orangeAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
            ),
            child: const Text(
              "Start Timer ⏳",
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _wiggleController.dispose();
    player.dispose();
    super.dispose();
  }
}
