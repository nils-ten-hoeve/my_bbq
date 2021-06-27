import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:my_bbq/theme/extended_theme.dart';
import 'package:overflow_view/overflow_view.dart';

import 'command.dart';



class CommandToolbar extends StatelessWidget {
  final List<Command> commands;

  CommandToolbar(this.commands);

  @override
  Widget build(BuildContext context) {
    Color backGroundColor = Theme.of(context).dialogBackgroundColor;

    List<Command> visibleCommands =
        commands.where((command) => command.visible).toList();
    return Visibility(
        visible: visibleCommands.isNotEmpty,
        child: Container(
            padding: EdgeInsets.fromLTRB(ExtendedTheme.spacing, 0, ExtendedTheme.spacing, 0),
            color: backGroundColor,
            height: ExtendedTheme.minItemHeight,
            child: Align(
              alignment: Alignment.centerRight,
              child: OverflowView.flexible(
                  spacing: ExtendedTheme.spacing,
                  children: visibleCommands
                      .map((command) => CommandToolbarButton(command))
                      .toList(),
                  builder: (context, remaining) {
                    return CommandToolBarMoreButton(visibleCommands, remaining);
                  }),
            )));
  }
}

class CommandToolBarMoreButton extends StatelessWidget {
  final List<Command> visibleCommands;
  final int remaining;
  final buttonKey = GlobalKey();

  CommandToolBarMoreButton(this.visibleCommands, this.remaining);

  @override
  Widget build(BuildContext context) {
    Color foreGroundColor = Theme.of(context).textTheme.bodyText1!.color!;

    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: ExtendedTheme.minItemHeight
      ),
      child: TextButton(
        key: buttonKey,
        style: TextButton.styleFrom(
            primary: foreGroundColor,
            shape: ExtendedTheme.roundedRectangleBorder),
        child: Icon(Icons.more_horiz),
        onPressed: () {
          CommandPopupMenu(
            context,
            visibleCommands.skip(visibleCommands.length - remaining).toList(),
            position: calculatePopUpMenuPosition(),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: ExtendedTheme.radius,
                    bottomRight: ExtendedTheme.radius)),
          );
        },
      ),
    );
  }

  RelativeRect? calculatePopUpMenuPosition() {
    var buttonKeyContext = buttonKey.currentContext;
    if (buttonKeyContext != null) {
      final RenderBox box = buttonKeyContext.findRenderObject() as RenderBox;
      Offset buttonPosition = box.localToGlobal(Offset.zero);
      Size buttonSize = box.size;
      Size screenSize = MediaQuery.of(buttonKeyContext).size;
      return RelativeRect.fromLTRB(screenSize.width,
          buttonPosition.dy + buttonSize.height + 2, 0, screenSize.height);
    }
    return null;
  }
}

final iconPlaceholder = Icon(
  Icons.adjust,
  color: Colors.transparent,
);

Icon? createCommandIcon(Command command, Color foreGroundColor,
    {bool isIconPlaceholder = false}) {
  IconData? icon = command.icon;
  if (icon == null) {
    if (isIconPlaceholder) {
      return iconPlaceholder;
    } else {
      return null;
    }
  } else {
    return Icon(
      command.icon,
      color: foreGroundColor,
    );
  }
}

class CommandIconAndText extends StatelessWidget {
  final Command command;

  CommandIconAndText(this.command);

  @override
  Widget build(BuildContext context) {
    Color foreGroundColor = Theme.of(context).textTheme.bodyText1!.color!;
    return Row(children: [
      createCommandIcon(command, foreGroundColor, isIconPlaceholder: true)!,
      SizedBox(
        width: 10,
      ),
      Text(command.name, style: TextStyle(color: foreGroundColor))
    ]);
  }
}

class CommandPopupMenu {
  final List<Command> commands;

  CommandPopupMenu(
    BuildContext context,
    this.commands, {
    String? title,
    Command? selectedCommand,
    RelativeRect? position,
    double? elevation,
    ShapeBorder? shape,
    Color? color,
    bool useRootNavigator = false,
  }) {
    if (position == null) {
      position = positionInMiddleOfScreen(context);
    }

    List<Command> visibleCommands =
        commands.where((command) => command.visible).toList();

    if (visibleCommands.isNotEmpty) {
      showMenu<Command>(
              context: context,
              position: position,
              initialValue: selectedCommand,
              elevation: elevation,
              color: color,
              shape: (shape == null) ? ExtendedTheme.roundedRectangleBorder : shape,
              items: createItems(context, title, visibleCommands))
          .then((command) => command!.action());
    }
  }

  RelativeRect positionInMiddleOfScreen(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double assumedPopUpWidth = 220;
    return RelativeRect.fromLTRB(
        (screenWidth - assumedPopUpWidth) / 2, 100, screenWidth, 100);
  }

  List<PopupMenuItem<Command>> createItems(
      BuildContext context, String? title, List<Command> visibleCommands) {
    return [
      if (title != null && title.isNotEmpty) createTitle(context, title),
      ...visibleCommands
          .map((command) => CommandPopupMenuItem(command))
          .toList()
    ];
  }

  PopupMenuItem<Command> createTitle(BuildContext context, String title) =>
      PopupMenuItem(
        child: Text(title),
        enabled: false,
        textStyle: Theme.of(context).textTheme.headline6,
      );
}

class CommandPopupMenuItem extends PopupMenuItem<Command> {
  CommandPopupMenuItem(Command command)
      : super(value: command, child: CommandIconAndText(command));
}

class CommandToolbarButton extends StatelessWidget {
  final Command command;

  CommandToolbarButton(this.command);

  @override
  Widget build(BuildContext context) {
    Color foreGroundColor = Theme.of(context).textTheme.bodyText1!.color!;

    Icon? icon = createCommandIcon(command, foreGroundColor);
    if (icon == null) {
      return ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: ExtendedTheme.minItemHeight,
        ),
        child: TextButton(
          child: Text(
            command.name,
          ),
          style: Theme.of(context).textButtonTheme.style!.copyWith(foregroundColor: MaterialStateProperty.all<Color>(foreGroundColor)) ,
          onPressed: () {
            command.action();
          },
        ),
      );
    } else {
      final buttonStyle = TextButton.styleFrom(primary: foreGroundColor,
          padding: EdgeInsets.all(20),
          shape: ExtendedTheme.roundedRectangleBorder);
      return ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: ExtendedTheme.minItemHeight,
        ),
        child: TextButton.icon(
          style: buttonStyle,
          label: Text(
            command.name,
          ),
          icon: icon,
          onPressed: () {
            command.action();
          },
        ),
      );
    }
  }
}


