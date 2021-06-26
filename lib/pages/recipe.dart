import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_bbq/domain/heater_meter.dart';
import 'package:my_bbq/domain/recipe.dart';
import 'package:my_bbq/widgets/command.dart';
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
        CommandToolbar([
          Command(
              name: 'Add',
              icon: Icons.add,
              action: () {
                //TODO
              }),
          Command(
              name: 'Export',
              icon: Icons.import_export,
              action: () {
                //TODO
              }),
          Command(
              name: 'import',
              icon: Icons.import_export,
              action: () {
                //TODO
              }),
          //TODO remove after testing
          for (int i = 0; i <= 10; i++)
            Command(
                name: 'Longer text $i',
                icon: (i % 2 != 0) ? null : Icons.add,
                //visible: (i % 3 != 0),
                action: () {
                  //TODO
                }),
        ]),
        ListView.separated(
            shrinkWrap: true,
            //TODO without: gives RenderBox was not laid out    with: does not work with many item lists (scrolling)
            separatorBuilder: (context, index) => Divider(),
            itemCount: recipes.length,
            itemBuilder: (context, index) => RecipeTile(recipes[index],index==0, index==recipes.length-1)),
      ],
    );
  }
}

class RecipeTile extends StatelessWidget {
  final Recipe recipe;
  final bool isFirst;
  final bool isLast;

  RecipeTile(this.recipe, this.isFirst, this.isLast);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (location) {
        CommandPopupMenu(
            context,
            [
              Command.dynamic(
                name: () => 'Start cooking',
                icon: () => Icons.fastfood,
                visible: () =>
                    Provider.of<HeaterMeterService>(context, listen: false)
                        .isConnected &&
                    recipe.temperatureSensors.isNotEmpty,
                action: () {
                  //TODO
                },
              ),
              Command(
                name: 'Edit',
                icon: Icons.edit,
                action: () {
                  //TODO
                },
              ),
              Command(
                name: 'View',
                icon: Icons.table_rows,
                action: () {
                  //TODO
                },
              ),
              Command.dynamic(
                name: ()=>'Move up',
                icon: ()=> Icons.arrow_upward,
                visible: ()=> !isFirst,
                action: () {
                  context.read<RecipeService>().moveUp(recipe);
                },
              ),
              Command.dynamic(
                name: () =>'Move down',
                icon: () =>Icons.arrow_downward,
                visible: () => !isLast,
                action: () {
                  context.read<RecipeService>().moveDown(recipe);
                },
              ),
              Command(
                name: 'Delete',
                icon: Icons.delete,
                action: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ConformDeletionDialog(recipe);
                    },
                  );
                },
              ),
            ],
            position: calculatePopUpMenuPosition(context, location),
            title: recipe.name);
      },
      child: ListTile(
        title: Text(recipe.name),
      ),
    );
  }

  RelativeRect calculatePopUpMenuPosition(
      BuildContext context, TapDownDetails location) {
    Size screenSize = MediaQuery.of(context).size;
    RelativeRect position = RelativeRect.fromLTRB(location.localPosition.dx,
        location.globalPosition.dy, screenSize.width, screenSize.height);
    return position;
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
      shape: roundedShape,
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
