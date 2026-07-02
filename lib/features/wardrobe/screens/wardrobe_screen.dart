import 'package:flutter/material.dart';
import 'package:outfit_customizer_1/database/database_helper.dart';
import 'package:outfit_customizer_1/models/clothing_item.dart';

import '../widgets/category_chip.dart';
import '../widgets/wardrobe_item_card.dart';
import 'add_clothing_screen.dart';

class WardrobePage extends StatefulWidget {
  const WardrobePage({super.key});

  @override
  State<WardrobePage> createState() =>
      _WardrobePageState();
}

class _WardrobePageState
    extends State<WardrobePage> {

  final TextEditingController searchController =
    TextEditingController();

  String searchText = "";

  String selectedCategory = "All Items";

  List<ClothingItem> clothes = [];

  final List<String> categories = [
    "All Items",
    "Shirt",
    "T-Shirt",
    "Pant",
    "Jeans",
    "Shorts",
    "Shoes",
    "Jacket",
    "Accessories",
  ];

  @override
  void initState() {
    super.initState();
    loadClothes();
  }

  Future<void> loadClothes() async {
    final data =
        await DatabaseHelper.instance.getAllClothes();

    setState(() {
      clothes = data;
    });
  }

  

  @override
  Widget build(BuildContext context) {
    
    List<ClothingItem> filteredClothes = clothes.where((cloth) {

      final searchMatch =
          cloth.name.toLowerCase().contains(searchText.toLowerCase()) ||

          cloth.category.toLowerCase().contains(searchText.toLowerCase());

      final categoryMatch =
          selectedCategory == "All Items" ||

          cloth.category.toLowerCase() ==
              selectedCategory.toLowerCase();

      return searchMatch && categoryMatch;

    }).toList();
    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      floatingActionButton:
          FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,

        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  const AddClothingScreen(),
            ),
          );

          loadClothes();
        },

        child: const Icon(Icons.add),
      ),

      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 20,
          ),

          child: Column(
            children: [
              const SizedBox(height: 10),

              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),

                  const Expanded(
                    child: Text(
                      "My Wardrobe",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),

                  const CircleAvatar(
                    radius: 22,
                    backgroundImage: AssetImage(
                      "assets/images/profile.jpg",
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              TextField(
                controller: searchController,

                onChanged: (value) {
                  setState(() {
                    searchText = value;
                  });
                },

                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: "Search your closet...",
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                height: 45,

                child: ListView.builder(
                  scrollDirection:
                      Axis.horizontal,

                  itemCount: categories.length,

                  itemBuilder:
                      (context, index) {
                    return CategoryChip(
                      title:
                          categories[index],

                      
                      selected: selectedCategory == categories[index],

                      onTap: () {
                        setState(() {
                          selectedCategory =
                              categories[index];
                        });
                      },
                    );
                  },
                ),
              ),

              

              const SizedBox(height: 20),

              Expanded(
                child: clothes.isEmpty
                    ? const Center(
                        child: Text(
                          "No Clothes Added Yet",
                        ),
                      )
                    : GridView.builder(
                        itemCount: filteredClothes.length,

                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              2,
                          crossAxisSpacing:
                              16,
                          mainAxisSpacing:
                              16,
                          childAspectRatio:
                              0.60,
                        ),

                        itemBuilder:
                            (context, index) {
                          final cloth =
                              filteredClothes[index];

                          return WardrobeItemCard(
                            cloth: cloth,

                            onDelete:
                                () async {
                              await DatabaseHelper
                                  .instance
                                  .deleteClothing(
                                cloth.id!,
                              );

                              loadClothes();

                              if (mounted) {
                                ScaffoldMessenger.of(
                                        context)
                                    .showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text(
                                      "Item Deleted",
                                    ),
                                  ),
                                );
                              }
                            },
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