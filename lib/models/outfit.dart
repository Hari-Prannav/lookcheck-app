import 'dart:convert';

class Outfit {
  final int? id;
  final String name;

  final int? topId;
  final int? bottomId;
  final int? shoesId;

  final DateTime createdAt;

  final List<int> extraItemIds;

  Outfit({
    this.id,
    required this.name,
    this.topId,
    this.bottomId,
    this.shoesId,
    required this.createdAt,
    required this.extraItemIds,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'topId': topId,
      'bottomId': bottomId,
      'shoesId': shoesId,
      'createdAt': createdAt.toIso8601String(),
      'extraItemIds': jsonEncode(extraItemIds),
    };
  }

  factory Outfit.fromMap(Map<String, dynamic> map) {
    return Outfit(
      id: map['id'],
      name: map['name'],
      topId: map['topId'],
      bottomId: map['bottomId'],
      shoesId: map['shoesId'],
      createdAt: DateTime.parse(map['createdAt']),
      extraItemIds:
      map["extraItemIds"] == null
          ? []
          : List<int>.from(
              jsonDecode(
                map["extraItemIds"],
              ),
            ),
    );
  }
}