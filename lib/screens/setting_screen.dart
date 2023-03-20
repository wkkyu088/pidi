import 'package:flutter/material.dart';
import 'package:pidi/screens/login_screen.dart';

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
  bool isLogged = false;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width - 50;
    const profileHeight = 180.0;
    String sampleText =
        '가나다라마바사아자차카타파하\nABCDEFGHIJKLMNOPQRSTUVWXYZ\nabcdefghijklmnopqrstuvwxyz\n1234567890 !@#\$%^&*().,';

    Widget buttonItem(w, s, listValue) {
      return Container(
          width: width / w - 2,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(s, style: TextStyle(fontSize: kContentM + 1)));
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
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          constraints: const BoxConstraints(),
          selectedColor: kWhite,
          color: kGrey,
          fillColor: kBlack,
          borderColor: kBlack,
          selectedBorderColor: kBlack,
          borderRadius: kBorderRadiusS,
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
        padding: const EdgeInsets.only(bottom: 15),
        width: width,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
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
                        size: kTitle, color: kGrey))
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
        height: 45,
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
              child: Text(
                title,
                style: TextStyle(
                  color: kBlack,
                  fontFamily: font,
                  fontSize: font == fontList[2] ? 16 : 13,
                ),
              ),
            ),
          ),
          Radio(
            value: value,
            groupValue: nowFont,
            onChanged: (Fonts? value) {
              setState(() {
                nowFont = value;
                fontFamily = font;
              });
            },
            activeColor: kBlack,
          )
        ]),
      );
    }

    Widget fontSaveButton() {
      return TextButton(
          onPressed: () {
            setState(() {});
          },
          style: TextButton.styleFrom(
            primary: kUnderline,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            backgroundColor: kBlack,
            minimumSize: const Size(0, 0),
            shape: RoundedRectangleBorder(
              borderRadius: kBorderRadiusS,
            ),
          ),
          child:
              Text('적용', style: TextStyle(color: kWhite, fontSize: kContentM)));
    }

    return Scaffold(
        appBar: customAppBar('설정'),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: profileHeight,
                      color: kBlack,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 35,
                            backgroundColor: kUnderline,
                            child: Icon(
                              Icons.person_rounded,
                              size: 40,
                              color: kWhite,
                            ),
                          ),
                          const SizedBox(height: 10),
                          isLogged
                              ? Text(
                                  userid,
                                  style: TextStyle(
                                    fontSize: kTitle,
                                    fontWeight: FontWeight.bold,
                                    color: kWhite,
                                  ),
                                )
                              : TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LoginScreen()));
                                  },
                                  style: TextButton.styleFrom(
                                    primary: kGrey,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    minimumSize: Size.zero,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '로그인하세요',
                                        style: TextStyle(
                                          fontSize: kTitle,
                                          fontWeight: FontWeight.bold,
                                          color: kWhite,
                                        ),
                                      ),
                                      Icon(
                                        Icons.chevron_right_rounded,
                                        color: kWhite,
                                        size: 20,
                                      )
                                    ],
                                  )),
                        ],
                      ),
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.only(
                            top: profileHeight - 5, bottom: 15),
                        child: const Image(
                            image:
                                AssetImage('./assets/images/background2.png'))),
                  ],
                ),
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
                  margin: const EdgeInsets.only(top: 8, bottom: 16),
                ),
                Container(
                  padding: const EdgeInsets.all(0),
                  margin: const EdgeInsets.only(bottom: 30),
                  width: width,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
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
                              color: kBackground, borderRadius: kBorderRadius),
                          alignment: Alignment.center,
                          child: Text(
                            sampleText,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: fontFamily == fontList[2] ? 16 : 13,
                                fontFamily: fontFamily),
                          ),
                        ),
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
