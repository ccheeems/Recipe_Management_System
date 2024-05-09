import 'package:final_project/category.dart';
import 'package:final_project/constant.dart';
import 'package:final_project/favorites.dart';
import 'package:final_project/homepage.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentTab = 0;

  List screens = [
    const Home(),
    CategoryPage(),
    const Favorites(),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: ()=> setState(() {
                currentTab = 0;
              }),
              child: Column(
                children: [
                  Icon(
                    currentTab == 0 ? Iconsax.home5 : Iconsax.home, 
                    color: currentTab == 0 ? kPrimaryColor : Colors.grey,
                  ),
                  Text(
                    "Home", 
                    style: TextStyle(
                      fontSize: 14,
                      color: currentTab == 0 ? kPrimaryColor : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: ()=> setState(() {
                currentTab = 1;
              }),
              child: Column(
                children: [
                  Icon(
                    currentTab == 1 ? Iconsax.category5 : Iconsax.category, 
                    color: currentTab == 1 ? kPrimaryColor : Colors.grey,
                  ),
                  Text(
                    "Category", 
                    style: TextStyle(
                      fontSize: 14,
                      color: currentTab == 1 ? kPrimaryColor : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: ()=> setState(() {
                currentTab = 2;
              }),
              child: Column(
                children: [
                  Icon(
                    currentTab == 2 ? Iconsax.heart5 : Iconsax.heart, 
                    color: currentTab == 2 ? kPrimaryColor : Colors.grey,
                  ),
                  Text(
                    "Favorites", 
                    style: TextStyle(
                      fontSize: 14,
                      color: currentTab == 2 ? kPrimaryColor : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
      body: screens[currentTab],
    );
  }
}