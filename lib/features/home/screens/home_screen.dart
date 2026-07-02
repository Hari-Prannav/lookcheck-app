
import 'package:flutter/material.dart';
import 'package:outfit_customizer_1/models/recent_outfit.dart';

import '../../builder/screens/outfit_builder_screen.dart';
import '../../outfit/screens/saved_outfit_screen.dart';
import '../../wardrobe/screens/wardrobe_screen.dart';

import '../widgets/home_feature_card.dart';

import 'package:outfit_customizer_1/database/database_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  List<RecentOutfit> recentOutfits = [];

  @override
  void initState() {
    super.initState();
    loadRecentOutfits();
  }

  Future<void> loadRecentOutfits() async {
    final outfits =
        await DatabaseHelper.instance.getAllOutfits();

    List<RecentOutfit> loaded = [];

    for (final outfit in outfits.take(2)) {
      final top =
          await DatabaseHelper.instance.getClothingById(outfit.topId);

      loaded.add(
        RecentOutfit(
          outfit: outfit,
          top: top,
        ),
      );
    }

    if (!mounted) return;

    setState(() {
      recentOutfits = loaded;
    });
  }
  
  
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      body: SafeArea(
        child: SingleChildScrollView(

          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,

                children: [

                  const Text(
                    "Wardrobe Planner",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  CircleAvatar(
                    radius: 22,
                    backgroundImage:AssetImage(
                      "assets/images/profile.jpg",
                      ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              const Text(
                "Hello, HP!",
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                "Ready to find your perfect look today?",
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 30),

              HomeFeatureCard(
                title: "Wardrobe",
                subtitle: "Manage your clothes",
                icon: Icons.checkroom,
                imagePath: "assets/images/wardrobe.jpg",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const WardrobePage(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              HomeFeatureCard(
                title: "Builder",
                subtitle: "Mix & Match",
                icon: Icons.style,
                imagePath: "assets/images/builder.jpg",
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const OutfitBuilderPage(),
                    ),
                  );
                  loadRecentOutfits();
                },
              ),

              const SizedBox(height: 16),

              HomeFeatureCard(
                title: "Saved Outfits",
                subtitle: "View outfits",
                icon: Icons.dry_cleaning,
                imagePath: "assets/images/outfit.jpg",
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const SavedOutfitPage(),
                    ),
                  );
                },
              ),

              
            ],
          ),
        ),
      ),
    );
  }
}