import 'package:flutter/material.dart';
import 'package:pidi/constants.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:pidi/screens/detail_screen.dart';
import 'package:pidi/screens/modify_screen.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import '../widgets/custom_appbar.dart';
import '../widgets/custom_dialog.dart';
import '../constants.dart';

import 'package:pidi/models/test.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({Key? key}) : super(key: key);

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final _current = List.filled(posts.length, 0);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width - 30;

    Widget imageDialog(i, j) {
      return Column(
        children: [
          Container(
            width: 40,
            height: 50,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(top: 10),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.close_rounded,
                size: 30,
                color: kWhite,
              ),
            ),
          ),
          Expanded(
            child: CarouselSlider.builder(
                options: CarouselOptions(
                  initialPage: j,
                  enableInfiniteScroll: false,
                  disableCenter: true,
                  viewportFraction: 1.0,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current[i] = index;
                    });
                  },
                ),
                itemCount: posts[i].images.length,
                itemBuilder: (context, itemIndex, realidx) {
                  return Image.asset(posts[i].images[itemIndex].toString());
                }),
          ),
        ],
      );
    }

    Widget postItem(i, j) {
      return GestureDetector(
        onTap: () {
          showDialog(
              barrierColor: Colors.black.withOpacity(0.8),
              context: context,
              builder: (BuildContext context) {
                return imageDialog(i, j);
              });
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 5.0),
          decoration: BoxDecoration(
              borderRadius: kBorderRadius,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: Image.asset(posts[i].images[j].toString()).image,
              )),
        ),
      );
    }

    Widget moreText(i) {
      return TextButton(
          style: TextButton.styleFrom(
            primary: kGrey,
            minimumSize: Size.zero,
            padding: const EdgeInsets.symmetric(vertical: 5),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailScreen(post: posts[i])));
          },
          child: Text('더보기', style: TextStyle(color: kGrey)));
    }

    Widget multilineText(i) {
      List strList = posts[i].content.split('\n');
      if (strList.length > 3) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(strList.sublist(0, 3).join('\n'),
                style: TextStyle(fontSize: kContentM)),
            moreText(i)
          ],
        );
      } else {
        return Text(posts[i].content, style: TextStyle(fontSize: kContentM));
      }
    }

    Widget dropDownIcon(i) {
      return DropdownButtonHideUnderline(
          child: DropdownButton2(
        customButton: Container(
          padding: const EdgeInsets.all(5),
          child: Icon(
            Icons.more_horiz_rounded,
            color: kBlack,
          ),
        ),
        customItemsIndexes: const [3],
        customItemsHeight: 8,
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
        offset: const Offset(-50, 0),
        onChanged: (value) {
          MenuItems.onChanged(context, value as MenuItem, i);
        },
        itemHeight: 40,
        itemPadding: const EdgeInsets.only(left: 16, right: 16),
        dropdownWidth: 90,
        dropdownDecoration: BoxDecoration(
          borderRadius: kBorderRadius,
          color: kWhite,
        ),
        dropdownElevation: 8,
      ));
    }

    Widget item(i) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 7),
                  alignment: Alignment.centerLeft,
                  child: Text(posts[i].date,
                      style: TextStyle(fontSize: kContentS))),
              dropDownIcon(i)
            ],
          ),
          Stack(
            children: [
              Container(
                alignment: Alignment.center,
                child: CarouselSlider.builder(
                    options: CarouselOptions(
                      enableInfiniteScroll: false,
                      viewportFraction: 1.0,
                      height: width,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _current[i] = index;
                        });
                      },
                    ),
                    itemCount: posts[i].images.length,
                    itemBuilder: (context, itemidx, realidx) {
                      return postItem(i, itemidx);
                    }),
              ),
              posts[i].images.length != 1
                  ? Container(
                      width: width,
                      height: width,
                      alignment: Alignment.bottomRight,
                      padding: const EdgeInsets.symmetric(
                          vertical: 9, horizontal: 15),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.black.withOpacity(0.4)),
                        child: Text(
                            '${_current[i] + 1} / ${posts[i].images.length}',
                            style: TextStyle(
                                color: kWhite.withOpacity(0.9),
                                fontSize: kContentS,
                                fontWeight: FontWeight.bold)),
                      ),
                    )
                  : Container()
            ],
          ),
          Container(
              color: kWhite,
              width: width,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 7),
              alignment: Alignment.centerLeft,
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: listViewSetting[0] == true
                              ? BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    stops: const [
                                      0.65,
                                      0.35,
                                    ],
                                    colors: [
                                      kWhite,
                                      kUnderline,
                                    ],
                                  ),
                                )
                              : const BoxDecoration(),
                          child: Text(
                            posts[i].title,
                            style: TextStyle(fontSize: kTitle),
                          ),
                        ),
                        listViewSetting[1] == true ? moreText(i) : Container()
                      ],
                    ),
                  ),
                  listViewSetting[0] == true
                      ? Container(
                          padding: const EdgeInsets.only(top: 7),
                          alignment: Alignment.centerLeft,
                          child: multilineText(i),
                        )
                      : Container()
                ],
              )),
        ],
      );
    }

    Widget _buildListView() {
      return ListView.separated(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        itemCount: posts.length,
        itemBuilder: (context, i) {
          if (i == posts.length - 1) {
            return Container(
                padding: const EdgeInsets.only(bottom: 30), child: item(i));
          }
          return item(i);
        },
        separatorBuilder: (context, i) => const Divider(),
      );
    }

    return Scaffold(appBar: customAppBar('리스트 보기'), body: _buildListView());
  }
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

  static onChanged(BuildContext context, MenuItem item, i) {
    switch (item) {
      case MenuItems.edit:
        {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ModifyScreen(post: posts[i])));
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
