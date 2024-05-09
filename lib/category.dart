import 'package:final_project/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:iconsax/iconsax.dart';

class CategoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
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
                "Category",
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
          Expanded(
          child: GridView.count(
            padding: EdgeInsets.all(20),
            crossAxisCount: 2,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            childAspectRatio: ((MediaQuery.of(context).size.width / 2) / 250),
            children: [
              _buildImageWithText(
                context,
                'https://media-cdn.tripadvisor.com/media/photo-s/17/57/7d/17/2-egg-breakfast.jpg',
                'Breakfast',
              ),
              _buildImageWithText(
                context,
                'https://cdns.klimg.com/kapanlagi.com/p/headline/liburan-hemat-di-bali-bermodal-rp-20rib-0f60e4.jpg',
                'Lunch',
              ),
              _buildImageWithText(
                context,
                'https://media-cdn.tripadvisor.com/media/photo-s/15/88/be/38/dinner-plate.jpg',
                'Dinner',
              ),
              // Add more duplicated images as needed
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImageWithText(BuildContext context, String imageUrl, String text) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          imageUrl,
          fit: BoxFit.cover,
        ),
        Positioned(
          bottom: 0,
          left: 0,
          child: Container(
            width: MediaQuery.of(context).size.width / 2,
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.grey[900]!.withOpacity(0.15),
                  Colors.grey[900]!,
                ],
              ),
            ),
            child: Text(
              text,
              style: TextStyle(
                color: kWhiteColor,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}