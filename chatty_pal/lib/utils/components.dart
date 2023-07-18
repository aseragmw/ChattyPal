import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

Widget customTextField(
        Function(String) onChanged,
        TextInputType? inputType,
        bool obsecureText,
        TextEditingController controller,
        String label,
        Widget suffixIcon,
        double screenWidth,
        Color enabledBorderColor,
        Color focusedBorderColor) =>
    TextField(
        onChanged: onChanged,
        obscureText: obsecureText,
        keyboardType: inputType,
        controller: controller,
        autocorrect: false,
        decoration: InputDecoration(
          suffixIcon: suffixIcon,
          suffixIconColor: Colors.black45,
          border: InputBorder.none,
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: enabledBorderColor, width: 2)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: focusedBorderColor)),
          label: Text(label),
          labelStyle: TextStyle(
              fontSize: screenWidth / 23,
              color: enabledBorderColor,
              fontWeight: FontWeight.w500),
        ));

Widget customButton(Color color, Color textColor, String title,
        Function() onPressed, double screenWidth, double screenHeight) =>
    Container(
      height: screenHeight / 15,
      width: screenWidth,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(10), color: color),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          title,
          style: TextStyle(color: textColor),
        ),
      ),
    );

void showCustomDialog(BuildContext context, String dialogTitle,
        String dialogDescription, List<Widget> actions) =>
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
          title: Text(dialogTitle),
          content: Text(dialogDescription),
          actions: actions),
    );

Widget chatListTile(Function() onTap, String tileText) => Slidable(
    startActionPane: ActionPane(
      // A motion is a widget used to control how the pane animates.
      motion: const ScrollMotion(),

      // A pane can dismiss the Slidable.
      dismissible: DismissiblePane(onDismissed: () {}),

      // All actions are defined in the children parameter.
      children: [
        // A SlidableAction can have an icon and/or a label.
        SlidableAction(
          onPressed: (context) {},
          backgroundColor: Color(0xFFFE4A49),
          foregroundColor: Colors.white,
          icon: Icons.delete,
          label: 'Delete',
        ),
        SlidableAction(
          onPressed: (context) {},
          backgroundColor: Color(0xFF21B7CA),
          foregroundColor: Colors.white,
          icon: Icons.share,
          label: 'Share',
        ),
      ],
    ),
    child: ListTile(
      onTap: onTap,
      leading: Text(tileText),
    ));
