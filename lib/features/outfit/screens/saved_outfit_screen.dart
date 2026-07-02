// ignore_for_file: unnecessary_cast
import 'package:flutter/material.dart';

import '../../../database/database_helper.dart';

import '../../../models/outfit.dart';
import '../../../models/clothing_item.dart';

import '../widgets/outfit_card.dart';

class SavedOutfitPage extends StatefulWidget {

  const SavedOutfitPage({super.key});

  @override
  State<SavedOutfitPage> createState() =>
      _SavedOutfitPageState();
}

class _SavedOutfitPageState
    extends State<SavedOutfitPage> {

  List<Outfit> outfits = [];

  @override
  void initState() {
    super.initState();
    loadOutfits();
  }

  Future<void> loadOutfits() async {

    outfits =
        await DatabaseHelper.instance.getAllOutfits();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBar(
        title: const Text("Saved Outfits"),
      ),

      body: outfits.isEmpty

          ? const Center(
              child: Text(
                "No Saved Outfit",
              ),
            )

          : ListView.builder(

              padding: const EdgeInsets.all(20),

              itemCount: outfits.length,

              itemBuilder: (context,index){

                return FutureBuilder(

                  future: Future.wait([

                    DatabaseHelper.instance.getClothingById(
                        outfits[index].topId),

                    DatabaseHelper.instance.getClothingById(
                        outfits[index].bottomId),

                    DatabaseHelper.instance.getClothingById(
                        outfits[index].shoesId),

                  ]),

                  builder: (context,snapshot){

                    if(!snapshot.hasData){

                      return const SizedBox();

                    }

                    final items =
                        snapshot.data!;

                    return OutfitCard(

                      outfit: outfits[index],

                      top: items[0] as ClothingItem?,

                      bottom: items[1] as ClothingItem?,

                      shoes: items[2] as ClothingItem?,

                      onRefresh: () async {

                          await DatabaseHelper.instance.deleteOutfit(
                              outfits[index].id!,
                          );

                          loadOutfits();
                      },

                    );

                  },

                );

              },

            ),

    );

  }

}