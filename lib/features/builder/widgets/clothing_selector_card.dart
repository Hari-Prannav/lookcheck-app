import 'dart:io';

import 'package:flutter/material.dart';
import '../../../models/clothing_item.dart';

class ClothingSelectorCard extends StatelessWidget {
  final ClothingItem cloth;
  final VoidCallback onTap;

  const ClothingSelectorCard({
    super.key,
    required this.cloth,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,

      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),

        child: Image.file(
          File(cloth.imagePath),
          width: 60,
          height: 60,
          fit: BoxFit.cover,
        ),
      ),

      title: Text(cloth.name),

      subtitle: Text(
        "${cloth.category} • ${cloth.color}",
      ),
    );
  }
}