import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import '../constants.dart';
import '../screens/modify_screen.dart';
import 'custom_dialog.dart';

Widget dropDownIcon(context, post) {
  return DropdownButtonHideUnderline(
      child: DropdownButton2(
    customButton: Container(
      padding: const EdgeInsets.all(5),
      child: Icon(
        Icons.more_horiz_rounded,
        color: kBlack,
        size: 22,
      ),
    ),
    customItemsIndexes: const [2],
    isDense: true,
    items: [
      DropdownMenuItem<MenuItem>(
        value: MenuItems.firstItems[0],
        child: MenuItems.buildItem(MenuItems.firstItems[0]),
      ),
      DropdownMenuItem<MenuItem>(
        value: MenuItems.firstItems[1],
        child: MenuItems.buildItem(MenuItems.firstItems[1]),
      ),
    ],
    offset: const Offset(-50, 5),
    onChanged: (value) {
      MenuItems.onChanged(context, value as MenuItem, post);
    },
    itemHeight: 35,
    itemPadding: const EdgeInsets.only(left: 15, right: 15),
    dropdownWidth: 85,
    dropdownDecoration: BoxDecoration(
      borderRadius: kBorderRadius,
      color: kWhite,
    ),
    dropdownElevation: 8,
  ));
}

class MenuItem {
  final String text;
  final IconData icon;

  const MenuItem({
    required this.text,
    required this.icon,
  });
}

class MenuItems {
  static const List<MenuItem> firstItems = [edit, delete];

  static const edit = MenuItem(text: '수정', icon: Icons.edit_rounded);
  static const delete = MenuItem(text: '삭제', icon: Icons.delete_rounded);

  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        Icon(item.icon, color: kBlack, size: 16),
        const SizedBox(width: 6),
        Text(
          item.text,
          style: TextStyle(color: kBlack, fontSize: kContentM),
        ),
      ],
    );
  }

  static onChanged(BuildContext context, MenuItem item, post) {
    switch (item) {
      case MenuItems.edit:
        {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ModifyScreen(post: post)));
        }
        break;
      case MenuItems.delete:
        {
          showDialog(
              builder: (BuildContext context) {
                return customDialog(context, '삭제', '정말 삭제하시겠습니까?', '확인', () {});
              },
              context: context);
        }
        break;
    }
  }
}
