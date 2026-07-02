import 'dart:io';

import 'package:flutter/material.dart';
import 'package:outfit_customizer_1/features/builder/screens/outfit_builder_screen.dart';

import '../../../database/database_helper.dart';
import '../../../models/clothing_item.dart';
import '../../../models/outfit.dart';

class OutfitDetailsScreen extends StatefulWidget {
  final Outfit outfit;

  const OutfitDetailsScreen({
    super.key,
    required this.outfit,
  });

  @override
  State<OutfitDetailsScreen> createState() =>
      _OutfitDetailsScreenState();
}

class _OutfitDetailsScreenState
    extends State<OutfitDetailsScreen> {

  ClothingItem? top;
  ClothingItem? bottom;
  ClothingItem? shoes;

  List<ClothingItem> extras = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadItems();
  }

  Future<void> loadItems() async {

    top = await DatabaseHelper.instance
        .getClothingById(widget.outfit.topId);

    bottom = await DatabaseHelper.instance
        .getClothingById(widget.outfit.bottomId);

    shoes = await DatabaseHelper.instance
        .getClothingById(widget.outfit.shoesId);

    extras.clear();

    for (final id in widget.outfit.extraItemIds) {

      final item =
          await DatabaseHelper.instance
              .getClothingById(id);

      if (item != null) {
        extras.add(item);
      }
    }

    setState(() {
      loading = false;
    });
  }

  Widget imageTile(ClothingItem? item) {

    if (item == null) {
      return Container(
        color: Colors.grey.shade200,
      );
    }

    return Image.file(
      File(item.imagePath),
      fit: BoxFit.cover,
    );
  }

  Widget itemRow(ClothingItem item) {

    return ListTile(

      leading: ClipRRect(
        borderRadius:
            BorderRadius.circular(10),

        child: Image.file(
          File(item.imagePath),
          width: 55,
          height: 55,
          fit: BoxFit.cover,
        ),
      ),

      title: Text(item.name),

      subtitle: Text(
          "${item.category} "),
    );
  }

  @override
  Widget build(BuildContext context) {

    if (loading) {
      return const Scaffold(
        body: Center(
          child:
              CircularProgressIndicator(),
        ),
      );
    }

    final allItems = [

      if (top != null) top!,
      if (bottom != null) bottom!,
      if (shoes != null) shoes!,

      ...extras,
    ];

    return Scaffold(

      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBar(

        backgroundColor:
            Colors.transparent,

        elevation: 0,

        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title:
            const Text("Outfit Details"),

        centerTitle: true,

        actions: const [

          Padding(
            padding:
                EdgeInsets.only(right: 16),

            child: CircleAvatar(
              backgroundImage: AssetImage(
                "assets/images/profile.jpg",
              ),
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(

        padding:
            const EdgeInsets.all(16),

        child: Column(

          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            AspectRatio(

              aspectRatio: 1,

              child: GridView.count(

                physics:
                    const NeverScrollableScrollPhysics(),

                crossAxisCount: 2,

                children: [

                  imageTile(top),

                  imageTile(
                    extras.isNotEmpty
                        ? extras.first
                        : bottom,
                  ),

                  imageTile(bottom),

                  imageTile(shoes),
                ],
              ),
            ),

            const SizedBox(height: 25),

            Text(
              widget.outfit.name,
              style: const TextStyle(
                fontSize: 26,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              "Created on ${widget.outfit.createdAt.day}/${widget.outfit.createdAt.month}/${widget.outfit.createdAt.year}",
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),

            const SizedBox(height: 30),

            Row(

              children: [

                const Text(
                  "Included Items",

                  style: TextStyle(
                    fontSize: 22,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const Spacer(),

                Text(
                  "${allItems.length} Items",
                )
              ],
            ),

            const SizedBox(height: 10),

            ...allItems.map(itemRow),

            const SizedBox(height: 30),

            SizedBox(

              width: double.infinity,

              child: OutlinedButton.icon(

                icon: const Icon(Icons.edit),

                label:
                    const Text("Edit Outfit"),

                onPressed: () {

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => OutfitBuilderPage(
                        outfit:  widget.outfit,
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(

              width: double.infinity,

              child: OutlinedButton.icon(

                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                ),

                label: const Text(
                  "Delete",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),

                onPressed: () async {

                  await DatabaseHelper.instance
                      .deleteOutfit(
                          widget.outfit.id!);

                  if (mounted) {

                    Navigator.pop(
                        context, true);
                  }
                },
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}