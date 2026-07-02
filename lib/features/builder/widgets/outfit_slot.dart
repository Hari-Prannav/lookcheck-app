import 'dart:io';
import 'package:flutter/material.dart';
import '../../../models/clothing_item.dart';

class OutfitSlot extends StatelessWidget {
  final String title;
  final ClothingItem? item;

  const OutfitSlot({
    super.key,
    required this.title,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: item == null
    ? Center(
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
      )
    : ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.file(
              File(item!.imagePath),
              fit: BoxFit.cover,
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.black54,
                padding: const EdgeInsets.all(8),
                child: Text(
                  item!.name,
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}