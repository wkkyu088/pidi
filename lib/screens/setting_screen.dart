import 'package:flutter/material.dart';

import '../widgets/custom_appbar.dart';
import '../constants.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

enum Fonts { gowundodum, gowunbatang, gangwon, mapo, nanum }

class _SettingScreenState extends State<SettingScreen> {
  Fonts? nowFont = Fonts.gowundodum;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width - 50;
    String sampleText =
        '가나다라마바사아자차카타파하\nABCDEFGHIJKLMNOPQRSTUVWXYZ\nabcdefghijklmnopqrstuvwxyz\n1234567890 !@#\$%^&*().,';

    Widget buttonItem(w, s, listValue) {
      return Container(
          width: width / w - 8,
          alignment: Alignment.center,
          child: Text(s, style: TextStyle(fontSize: kTitle)));
    }

    Widget customToggleButton(selectList, children) {
      return ToggleButtons(
          isSelected: selectList,
          onPressed: (int index) {
            setState(() {
              for (int i = 0; i < selectList.length; i++) {
                if (i == index) {
                  selectList[i] = true;
                } else {
                  selectList[i] = false;
                }
              }
            });
          },
          selectedColor: kWhite,
          color: kGrey,
          fillColor: kBlack,
          borderColor: kBlack,
          selectedBorderColor: kBlack,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          children: children.length != 3
              ? [
                  buttonItem(children.length, children[0], selectList[0]),
                  buttonItem(children.length, children[1], selectList[1]),
                ]
              : [
                  buttonItem(children.length, children[0], selectList[0]),
                  buttonItem(children.length, children[1], selectList[1]),
                  buttonItem(children.length, children[2], selectList[2]),
                ]);
    }

    Widget settingItem(title, selectList, children) {
      return Container(
        padding: const EdgeInsets.all(6),
        width: width,
        height: 130.0,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Row(children: [
                Text(
                  title,
                  style: TextStyle(
                      color: kBlack,
                      fontSize: kTitle,
                      fontWeight: FontWeight.bold),
                ),
                IconButton(
                    constraints: const BoxConstraints(),
                    onPressed: () {},
                    icon: Icon(Icons.help_outline_rounded,
                        size: 19, color: kGrey))
              ]),
            ),
            customToggleButton(selectList, children)
          ],
        ),
      );
    }

    Widget radioItem(title, font, Fonts value, isSelected) {
      return SizedBox(
        width: width,
        height: 50,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(
            child: TextButton(
              style: ButtonStyle(
                  alignment: Alignment.centerLeft,
                  overlayColor: MaterialStateProperty.all<Color>(kBackground)),
              onPressed: () {
                setState(() {
                  nowFont = value;
                  fontFamily = font;
                });
              },
              child: Text(title,
                  style: TextStyle(
                    color: kBlack,
                    fontFamily: font,
                    fontSize: kTitle,
                  )),
            ),
          ),
          Transform.scale(
            scale: 1.1,
            child: Radio(
              value: value,
              groupValue: nowFont,
              onChanged: (Fonts? value) {
                setState(() {
                  nowFont = value;
                  fontFamily = font;
                });
              },
              activeColor: kBlack,
            ),
          )
        ]),
      );
    }

    Widget fontSaveButton() {
      return TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            primary: kUnderline,
            padding: EdgeInsets.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            backgroundColor: kBlack,
            shape: RoundedRectangleBorder(
              borderRadius: kBorderRadius,
            ),
          ),
          child:
              Text('적용', style: TextStyle(color: kWhite, fontSize: kContentM)));
    }

    return Scaffold(
        appBar: customAppBar('설정'),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          child: Center(
            child: Column(
              children: [
                settingItem('리스트보기', listViewSetting, ['전체 보기', '제목만 보기']),
                settingItem('갤러리보기', galleryViewSetting, ['1단', '2단', '3단']),
                settingItem('데이트피커', datePickerSetting, ['슬라이드형', '캘린더형']),
                settingItem('캘린더보기', calendarViewSetting, ['1:1 비율', '3:4 비율']),
                settingItem(
                    '캘린더 시작 요일', startingDayofWeekSetting, ['일요일', '월요일']),
                Container(
                  color: kUnderline,
                  width: width,
                  height: 1,
                  margin: const EdgeInsets.only(bottom: 20),
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  margin: const EdgeInsets.only(bottom: 40),
                  width: width,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '폰트 변경',
                                style: TextStyle(
                                    color: kBlack,
                                    fontSize: kTitle,
                                    fontWeight: FontWeight.bold),
                              ),
                              fontSaveButton()
                            ]),
                      ),
                      Center(
                        child: Container(
                            margin: const EdgeInsets.only(top: 5, bottom: 20),
                            width: width,
                            height: 120,
                            decoration: BoxDecoration(
                                color: kBackground,
                                borderRadius: kBorderRadius),
                            alignment: Alignment.center,
                            child: Text(sampleText,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: kContentM,
                                    fontFamily: fontFamily))),
                      ),
                      Column(
                        children: [
                          radioItem(
                              '고운 돋움', 'GowunDodum', Fonts.gowundodum, true),
                          radioItem(
                              '고운 바탕', 'GowunBatang', Fonts.gowunbatang, false),
                          radioItem(
                              '강원교육새음체', 'GangwonSaeum', Fonts.gangwon, false),
                          radioItem(
                              '마포한아름', 'MapoPeacefull', Fonts.mapo, false),
                          radioItem('나눔스퀘어', 'NanumSquare', Fonts.nanum, false),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
