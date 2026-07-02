import 'package:flutter/material.dart';
import 'package:outfit_customizer_1/database/database_helper.dart';
import 'package:outfit_customizer_1/models/clothing_item.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class AddClothingScreen extends StatefulWidget {
  const AddClothingScreen({super.key});

  @override
  State<AddClothingScreen> createState() => _AddClothingScreenState();
}

class _AddClothingScreenState extends State<AddClothingScreen> {
  final TextEditingController nameController = TextEditingController();

  String selectedCategory = "Shirt";

  File? selectedImage;

  Future<void> pickImage() async {

    final picker = ImagePicker();

    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }

  final List<String> categories = [
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
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Add Clothing"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: pickImage,
              child: Container(
                height: 220,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: selectedImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(
                          selectedImage!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_a_photo,size:50),
                          SizedBox(height:10),
                          Text("Tap to Add Image"),
                        ],
                      ),
              ),
            ),

            const SizedBox(height: 24),

            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Clothing Name",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            DropdownButtonFormField<String>(
              value: selectedCategory,
              decoration: const InputDecoration(
                labelText: "Category",
                border: OutlineInputBorder(),
              ),
              items: categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value!;
                });
              },
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () async {

                if (nameController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please enter clothing name"),
                    ),
                  );
                  return;
                }

                if (selectedImage == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please select an image"),
                    ),
                  );
                  return;
                }
                
                final clothingItem = ClothingItem(
                  name: nameController.text.trim(),
                  category: selectedCategory,
                  color: "Unknown",
                  imagePath: selectedImage?.path ?? "",
                  createdAt: DateTime.now(),
                );

                await DatabaseHelper.instance.insertClothing(
                  clothingItem,
                );

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Clothing Saved"),
                    ),
                  );

                  Navigator.pop(context);
                }
              },
                child: const Text(
                  "Save Clothing",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}