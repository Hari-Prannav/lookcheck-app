import 'dart:io';

import 'package:flutter/material.dart';
import 'package:outfit_customizer_1/database/database_helper.dart';
import 'package:outfit_customizer_1/models/clothing_item.dart';

class ClothingPickerScreen extends StatefulWidget {
  final List<String> categories;

  const ClothingPickerScreen({
    super.key,
    required this.categories,
  });

  @override
  State<ClothingPickerScreen> createState() =>
      _ClothingPickerScreenState();
}

class _ClothingPickerScreenState
    extends State<ClothingPickerScreen> {
  List<ClothingItem> clothes = [];

  @override
  void initState() {
    super.initState();
    loadClothes();
  }

  Future<void> loadClothes() async {
    final data =
        await DatabaseHelper.instance.getAllClothes();

    setState(() {
      clothes = data.where((cloth) {
        if (widget.categories.contains("All")) {
          return true;
        }

        return widget.categories.contains(cloth.category);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Clothing"),
      ),

      body: clothes.isEmpty
          ? const Center(
              child: Text("No clothes found"),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),

              itemCount: clothes.length,

              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: .68,
              ),

              itemBuilder: (context, index) {
                final cloth = clothes[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.pop(context, cloth);
                  },

                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10),

                      child: Column(
                        children: [

                          Expanded(
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(12),

                              child: Image.file(
                                File(cloth.imagePath),
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            cloth.name,
                            style: const TextStyle(
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          Text(cloth.category),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}