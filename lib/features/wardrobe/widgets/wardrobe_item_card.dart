import 'dart:io';

import 'package:flutter/material.dart';
import '../../../models/clothing_item.dart';

class WardrobeItemCard extends StatelessWidget {
  final ClothingItem cloth;
  final VoidCallback onDelete;

  const WardrobeItemCard({
    super.key,
    required this.cloth,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onDelete,

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Expanded(
            child: ClipRRect(
              borderRadius:
                  BorderRadius.circular(18),

              child: Stack(
                children: [
                  Positioned.fill(
                    child: cloth.imagePath.isNotEmpty
                        ? Image.file(
                            File(cloth.imagePath),
                            fit: BoxFit.cover,
                            errorBuilder:
                                (_, __, ___) =>
                                    const Icon(
                              Icons.broken_image,
                            ),
                          )
                        : Container(
                            color: Colors.grey.shade200,
                            child: const Icon(
                              Icons.checkroom,
                              size: 50,
                            ),
                          ),
                  ),

                ],
              ),
            ),
          ),

          const SizedBox(height: 8),

          Text(
            cloth.category.toUpperCase(),
            style: const TextStyle(
              fontSize: 11,
              color: Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            cloth.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}