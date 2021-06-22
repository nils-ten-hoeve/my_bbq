import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_bbq/domain/heater_meter.dart';
import 'package:my_bbq/domain/recipe.dart';
import 'package:my_bbq/widgets/toolbar.dart';
import 'package:provider/provider.dart';

class RecipeListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Recipe> recipes = Provider.of<RecipeService>(context).all;
    return //SafeArea(
        // child: Padding(
        //     padding: const EdgeInsets.all(8.0),
        //    child:
        Column(
      children: [
        //CommandBar(),
        Toolbar(),
        ListView.separated(
            shrinkWrap: true,
            //TODO without: gives RenderBox was not laid out    with: does not work with many item lists (scrolling)
            separatorBuilder: (context, index) => Divider(),
            itemCount: recipes.length,
            itemBuilder: (context, index) => RecipeTile(recipes[index])),
      ],
    );
  }
}



class RecipeTile extends StatelessWidget {
  final Recipe recipe;

  RecipeTile(this.recipe);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (location) {
        showMenu(
          position: RelativeRect.fromLTRB(
              location.localPosition.dx, location.globalPosition.dy, 100, 100),
          context: context,
          items: [
            PopupMenuItem(
              child: Text('${recipe.name}:'),
              enabled: false,
            ),
            if (Provider.of<HeaterMeterService>(context, listen: false)
                    .isConnected &&
                recipe.temperatureSensors.isNotEmpty)
              PopupMenuItem(
                  child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('Start cooking'),
                leading: Icon(Icons.fastfood),
                onTap: () {
                  closeMenuOrDialog(context);
                  //TODO
                },
              )),
            PopupMenuItem(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('Edit'),
                leading: Icon(Icons.edit),
                onTap: () {
                  closeMenuOrDialog(context);
                  //TODO
                },
              ),
            ),
            PopupMenuItem(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('View'),
                leading: Icon(Icons.table_rows),
                onTap: () {
                  closeMenuOrDialog(context);
                  //TODO
                },
              ),
            ),
            PopupMenuItem(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('Move up'),
                leading: Icon(Icons.arrow_upward),
                onTap: () {
                  closeMenuOrDialog(context);
                  Provider.of<RecipeService>(context, listen: false)
                      .moveUp(recipe);
                },
              ),
            ),
            PopupMenuItem(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('Move down'),
                leading: Icon(Icons.arrow_downward),
                onTap: () {
                  closeMenuOrDialog(context);
                  Provider.of<RecipeService>(context, listen: false)
                      .moveDown(recipe);
                },
              ),
            ),
            PopupMenuItem(
                child: ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('Delete'),
              leading: Icon(Icons.delete),
              onTap: () {
                closeMenuOrDialog(context);
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ConformDeletionDialog(recipe);
                  },
                );
              },
            ))
          ],
        );
      },
      child: ListTile(
        title: Text(recipe.name),
      ),
    );
  }
}

class ConformDeletionDialog extends StatelessWidget {
  final Recipe recipe;

  ConformDeletionDialog(this.recipe);

  @override
  Widget build(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        closeMenuOrDialog(context);
      },
    );
    Widget deleteButton = TextButton(
      child: Text("Delete"),
      onPressed: () {
        Provider.of<RecipeService>(context, listen: false).delete(recipe);
        closeMenuOrDialog(context);
      },
    );

    return AlertDialog(
      title: Text("Delete"),
      content: Text("Are you sure you want to delete:\n${recipe.name}?"),
      actions: [
        cancelButton,
        deleteButton,
      ],
    );
  }
}

void closeMenuOrDialog(BuildContext context) {
  Navigator.pop(context);
}
