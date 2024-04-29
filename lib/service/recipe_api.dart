import 'dart:convert';
import '../model/recipe.dart';
import 'package:http/http.dart' as http;

class RecipeApi{
  static const API_URL = "http://localhost/test/api/recipes/recipe.php";
  Future<List<Recipe>> getRecipe() async{
    final response = await http.get(
      Uri.parse(API_URL)
    );

    if(response.statusCode == 200){
      return Recipe.listFromJson(jsonDecode(response.body));
    }else{
      throw Exception('Failed to load recipe data');
    }
  }
}