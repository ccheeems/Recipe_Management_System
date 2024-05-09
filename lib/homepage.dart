import 'dart:convert';
import 'dart:io';
import 'package:final_project/constant.dart';
import 'package:final_project/favorites.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:iconsax/iconsax.dart';

class MealTypeCard extends StatelessWidget {
  final String title;
  final IconData icon;

  MealTypeCard({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20),
      color: kGrayColor,
      width: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
        Icon(
          this.icon, 
          color: kPrimaryColor, 
          size: 50,
        ),
        Text(
          this.title, 
          style: TextStyle(
            color: Colors.grey[800], 
            fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class RecipeCard extends StatelessWidget{
  final int index;
  final List<dynamic> filteredRecipe;
  final Function(String) onDelete;
  final Function(String, String, String, String, String, String) onEdit;
  final Function(String, String) onFavorite;
  final Function(String, String, String) showInstruction;
  final Function(String) confirmDialog;
  final File? image;

  const RecipeCard({
    Key? key,
    required this.index,
    required this.filteredRecipe,
    required this.onDelete,
    required this.onEdit,
    required this.onFavorite,
    required this.showInstruction,
    required this.confirmDialog,
    this.image,
  }) : super(key: key);


  @override
  Widget build(BuildContext context){
    if (filteredRecipe.isEmpty || index >= filteredRecipe.length) {
      return SizedBox(); // Return an empty SizedBox if there's no recipe data
    }


    final recipe = filteredRecipe[index];
    return SizedBox(
      width: double.infinity,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    image: image != null
                        ? FileImage(image!) 
                        : NetworkImage(
                            "https://w0.peakpx.com/wallpaper/970/334/HD-wallpaper-sweet-dessert-desert-delicious-food-sweet.jpg") as ImageProvider<Object>,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              const SizedBox(height: 5),
                Text(
                  "${recipe['recipe_name']}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              const SizedBox(height: 5),
              Row(
                children: [
                  const Icon(
                    Icons.dining_outlined,
                    size: 18,
                    color: Colors.grey,
                  ),
                  Expanded( // Ensure the icon and text are wrapped in Expanded widget
                    child: Text(
                      "${recipe['category']['category_name']}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const Icon(
                    Iconsax.stickynote,
                    size: 18,
                    color: Colors.grey,
                  ),
                  Expanded( // Ensure the icon and text are wrapped in Expanded widget
                    child: Text(
                      "${recipe['description']}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        String id = recipe['recipe_id'];
                        String category = recipe['category']['category_id'];
                        String name = recipe['recipe_name'];
                        String desc = recipe['description'];
                        String instruction = recipe['instructions'];
                        String ingredients = recipe['ingredients'];
                        onEdit(id, name, desc, instruction, ingredients, category);
                      },
                    icon: Icon(
                      Icons.edit_outlined,
                      color: Colors.green.shade700, size: 20),
                  ),
                  IconButton(
                    onPressed: () {
                      confirmDialog(recipe['recipe_id']);
                    },
                    icon: Icon(
                      Icons.delete_outlined,
                      color: Colors.red.shade700, size: 20),
                  ),
                  IconButton(
                    onPressed: () {
                      String name = recipe['recipe_name'];
                      String instruction = recipe['instructions'];
                      String ingredients = recipe['ingredients'];
                      showInstruction(name, instruction, ingredients);
                    },
                    icon: const Icon(
                      Icons.menu_book_outlined,
                      color: kTextGrayColor, size: 20),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            top: 1,
            right: 1,
            child: IconButton(
              onPressed: () {
                String id = recipe['recipe_id'];
                String favorite = recipe['favorite'];
                onFavorite(id, favorite);
              },
              style: IconButton.styleFrom(
                backgroundColor: Colors.white,
                fixedSize: const Size(30, 30),
              ),
              iconSize: 20,
              icon: recipe['favorite'] == "1"
                  ? const Icon(
                Iconsax.heart5,
                color: Colors.red,
              )
                : const Icon(Iconsax.heart),
            ),
          )
        ],
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  File? _image; // File to hold the selected image

  // Function to handle image selection
  Future<void> _getImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      setState(() {
        _image = File(file.path!);
      });
    } else {
      // User canceled the file picker
    }
  }

  String? _selectedCategory;
  List<dynamic> _categories = [];
  List<dynamic> _recipe = [];
  List<dynamic> _filteredRecipe = [];

  TextEditingController _recipeName = TextEditingController();
  TextEditingController _description = TextEditingController();
  TextEditingController _instruction = TextEditingController();
  TextEditingController _ingredients = TextEditingController();

  TextEditingController _editRecipeName = TextEditingController();
  TextEditingController _editDescription = TextEditingController();
  TextEditingController _editInstruction = TextEditingController();
  TextEditingController _editIngredients = TextEditingController();


  final server = "http://localhost/RMS_API/api/recipes/";

  Future<void> addRecipe(String name, String description, String instruction, String ingredients, String category_id, File? image) async {
    final url = server + "recipe.php";

    var request = http.MultipartRequest('POST', Uri.parse(url));

    // Add text fields
    request.fields['recipe_name'] = name;
    request.fields['description'] = description;
    request.fields['instructions'] = instruction;
    request.fields['ingredients'] = ingredients;
    request.fields['category_id'] = category_id;

    // Add image file if provided
    if (image != null) {
      var file = await http.MultipartFile.fromPath('image', image.path);
      request.files.add(file);
    }

    // Send the request
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    print(response.body);
    loadRecipeList();
  }

  Future<void> editRecipe(String id, String name, String description, String instruction, String ingredients, String category_id) async {
    final url = server + "recipe.php";
    Map<String, dynamic> data = {
      "recipe_id" : id,
      "recipe_name" : name,
      "description" : description,
      "instructions" : instruction,
      "ingredients" : ingredients,
      "category_id" : category_id
    };
    final response = await http.put(
        Uri.parse(url),
        body: jsonEncode(data)
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
        _filteredRecipe = _recipe;
      });
      print(response.body);
    } catch (e) {
      print(e);
    }
  }

  void searchRecipe(String query) {
    setState(() {
      if (query.isNotEmpty) {
        // Filter recipes based on the query
        _filteredRecipe = _recipe.where((recipe) =>
              recipe['recipe_name'].toString().toLowerCase().contains(query.toLowerCase()) ||
              recipe['category']['category_name'].toString().toLowerCase().contains(query.toLowerCase())).toList();;
      } else {
        // If query is empty, show all recipes
        _filteredRecipe = _recipe;
      }
    });
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

  Future<void> Favorite(String id, String favorite) async {
    if(favorite == "0"){
      favorite = "1";
    }else{
      favorite = "0";
    }

    final url = server + "favorite.php";
    Map<String, dynamic> data = {
      "recipe_id" : id,
      "favorite" : favorite
    };
    final response = await http.put(
        Uri.parse(url),
        body: jsonEncode(data)
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
          title: Container(
            width: 400, // Adjust the width as needed
            height: 30, // Adjust the height as needed
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.local_dining), // Bookmark icon
                      SizedBox(width: 8), // Add spacing between icon and text
                      Flexible(
                        child: Text(
                          '$name',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          content: Container(
            width: 400, // Adjust the width as needed
            height: 120, // Adjust the height as needed
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Instruction: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(instruction),
                    ],
                  ),
                  SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Ingredients: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(ingredients),
                    ],
                  ),
                ],
              ),
            ),
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

  void showAddRecipe() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: Text("Add Recipe"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 250, // Set the desired width
                    height: 50, // Set the desired height
                    child: TextField(
                      controller: _recipeName,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Name',
                      ),
                      maxLines: null, // Enable multiline input
                    ),
                  ),
                  SizedBox(height: 8),
                  SizedBox(
                    width: 250, // Set the desired width
                    height: 50, // Set the desired height
                    child: TextField(
                      controller: _description,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Description',
                      ),
                      maxLines: null, // Enable multiline input
                    ),
                  ),
                  SizedBox(height: 8),
                  SizedBox(
                    width: 250, // Set the desired width
                    height: 50, // Set the desired height
                    child: TextField(
                      controller: _ingredients,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Ingredients',
                      ),
                      maxLines: null, // Enable multiline input
                    ),
                  ),
                  SizedBox(height: 8),
                  SizedBox(
                    width: 250, // Set the desired width
                    height: 50, // Set the desired height
                    child: TextField(
                      controller: _instruction,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Instructions',
                      ),
                      maxLines: null, // Enable multiline input
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
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () async {
                      await _getImage();
                      setState(() {});
                    },
                    child: Text('Select Image'),
                  ),
                  SizedBox(height: 8),
                  if (_image != null)
                    Container(
                      height: 200,
                      width: 200,
                      child: Image.file(
                        _image!,
                        fit: BoxFit.cover,
                      ),
                    ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  _image = null;
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              TextButton(
                onPressed: () {
                  addRecipe(
                    _recipeName.text,
                    _description.text,
                    _instruction.text,
                    _ingredients.text,
                    _selectedCategory!,
                    _image,
                  );
                  _recipeName.text = "";
                  _description.text = "";
                  _instruction.text = "";
                  _ingredients.text = "";
                  _image = null;
                  _selectedCategory = null;
                  Navigator.of(context).pop();
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
    },
  );
}


  void showEditRecipe(String id, String name, String description, String instruction, String ingredients, String selectedCategory){
  _editRecipeName.text = name;
  _editDescription.text = description;
  _editIngredients.text = ingredients;
  _editInstruction.text = instruction;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Edit Recipe"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 250, // Set the desired width
                height: 50, // Set the desired height
                child: TextField(
                  controller: _editRecipeName,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Name',
                  ),
                  maxLines: null, // Enable multiline input
                ),
              ),
              SizedBox(height: 8),
              SizedBox(
                width: 250, // Set the desired width
                height: 50, // Set the desired height
                child: TextField(
                  controller: _editDescription,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Description',
                  ),
                  maxLines: null, // Enable multiline input
                ),
              ),
              SizedBox(height: 8),
              SizedBox(
                width: 250, // Set the desired width
                height: 50, // Set the desired height
                child: TextField(
                  controller: _editIngredients,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Ingredients',
                  ),
                  maxLines: null, // Enable multiline input
                ),
              ),
              SizedBox(height: 8),
              SizedBox(
                width: 250, // Set the desired width
                height: 50, // Set the desired height
                child: TextField(
                  controller: _editInstruction,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Instructions',
                  ),
                  maxLines: null, // Enable multiline input
                ),
              ),
              SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Category',
                ),
                value: selectedCategory,
                items: _categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category['category_id'].toString(),
                    child: Text(category['cat_name']),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    selectedCategory = value!;
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
              editRecipe(id, _editRecipeName.text, _editDescription.text, _editInstruction.text, _editIngredients.text, selectedCategory);
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
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView (
          child: 
            Padding(
              padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      "What are we\ncooking today?", 
                      style: TextStyle(
                        fontSize: 30, 
                        fontWeight: FontWeight.w700,
                        height: 1,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {},
                      style: IconButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        backgroundColor: kWhiteColor,
                        fixedSize: const Size(55, 55)
                      ),
                      icon: const Icon(Iconsax.notification),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20, 
                    vertical: 5,
                  ),
                  child: Row(
                    children: [
                      Icon(Iconsax.search_normal),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Search any recipes...',
                            hintStyle: TextStyle(
                              color: kTextGrayColor,
                            ),
                          ),
                          onChanged: (value) {
                            searchRecipe(value);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: const DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage("assets/splash_images/explore.png"),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 110,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      MealTypeCard(
                        title: 'Breakfast', 
                        icon: Icons.breakfast_dining,
                      ),
                      MealTypeCard(
                        title: 'Lunch', 
                        icon: Icons.lunch_dining,
                      ),
                      MealTypeCard(
                        title: 'Dinner', 
                        icon: Icons.dinner_dining,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                  const Text(
                  "List of Recipes", 
                  style: TextStyle(
                  fontSize: 20, 
                  fontWeight: FontWeight.bold
                  ),
                ),
                if (_filteredRecipe.isEmpty)
                  Container(
                    width: double.infinity,
                    height: 200, // Adjust the height as needed
                    child: Image.asset('assets/splash_images/emptyState.gif'),
                  )
                else
                  const SizedBox(height: 20),
                  Container( // Adjust the height as per your preference
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      //crossAxisCount: screenWidth > 1000 ? 3 : 2, 
                      crossAxisCount: 2, // Adjust according to screen width
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: ((MediaQuery.of(context).size.width / 2) / 210),
                    ),
                    itemBuilder: (context, index) => RecipeCard(
                      index: index,
                      filteredRecipe: _filteredRecipe,
                      onDelete: deleteRecipe,
                      onEdit: showEditRecipe,
                      onFavorite: Favorite,
                      showInstruction: showInstruction,
                      confirmDialog: confirmDialog,
                      image: _image,
                    ),
                    itemCount: _filteredRecipe.length,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddRecipe();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}


