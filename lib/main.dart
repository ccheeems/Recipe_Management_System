import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // placeholder items
  String? _selectedCategory;
  List<dynamic> _categories = [];
  List<dynamic> _recipe = [];
  final server = "http://localhost/test/api/recipes/";

  TextEditingController _recipeName = TextEditingController();
  TextEditingController _description = TextEditingController();
  TextEditingController _instruction = TextEditingController();
  TextEditingController _ingredients = TextEditingController();

  Future<void> addRecipe(String name, String description, String instruction, String ingredients, String category_id) async {
    final url = server + "recipe.php";
    Map<String, dynamic> data = {
      "recipe_name" : name,
      "description" : description,
      "instructions" : instruction,
      "ingredients" : ingredients,
      "category_id" : category_id
    };
    final response = await http.post(
        Uri.parse(url),
        body: data
    );
    print(response.body);
    loadRecipeList();
  }

  Future<void> loadRecipeList() async {
    final url = server + "recipe.php";
    final response = await http.get(Uri.parse(url));
    try {
      setState(() {
        _recipe = jsonDecode(response.body);
      });
      print(response.body);
    } catch (e) {
      print(e);
    }
  }

  Future<void> loadCategoryList() async {
    final url = server + "category.php";
    final response = await http.get(Uri.parse(url));
    try {
      setState(() {
        _categories = jsonDecode(response.body);
      });
      print(response.body);
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteRecipe(String index) async{
    final url = server + "recipe.php?recipe_id=$index";

    final response = await http.delete(
      Uri.parse(url),
    );
    print(response.body);
    loadRecipeList();
  }

  @override
  void initState() {
    loadRecipeList();
    loadCategoryList();
    super.initState();
  }

  void showInstruction(String name, String instruction, String ingredients){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text('$name'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "Instruction: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: Text(instruction),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    "Ingredients: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: Text(ingredients),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                'Exit',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void showAddRecipe(){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add Recipe"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _recipeName,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Name',
                  ),
                ),
                SizedBox(height: 8), // Add some vertical spacing
                TextField(
                  controller: _description,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Description',
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: _ingredients,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Ingredients',
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: _instruction,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Instructions',
                  ),
                ),
                SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Category',
                  ),
                  value: _selectedCategory,
                  items: _categories.map((category) {
                    return DropdownMenuItem<String>(
                      value: category['category_id'].toString(),
                      child: Text(category['cat_name']),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _selectedCategory = value!;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                addRecipe(_recipeName.text, _description.text, _instruction.text, _ingredients.text, _selectedCategory!);
                _recipeName.text = "";
                _description.text = "";
                _instruction.text = "";
                _ingredients.text = "";
                _selectedCategory = null;
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                'Save',
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        );
      },
    );
  }

  void showEditRecipe(){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add Recipe"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Name',
                  ),
                ),
                SizedBox(height: 8), // Add some vertical spacing
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Description',
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Ingredients',
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Instructions',
                  ),
                ),
                SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Category',
                  ),
                  value: _selectedCategory,
                  items: _categories.map((category) {
                    return DropdownMenuItem<String>(
                      value: category['category_id'].toString(),
                      child: Text(category['cat_name']),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _selectedCategory = value!;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                // Add your save logic here
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                'Save',
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        );
      },
    );
  }

  void confirmDialog(String index){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: const Text("Delete Task"),
            content: const Text("Are you sure you want to delete this task?"),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink[200],
                ),
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  deleteRecipe(index);
                  Navigator.of(context).pop(true);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[400],
                ),
                child: const Text(
                  "Delete",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    int crossAxisCount = 1;
    if (screenWidth > 600) {
      crossAxisCount = 3;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Recipe Management System"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: MediaQuery.of(context).size.width /
                (MediaQuery.of(context).size.height / 2),
          ),
          itemCount: _recipe.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              elevation: 4,
              margin: EdgeInsets.all(0),
              child: ListTile(
                title: Text(
                  "${index + 1}. ${_recipe[index]['recipe_name']}",
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 50, // Adjust height as needed
                      child: Text(
                        _recipe[index]['description'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Category: ${_recipe[index]['category']['category_name']}",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        showEditRecipe();
                      },
                      icon: Icon(Icons.edit_outlined, color: Colors.green),
                    ),
                    IconButton(
                      onPressed: () {
                        String id = _recipe[index]['recipe_id'];
                        confirmDialog(id);
                      },
                      icon: Icon(Icons.delete_outline, color: Colors.red),
                    ),
                    IconButton(
                      onPressed: () {
                        String name = _recipe[index]['recipe_name'];
                        String instruction = _recipe[index]['instructions'];
                        String ingredients = _recipe[index]['ingredients'];
                        showInstruction(name, instruction, ingredients);
                      },
                      icon: Icon(Icons.menu_book_outlined, color: Colors.black),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddRecipe();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
