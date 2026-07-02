import 'package:flutter/material.dart';

import 'clothing_picker_screen.dart';

import '../../../database/database_helper.dart';
import '../../../models/clothing_item.dart';

import '../widgets/outfit_slot.dart';

import 'package:outfit_customizer_1/models/outfit.dart';

class OutfitBuilderPage extends StatefulWidget {

  final Outfit? outfit;

  const OutfitBuilderPage({super.key, this.outfit});

  @override
  State<OutfitBuilderPage> createState() =>
      _OutfitBuilderPageState();
}

class _OutfitBuilderPageState
    extends State<OutfitBuilderPage> {
  List<ClothingItem> clothes = [];

  ClothingItem? selectedTop;
  ClothingItem? selectedBottom;
  ClothingItem? selectedShoes;


  List<ClothingItem> selectedExtras = [];

  final TextEditingController nameController =
    TextEditingController();


  Future<void> loadExistingOutfit() async {
    final outfit = widget.outfit!;

    selectedTop =
        await DatabaseHelper.instance.getClothingById(outfit.topId);

    selectedBottom =
        await DatabaseHelper.instance.getClothingById(outfit.bottomId);

    selectedShoes =
        await DatabaseHelper.instance.getClothingById(outfit.shoesId);

    // Load extras
    selectedExtras.clear();

    for (final id in outfit.extraItemIds) {
      final cloth =
          await DatabaseHelper.instance.getClothingById(id);

      if (cloth != null) {
        selectedExtras.add(cloth);
      }
    }

    nameController.text = outfit.name;

    setState(() {});
  }


  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    loadClothes();

    if (widget.outfit != null) {
      loadExistingOutfit();
    }
  }


  Future<void> pickTop() async {
    final ClothingItem? item =
        await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ClothingPickerScreen(
          categories: [
            "Shirt",
            "T-Shirt",
          ],
        ),
      ),
    );

    if (item != null) {
      setState(() {
        selectedTop = item;
      });
    }
  }

  Future<void> pickBottom() async {
    final ClothingItem? item =
        await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ClothingPickerScreen(
          categories: [
            "Pant",
            "Jeans",
            "Shorts",
          ],
        ),
      ),
    );

    if (item != null) {
      setState(() {
        selectedBottom = item;
      });
    }
  }

  Future<void> pickShoes() async {
    final ClothingItem? item =
        await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ClothingPickerScreen(
          categories: [
            "Shoes",
          ],
        ),
      ),
    );

    if (item != null) {
      setState(() {
        selectedShoes = item;
      });
    }
  }


  Future<void> pickExtraItem() async {
    final ClothingItem? item =
        await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ClothingPickerScreen(
          categories: ["All"],
        ),
      ),
    );

    if (item != null) {
      setState(() {
        if (!selectedExtras.any((e) => e.id == item.id)) {
          selectedExtras.add(item);
        }
      });
    }
  }



  Future<void> saveOutfit() async {

  // Validate required slots
    if (selectedTop == null ||
        selectedBottom == null ||
        selectedShoes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please select Top, Bottom and Shoes.",
          ),
        ),
      );
      return;
    }

    // Validate outfit name
    if (nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please enter an outfit name.",
          ),
        ),
      );
      return;
    }

    // Save to database
    if (widget.outfit == null) {
      await DatabaseHelper.instance.insertOutfit(
        Outfit(
          name: nameController.text.trim(),
          topId: selectedTop!.id,
          bottomId: selectedBottom!.id,
          shoesId: selectedShoes!.id,
          extraItemIds: selectedExtras
              .map((item) => item.id!)
              .toList(),
          createdAt: DateTime.now(),
        ),
      );
    } else {
      await DatabaseHelper.instance.updateOutfit(
        Outfit(
          id: widget.outfit!.id,
          name: nameController.text.trim(),
          topId: selectedTop!.id,
          bottomId: selectedBottom!.id,
          shoesId: selectedShoes!.id,
          extraItemIds: selectedExtras
              .map((item) => item.id!)
              .toList(),
          createdAt: widget.outfit!.createdAt,
        ),
      );
    }

    // Clear builder after saving
    setState(() {
      selectedTop = null;
      selectedBottom = null;
      selectedShoes = null;

      selectedExtras.clear();

      nameController.clear();
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Outfit Saved Successfully"),
        ),
      );
    }
  }

  Future<void> loadClothes() async {
    final data =
        await DatabaseHelper.instance.getAllClothes();

    setState(() {
      clothes = data;
    });
  }

  bool isTopWear(String category) {
    return [
      "Shirt",
      "T-Shirt",
    ].contains(category);
  }

  bool isBottomWear(String category) {
    return [
      "Pant",
      "Jeans",
      "Shorts"
    ].contains(category);
  }

  bool isShoes(String category) {
    return [
      "Shoes",
    ].contains(category);
  }

  void selectClothing(ClothingItem cloth) {
    setState(() {
      if (isTopWear(cloth.category)) {
        selectedTop = cloth;
      } else if (isBottomWear(cloth.category)) {
        selectedBottom = cloth;
      } else if (isShoes(cloth.category)) {
        selectedShoes = cloth;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      
      appBar: AppBar(
        title: const Text("Outfit Builder"),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundImage: AssetImage("assets/images/profile.jpg"),
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            children: [

                const SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: "Outfit Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),

                Padding(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),

                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: pickTop,
                        child: OutfitSlot(
                          title: "Select Top Wear",
                          item: selectedTop,
                        ),
                      ),

                      const SizedBox(height: 12),

                      GestureDetector(
                        onTap: pickBottom,
                        child: OutfitSlot(
                          title: "Select Bottom Wear",
                          item: selectedBottom,
                        ),
                      ),

                      const SizedBox(height: 12),

                      GestureDetector(
                        onTap: pickShoes,
                        child: OutfitSlot(
                          title: "Select Shoes",
                          item: selectedShoes,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                const Divider(),

                const SizedBox(height: 15),

                Column(
                  children: [

                    ...selectedExtras.map(
                      (cloth) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: OutfitSlot(
                          title: cloth.name,
                          item: cloth,
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: pickExtraItem,

                      child: OutfitSlot(
                        title: "+ Style More (Optional)",
                        item: null,
                      ),
                    ),

                  ],
                ),

                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      onPressed: saveOutfit,

                      icon: const Icon(Icons.check_circle_outline),

                      label: const Text(
                        "Save Outfit",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                    ),
                  ),
                ),
                  const SizedBox(height: 20),
              ],
      ),
    )
    ));
  }
}