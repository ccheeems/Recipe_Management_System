import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:final_project/homepage.dart';

class Favorites extends StatefulWidget {
  const Favorites({super.key});

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                        fixedSize: const Size(55, 55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      color: Colors.black,
                      icon: const Icon(CupertinoIcons.chevron_back),
                    ),
                    const Spacer(),
                    const Text(
                      "Favorites",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {},
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                        fixedSize: const Size(55, 55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      color: Colors.black,
                      icon: const Icon(Iconsax.notification),
                    ),
                  ],
                ),
                // if (_filteredRecipe.isEmpty)
                //   Container(
                //     width: double.infinity,
                //     height: 200, // Adjust the height as needed
                //     child: Image.asset('assets/splash_images/emptyState.gif'),
                //   )
                // else
                //   const SizedBox(height: 20),
                //   Container( // Adjust the height as per your preference
                //   child: GridView.builder(
                //     shrinkWrap: true,
                //     physics: NeverScrollableScrollPhysics(),
                //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                //       //crossAxisCount: screenWidth > 1000 ? 3 : 2, 
                //       crossAxisCount: 2, // Adjust according to screen width
                //       crossAxisSpacing: 20,
                //       mainAxisSpacing: 20,
                //       childAspectRatio: ((MediaQuery.of(context).size.width / 2) / 210),
                //     ),
                //     itemBuilder: (context, index) => RecipeCard(
                //       index: index,
                //       filteredRecipe: _filteredRecipe,
                //       onDelete: deleteRecipe,
                //       onEdit: showEditRecipe,
                //       onFavorite: Favorite,
                //       showInstruction: showInstruction,
                //       confirmDialog: confirmDialog,
                //       image: _image,
                //     ),
                //     itemCount: _filteredRecipe.length,
                //   ),
                // ),
              ],
              //GridView.builder(gridDelegate: gridDelegate, itemBuilder: itemBuilder)
            ),
          ),

        ),
      ),
    );
  }
}