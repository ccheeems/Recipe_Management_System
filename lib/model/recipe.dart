class Recipe{
  List<dynamic> json = [];

  final int id;
  final String name;
  final String desc;
  final String ingredients;
  final String instructions;
  final String category_id;
  final String category_name;
  final bool favorite;

  Recipe({
    required this.id,
    required this.name,
    required this.desc,
    required this.ingredients,
    required this.instructions,
    required this.category_id,
    required this.category_name,
    required this.favorite,
  });

  factory Recipe.fromJson(Map<String, dynamic> json){
    return Recipe(
        id: json['recipe_id'],
        name: json['name'],
        desc: json['description'],
        ingredients: json['ingredients'],
        instructions: json['instructions'],
        category_id: json['category']['category_id'],
        category_name: json['category']['category_name'],
        favorite: json['favorite']
    );
  }

  static List<Recipe> listFromJson(json){
    return json.map((index) => Recipe.fromJson(index)).toList();
  }
}