import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import 'package:pidi/screens/login_screen.dart';
import 'package:pidi/widgets/custom_appbar.dart';
import 'package:pidi/widgets/custom_dialog.dart';

import '../constants.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

enum Fonts { gowundodum, gowunbatang, gangwon, mapo, nanum }

class _SettingScreenState extends State<SettingScreen> {
  Fonts? nowFont;
  var isEdit = false;
  final ImagePicker picker = ImagePicker();
  XFile? _pickedImage;

  @override
  void initState() {
    super.initState();
    switch (fontFamily) {
      case 'GowunDodum':
        nowFont = Fonts.gowundodum;
        break;
      case 'GowunBatang':
        nowFont = Fonts.gowunbatang;
        break;
      case 'GangwonSaeum':
        nowFont = Fonts.gangwon;
        break;
      case 'MapoPeacefull':
        nowFont = Fonts.mapo;
        break;
      case 'NanumSquare':
        nowFont = Fonts.nanum;
        break;
    }
    print(nowFont);
  }

  Future setProfileImg() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    final ref = FirebaseStorage.instance.ref();
    final id = DateTime.now().millisecondsSinceEpoch.toString();

    if (image != null) {
      final imgRef = ref.child('$id.jpg');
      File file = File(image.path);
      await imgRef.putFile(file);
      final url = await imgRef.getDownloadURL();

      _pickedImage = image;
      profileImg = url;
      FirebaseFirestore.instance
          .collection('Users')
          .doc(uid)
          .update({'profileImg': url});
      Fluttertoast.showToast(msg: "프로필 이미지가 변경되었습니다.");
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width - 50;
    const profileHeight = 180.0;
    final nameCont = TextEditingController(text: userName);
    String sampleText =
        '가나다라마바사아자차카타파하\nABCDEFGHIJKLMNOPQRSTUVWXYZ\nabcdefghijklmnopqrstuvwxyz\n1234567890 !@#\$%^&*().,';

    Widget buttonItem(w, s, listValue) {
      return Container(
          width: width / w - 2,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(s, style: TextStyle(fontSize: kContentM + 1)));
    }

    Widget customToggleButton(selectList, listName, children) {
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
            print("$listName : $selectList");
            FirebaseFirestore.instance
                .collection('Users')
                .doc(uid)
                .update({listName: selectList});
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

    Widget settingItem(title, selectList, listName, children) {
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
            customToggleButton(selectList, listName, children)
          ],
        ),
      );
    }

    Widget radioItem(title, font, Fonts value) {
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
                  print(fontFamily);
                  nowFont = value;
                  fontFamily = font;
                  print("$font $fontFamily");
                  FirebaseFirestore.instance
                      .collection('Users')
                      .doc(uid)
                      .update({'fontFamily': font});
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
                print(fontFamily);
                nowFont = value;
                fontFamily = font;
                print("$font $fontFamily");
                FirebaseFirestore.instance
                    .collection('Users')
                    .doc(uid)
                    .update({'fontFamily': font});
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

    // Widget editNameField() {
    //   return SizedBox(
    //     width: 120,
    //     child: TextField(
    //       controller: nameCont,
    //       maxLines: 1,
    //       cursorColor: kGrey,
    //       keyboardType: TextInputType.text,
    //       style: TextStyle(
    //         fontSize: kTitle,
    //         fontWeight: FontWeight.bold,
    //         color: kWhite,
    //       ),
    //       decoration: InputDecoration(
    //         isCollapsed: true,
    //         isDense: true,
    //         contentPadding: const EdgeInsets.only(bottom: 5, left: 5, right: 5),
    //         focusedBorder:
    //             UnderlineInputBorder(borderSide: BorderSide(color: kGrey)),
    //         enabledBorder:
    //             UnderlineInputBorder(borderSide: BorderSide(color: kGrey)),
    //         hintStyle: TextStyle(fontSize: kTitle, color: kGrey),
    //         counterText: '',
    //       ),
    //     ),
    //   );
    // }

    // Widget beforeEdit() {
    //   return Row(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     crossAxisAlignment: CrossAxisAlignment.center,
    //     children: [
    //       Text(
    //         userName,
    //         style: TextStyle(
    //           fontSize: kTitle,
    //           fontWeight: FontWeight.bold,
    //           color: kWhite,
    //         ),
    //       ),
    //       IconButton(
    //         onPressed: () {
    //           isEdit = true;
    //           setState(() {});
    //         },
    //         padding: const EdgeInsets.only(left: 5),
    //         constraints: const BoxConstraints(),
    //         icon: const Icon(Icons.edit_rounded),
    //         iconSize: kTitle - 2,
    //         color: Colors.grey,
    //       )
    //     ],
    //   );
    // }

    // Widget afterEdit() {
    //   return Row(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     crossAxisAlignment: CrossAxisAlignment.center,
    //     children: [
    //       editNameField(),
    //       IconButton(
    //         onPressed: () {
    //           isEdit = false;
    //           print(nameCont.text);
    //           userName = nameCont.text;
    //           FirebaseFirestore.instance
    //               .collection('Users')
    //               .doc(uid)
    //               .update({'userName': nameCont.text});
    //           Fluttertoast.showToast(
    //               msg: "수정되었습니다.", gravity: ToastGravity.BOTTOM);
    //           setState(() {});
    //         },
    //         padding: const EdgeInsets.only(left: 5),
    //         constraints: const BoxConstraints(),
    //         icon: const Icon(Icons.check_rounded),
    //         iconSize: kTitle,
    //         color: Colors.grey,
    //       ),
    //       IconButton(
    //         onPressed: () {
    //           isEdit = false;
    //           setState(() {});
    //         },
    //         padding: const EdgeInsets.only(left: 5),
    //         constraints: const BoxConstraints(),
    //         icon: const Icon(Icons.close_rounded),
    //         iconSize: kTitle,
    //         color: Colors.grey,
    //       )
    //     ],
    //   );
    // }

    Widget logoutButton() {
      return TextButton(
        onPressed: () {
          customDialog(
            context,
            "잠시만요!",
            "정말 로그아웃 하시겠습니까?",
            () {
              Fluttertoast.showToast(msg: "로그아웃 되었습니다.");
              FirebaseAuth.instance.signOut();
              uid = "";
              userName = "";
              email = "";
              listViewSetting = [true, false];
              galleryViewSetting = [false, false, true];
              calendarViewSetting = [false, true];
              startingDayofWeekSetting = [true, false];
              fontFamily = fontList[0];
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false);
            },
          );
        },
        style: TextButton.styleFrom(
          primary: kGrey,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          minimumSize: Size.zero,
        ),
        child: SizedBox(
          width: width,
          child: Row(
            children: [
              Text(
                '로그아웃',
                style: TextStyle(
                  fontSize: kContentM,
                  fontWeight: FontWeight.bold,
                  color: kGrey,
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget deleteAccountButton() {
      return TextButton(
        onPressed: () async {
          print("계정 삭제됨");
          print(FirebaseAuth.instance.currentUser?.uid);
          customDialog(
            context,
            "잠시만요!",
            "사용자 정보와 기록이 모두 삭제됩니다.\n정말 계정을 삭제하시겠습니까?",
            () {
              Fluttertoast.showToast(msg: "계정이 삭제되었습니다.");
              FirebaseAuth.instance.currentUser?.delete();
              FirebaseFirestore.instance.collection('Users').doc(uid).delete();
              // Posts 컬렉션에 uid가 해당 사용자인 post를 모두 삭제
              uid = "";
              userName = "";
              email = "";
              listViewSetting = [true, false];
              galleryViewSetting = [false, false, true];
              calendarViewSetting = [false, true];
              startingDayofWeekSetting = [true, false];
              fontFamily = fontList[0];
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false);
            },
            isDelete: true,
          );
        },
        style: TextButton.styleFrom(
          primary: kGrey,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          minimumSize: Size.zero,
        ),
        child: SizedBox(
          width: width,
          child: Row(
            children: [
              Text(
                '계정 삭제',
                style: TextStyle(
                  fontSize: kContentM,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: customAppBar('설정'),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              // Stack(
              //   children: [
              //     Container(
              //       width: MediaQuery.of(context).size.width,
              //       height: profileHeight,
              //       color: kBlack,
              //       padding: const EdgeInsets.symmetric(horizontal: 20),
              //       child: Column(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         crossAxisAlignment: CrossAxisAlignment.center,
              //         children: [
              //           GestureDetector(
              //             onLongPress: setProfileImg,
              //             child: CircleAvatar(
              //               radius: 35,
              //               backgroundColor: kUnderline,
              //               backgroundImage: profileImg != ""
              //                   ? _pickedImage == null
              //                       ? Image.network(profileImg).image
              //                       : FileImage(File(_pickedImage!.path))
              //                   : null,
              //               child: profileImg == ""
              //                   ? Icon(
              //                       Icons.person_rounded,
              //                       size: 40,
              //                       color: kWhite,
              //                     )
              //                   : null,
              //             ),
              //           ),
              //           const SizedBox(height: 10),
              //           uid != ""
              //               ? isEdit
              //                   ? afterEdit()
              //                   : beforeEdit()
              //               : TextButton(
              //                   onPressed: () {
              //                     Navigator.push(
              //                         context,
              //                         MaterialPageRoute(
              //                             builder: (context) =>
              //                                 const LoginScreen()));
              //                   },
              //                   style: TextButton.styleFrom(
              //                     primary: kGrey,
              //                     tapTargetSize:
              //                         MaterialTapTargetSize.shrinkWrap,
              //                     minimumSize: Size.zero,
              //                   ),
              //                   child: Row(
              //                     mainAxisAlignment: MainAxisAlignment.center,
              //                     children: [
              //                       Text(
              //                         '로그인하세요',
              //                         style: TextStyle(
              //                           fontSize: kTitle,
              //                           fontWeight: FontWeight.bold,
              //                           color: kWhite,
              //                         ),
              //                       ),
              //                       Icon(
              //                         Icons.chevron_right_rounded,
              //                         color: kWhite,
              //                         size: 20,
              //                       )
              //                     ],
              //                   )),
              //         ],
              //       ),
              //     ),
              //     Container(
              //         width: MediaQuery.of(context).size.width,
              //         padding: const EdgeInsets.only(
              //             top: profileHeight - 5, bottom: 15),
              //         child: const Image(
              //             image:
              //                 AssetImage('./assets/images/background2.png'))),
              //   ],
              // ),
              settingItem('리스트보기', listViewSetting, 'listViewSetting',
                  ['전체 보기', '제목만 보기']),
              settingItem('갤러리보기', galleryViewSetting, 'galleryViewSetting',
                  ['1단', '2단', '3단']),
              settingItem('캘린더보기', calendarViewSetting, 'calendarViewSetting',
                  ['1:1 비율', '3:4 비율']),
              settingItem('캘린더 시작 요일', startingDayofWeekSetting,
                  'startingDayofWeekSetting', ['일요일', '월요일']),
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
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          fontSaveButton(),
                        ],
                      ),
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
                        radioItem('고운 돋움', 'GowunDodum', Fonts.gowundodum),
                        radioItem('고운 바탕', 'GowunBatang', Fonts.gowunbatang),
                        radioItem('강원교육새음체', 'GangwonSaeum', Fonts.gangwon),
                        radioItem('마포한아름', 'MapoPeacefull', Fonts.mapo),
                        radioItem('나눔스퀘어', 'NanumSquare', Fonts.nanum),
                      ],
                    )
                  ],
                ),
              ),
              uid != ""
                  ? Column(
                      children: [
                        Container(
                          color: kUnderline,
                          width: width,
                          height: 1,
                          margin: const EdgeInsets.only(top: 8, bottom: 16),
                        ),
                        logoutButton(),
                        deleteAccountButton(),
                        const SizedBox(height: 40),
                      ],
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
