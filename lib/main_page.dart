import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itsy_timer/timer_home_page.dart';

import 'menuCard.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  // const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow),
          useMaterial3: true,
          textTheme: GoogleFonts.pressStart2pTextTheme()
      ),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final List<MenuItem> items = [
    MenuItem(
        title: "Cooking Rice",
        subtitle: "Perfect fluffy rice every time",
        icon: "assets/images/rice-bowl.png",
        pageInfo: PageInfo(
            nextPage: EggHomePage(eggOptions: {
          "White Rice ": {"time": 18 * 60, "color": Colors.pink[100], "assets": "assets/images/rice-bowl.png"},
          "Brown Rice": {"time": 45 * 60, "color": Colors.orange[100], "assets": "assets/images/egg.png"},
          "Jasmine Rice": {"time": 15 * 60, "color": Colors.brown[100], "assets": "assets/images/hard-boiled-egg.png"},
          "Basmati Rice": {"time": 20 * 60, "color": Colors.brown[100], "assets": "assets/images/hard-boiled-egg.png"},
        }))),
    MenuItem(
        title: "Laundry",
        subtitle: "Washing and drying clothes",
        icon: "assets/images/shirt.png",
        pageInfo: PageInfo(
            nextPage: EggHomePage(eggOptions: {
          "Quick Wash": {"time": .5 * 60, "color": Colors.pink.shade100, "assets": "assets/images/soft-boiled-egg.png"},
          "Regular Wash": {"time": 17 * 60, "color": Colors.orange[100], "assets": "assets/images/egg.png"},
          "Heavy Duty Wash": {"time": 30 * 60, "color": Colors.brown[100], "assets": "assets/images/hard-boiled-egg.png"},
          "Drying": {"time": 15 * 60, "color": Colors.brown[100], "assets": "assets/images/hard-boiled-egg.png"},
        })
        )),
    MenuItem(
        title: "Boiling Eggs",
        subtitle: "Soft, medium, or hard boiled",
        icon: "assets/images/boiling_egg.png",
        pageInfo: PageInfo(
            nextPage: EggHomePage(
          eggOptions: {
            "Soft 🥚": {"time": .25 * 60, "color": Colors.pink[100], "assets": "assets/images/soft-boiled-egg.png"},
            "Medium 🍳": {"time": 7 * 60, "color": Colors.orange[100], "assets": "assets/images/egg.png"},
            "Hard 🍽️": {"time": 10 * 60, "color": Colors.brown[100], "assets": "assets/images/hard-boiled-egg.png"},
          },
        ))),
  ];

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFDEBEB), Color(0xFFE9F1FD)], // soft gradient
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
              const Text(
                "What would you like to do today?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 24),

              // Scrollable list of cards
              Expanded(
                child:ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return MenuCard(
                      image: item.icon,
                      title: item.title,
                      subtitle: item.subtitle,
                      pageInfo: item.pageInfo,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PageInfo {
  final EggHomePage nextPage;
  // final Object options;

  PageInfo({required this.nextPage});
}

class MenuItem {
  final String title;
  final String subtitle;
  final String icon;
  final PageInfo pageInfo;

  MenuItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.pageInfo,
  });
}
