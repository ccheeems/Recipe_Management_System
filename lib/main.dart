import 'dart:async';
import 'dart:convert';
import 'package:final_project/mainscreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shadow_clip/shadow_clip.dart';
import 'homepage.dart';
import 'constant.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      fontFamily: "Poppins",
    ),
    home: LoadingPage(),
  ));
}

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {

  bool isAlertDialogShown = false;

  Future<void> Validation() async {
    try{
      final url = "http://localhost/RMS_API/api/validate.php";
      final response = await http.get(Uri.parse(url));
      Timer(Duration(seconds: 8), () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => MainScreen()));
      });
    }catch(e){
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error 404"),
            content: Text("Server Not Found"),
          );
        },
      );
      Timer(Duration(seconds: 3), () {
        Navigator.pop(context);
        Validation();
      });
    }
  }

  @override
  void initState() {
    Validation();
    super.initState();
  }

  int currentpage = 0;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 2,
            child: PageView(
              scrollDirection: Axis.horizontal,
              onPageChanged: (value) {
                setState(() {
                  currentpage = value;
                });
              },
              children: const [
                SplashImgs(
                  image: "assets/splash_images/splash1.jpg",
                ),
                SplashImgs(
                  image: "assets/splash_images/splash2.jpg",
                ),
                SplashImgs(
                  image: "assets/splash_images/splash3.jpg",
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                const Spacer(),
                const Text(
                  "Crafting culinary delights\none recipe at a time",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                // DOT SCROLL
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    1,
                        (index) => dotContainer(index: index),
                  ),
                ),
                const Spacer(),
                // NEXT BUTTON SCROLL
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0)),
                    minWidth: double.infinity,
                    height: 50,
                    color: kPrimaryColor,
                    onPressed: () {
                      Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => const Home()));
                    },
                    child: const Text(
                      "Get Started",
                      style: TextStyle(
                        color: kWhiteColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }


  // DOT CONTAINER
//   Container dotContainer({int? index}) {
//     return Container(
//       margin: EdgeInsets.only(left: 5),
//       height: 6,
//       width: currentpage==index? 20:6,
//       decoration: BoxDecoration(
//         color: currentpage==index? kPrimaryColor:kSecondaryColor, 
//         borderRadius: BorderRadius.circular(20)
//         ),
//     );
//   }
// }

Widget dotContainer({int? index}) {
  return Container(
    margin: EdgeInsets.only(left: 5),
    child: index == currentpage
        ? CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
          )
        : Container(
            height: 6,
            width: 6,
            decoration: BoxDecoration(
              color: kSecondaryColor,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
    );
  }
}

class SplashImgs extends StatelessWidget {
  const SplashImgs({
    super.key, required this.image,
  });

  final String image;

  @override
  Widget build(BuildContext context) {
    return ClipShadow(
      boxShadow:[
          BoxShadow(
            blurRadius: 10.0,
            spreadRadius: 10.0,
            color: kPrimaryColor.withOpacity(0.3),
          )
        ],
      clipper: ClipperClass(),
      child: SizedBox(
        width: double.infinity,
        child: Image.asset(
          image,
        fit: BoxFit.cover,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        ),
      ),
    );
  }
}

// IMAGES CURVED CODE
class ClipperClass extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.width);
    path.quadraticBezierTo(
      size.width/9, size.height, size.width/4, size.height);
    path.quadraticBezierTo(
        size.width-(size.width/2), size.height, size.width, size.height-40);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;

}

