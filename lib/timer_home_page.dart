import 'package:flutter/material.dart';
import 'EggTimerPage.dart';

class EggHomePage extends StatefulWidget {
  final Map<String, Map<String, Object?>> eggOptions;

  final animationAsset;
  const EggHomePage({super.key,required this.eggOptions, required this.animationAsset});
  @override
  _EggHomePageState createState() => _EggHomePageState();

}

class _EggHomePageState extends State<EggHomePage> with TickerProviderStateMixin {
  int _selectedTime = 0; // seconds
  late AnimationController _wiggleController;


  @override
  void initState() {
    super.initState();

    // Wiggle animation
    _wiggleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "🥚 Cute Egg Timer",
          style: TextStyle(color: Colors.grey[800]),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
                Wrap(
                  spacing: 12,
                  children: widget.eggOptions.entries.map((entry) {
                    return Column(
                      children: [
                        RotationTransition(
                          turns: Tween(begin: -0.02, end: 0.02).animate(_wiggleController),
                          child: Image.asset(
                            entry.value["assets"] as String, // cute egg icon
                            height: 120,
                          ),
                        ),
                        // Image.asset(entry.value["assets"] as String,height: 120),
                        const SizedBox(height: 20),

                        // Text(entry.value["assets"] as String),
                        ChoiceChip(
                          label: Text(entry.key,),
                          selected: _selectedTime == entry.value["time"],
                          onSelected: (_) {
                            setState(() {
                              _selectedTime = entry.value["time"] as int;
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EggTimerPage(
                                  seconds: _selectedTime,
                                  label: entry.key,
                                  imageAsset: entry.value["assets"] as String,
                                  animationAsset : widget.animationAsset ,
                                ),
                              ),
                            );
                          }
                          ,
                        )
                      ],
                    );
                  }).toList()
                )
              ],

            ),
      ),
    );
  }
}
