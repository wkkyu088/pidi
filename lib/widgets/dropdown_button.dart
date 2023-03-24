import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:pidi/models/posts.dart';
import 'package:pidi/models/singleton.dart';
import 'package:pidi/widgets/toast_message.dart';

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
          showDialog(
              builder: (BuildContext context) {
                return customDialog(
                    context, '삭제', '영구적으로 삭제됩니다.\n정말 삭제하시겠습니까?', '확인', () {
                  Singleton().deletePost(post.id);
                  // firestore.doc(post.id).delete();
                  Navigator.pop(context);
                  toastMessage(context, '삭제되었습니다.');
                });
              },
              context: context);
        }
        break;
    }
  }
}
