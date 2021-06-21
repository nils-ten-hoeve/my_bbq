import 'package:flutter/cupertino.dart';

class Recipe {
  String name;
  List<TemperatureSensor> temperatureSensors;

  Recipe(this.name, this.temperatureSensors);


}

class TemperatureSensor {
  String name;//The name pit is reserved for the temperature just above the grill
  //TODO add temperature notifications
  TemperatureSensor(this.name);
}

class RecipeService extends ChangeNotifier {
  List<Recipe> _recipes = RecipeRepository().read();

  List<Recipe> get all => _recipes;

  moveUp(Recipe recipe) {
    int index = _recipes.indexOf(recipe);
    if (index > 0) {
      _recipes.remove(recipe);
      _recipes.insert(index - 1, recipe);
      notifyListeners();
      RecipeRepository().write(_recipes);//TODO make RecipeRepository a listener
    }
  }

  moveDown(Recipe recipe) {
    int index = _recipes.indexOf(recipe);
    if (index < _recipes.length - 1) {
      _recipes.remove(recipe);
      _recipes.insert(index + 1, recipe);
      notifyListeners();
      RecipeRepository().write(_recipes);//TODO make RecipeRepository a listener
    }
  }

  delete(Recipe recipeToRemove) {
    _recipes.remove(recipeToRemove);
    notifyListeners();
    RecipeRepository().write(_recipes);//TODO make RecipeRepository a listener
  }
}

class RecipeRepository {
  static final RecipeRepository _singleton = RecipeRepository._();

  factory RecipeRepository() => _singleton;

  RecipeRepository._();

  void write(List<Recipe> recipes) {
    //TODO}
  }

  List<Recipe> read() => [
        //TODO
        Recipe('Burnt ends',[]),
        Recipe('Salmon on wood',[TemperatureSensor('Pit')]),
        Recipe('Ribs 3,2,1',[]),
        Recipe('Pulled pork',[]),
        Recipe('Chicken on a can',[]),
        Recipe('Beer can burger',[]),
      ];
}
