import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'command.dart';

/// An icon for a [Command].
/// It will be a placeholder if command has no icon defined.
class CommandIcon extends StatelessWidget {
  final Command command;
  final Key? key;
  final CommandIconStyle style;

  CommandIcon(this.command, {this.key, this.style = const CommandIconStyle()});

  @override
  Widget build(BuildContext context) {
    IconData? iconData = command.icon;
    if (iconData == null) {
      return buildPlaceHolderIcon(context);
    } else {
      return buildIcon(context, iconData, style);
    }
  }

  Icon buildIcon(BuildContext context, IconData iconData,
      CommandIconStyle style) {
    return Icon(iconData,
        key: key,
        size: style.size,
        color: style.color(context),
        semanticLabel: style.semanticLabel,
        textDirection: style.textDirection);
  }

  Widget buildPlaceHolderIcon(BuildContext context) =>
      buildIcon(
          context,
          //just any random icon will do, because it will be transparent
          Icons.adjust
          , style.copyWith(color: Colors.transparent));
}

/// Styling for the [CommandIcon].
/// The color defaults to the theme's textTheme.bodyText1.color
class CommandIconStyle {
  final double? size;
  final Color? _color;
  final String? semanticLabel;
  final TextDirection? textDirection;

  const CommandIconStyle(
      {this.size, Color? color, this.semanticLabel, this.textDirection})
      : _color = color;

  Color color(BuildContext context) =>
      _color ?? _defaultColor(context);

  Color _defaultColor(BuildContext context) =>
      Theme
          .of(context)
          .textTheme
          .bodyText1!
          .color!;

  CommandIconStyle copyWith(
      {double? size, Color? color, String? semanticLabel, TextDirection? textDirection}) =>
      CommandIconStyle(size: size ?? this.size,
          color: color ?? this._color,
          semanticLabel: semanticLabel ?? this.semanticLabel,
          textDirection: textDirection ?? this.textDirection);
}

class CommandIconAndText extends StatelessWidget {
  final Command command;

  CommandIconAndText(this.command);

  @override
  Widget build(BuildContext context) {
    Color foreGroundColor = Theme
        .of(context)
        .textTheme
        .bodyText1!
        .color!;
    return Row(children: [
      CommandIcon(command,),
      SizedBox(
        width: 10,
      ),
      Text(command.name, style: TextStyle(color: foreGroundColor))
    ]);
  }
}