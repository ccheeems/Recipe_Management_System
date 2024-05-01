import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'homepage.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
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
      Timer(Duration(seconds: 3), () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Home()));
      });
    }catch(e){
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network("https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/aa10ab5d-82c2-40e3-a748-6d12d7b3702a/devnwfm-22dabb27-9d10-42ed-b30c-8cdf8efcb687.gif?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7InBhdGgiOiJcL2ZcL2FhMTBhYjVkLTgyYzItNDBlMy1hNzQ4LTZkMTJkN2IzNzAyYVwvZGV2bndmbS0yMmRhYmIyNy05ZDEwLTQyZWQtYjMwYy04Y2RmOGVmY2I2ODcuZ2lmIn1dXSwiYXVkIjpbInVybjpzZXJ2aWNlOmZpbGUuZG93bmxvYWQiXX0.CNzBI_jZKnx6vOTm_1vTlRulsY3jw3VyM8sGePrfbVs", height: 100,),
            Text("Recipe Management System", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
            SizedBox(height: 20,),
            LinearProgressIndicator(color: Colors.red,)
          ],
        ),
      ),
    );
  }
}

