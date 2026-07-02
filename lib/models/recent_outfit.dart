import '../../models/clothing_item.dart';
import '../../models/outfit.dart';

class RecentOutfit {
  final Outfit outfit;
  final ClothingItem? top;

  RecentOutfit({
    required this.outfit,
    required this.top,
  });
}