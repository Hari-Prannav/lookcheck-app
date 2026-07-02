import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/clothing_item.dart';
import '../../../models/outfit.dart';

import 'package:outfit_customizer_1/features/outfit/screens/outfit_detail_screen.dart';

class OutfitCard extends StatelessWidget {

  final Outfit outfit;

  final ClothingItem? top;
  final ClothingItem? bottom;
  final ClothingItem? shoes;

  final VoidCallback onRefresh;

  const OutfitCard({
    super.key,
    required this.outfit,
    required this.top,
    required this.bottom,
    required this.shoes,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {

    final includedItems = <String>[
      if (top != null) top!.name,
      if (bottom != null) bottom!.name,
      if (shoes != null) shoes!.name,
    ];
      return InkWell(
        borderRadius: BorderRadius.circular(28),

        onTap: () async {

          final deleted =
              await Navigator.push(

            context,

            MaterialPageRoute(
              builder: (_) =>
                  OutfitDetailsScreen(
                outfit: outfit,
              ),
            ),
          );

          if (deleted == true && context.mounted) {
            onRefresh();
          }
        },

        child: Container(
          margin: const EdgeInsets.only(bottom: 20),

          padding: const EdgeInsets.all(22),

          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius:
                BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.05),
                blurRadius: 12,
              )
            ],
          ),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              Text(
                outfit.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 18),

              ...includedItems.map(
                (item) => Padding(
                  padding:
                      const EdgeInsets.only(bottom: 6),
                  child: Text(
                    "• $item",
                    style: const TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              Row(
                children: [

                  Text(
                    "Created : ${DateFormat("dd MMM yyyy").format(outfit.createdAt)}",
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 15,
                    ),
                  ),

                  const Spacer(),

                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                  )
                ],
              ),
            ],
          ),
        ),
      );
  }
}