import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pidi/main.dart';
import 'package:pidi/models/posts.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../models/item.dart';
import '../screens/modify_screen.dart';
import 'custom_dialog.dart';

Widget dropDownIcon(context, Item post) {
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
    // customItemsIndexes: const [2],
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
    dropdownStyleData: DropdownStyleData(
      offset: const Offset(-50, 5),
      width: 85,
      decoration: BoxDecoration(
        borderRadius: kBorderRadius,
        color: kWhite,
      ),
      elevation: 8,
    ),
    menuItemStyleData: const MenuItemStyleData(
      height: 35,
      padding: EdgeInsets.only(left: 15, right: 15),
    ),
    onChanged: (value) {
      MenuItems.onChanged(context, value as MenuItem, post);
    },
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
          customDialog(
            context,
            '기록 삭제',
            '기록이 영구적으로 삭제됩니다.\n정말 삭제하시겠습니까?',
            () {
              context.read<DBConnection>().deletePost(post.id);
              Navigator.pop(context);
              Fluttertoast.showToast(msg: "삭제되었습니다.");
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MainPage()),
              );
            },
            isDelete: true,
          );
        }
        break;
    }
  }
}
