import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pidi/main.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pidi/models/users.dart';

import '../constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailCont = TextEditingController();
  final pwCont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: SizedBox(
              width: screenWidth * 0.45,
              child: const Image(
                image: AssetImage('./assets/images/logo.png'),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.12),
            child: Column(
              children: [
                TextField(
                  controller: emailCont,
                  maxLines: 1,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(fontSize: kContentM),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.mail_rounded),
                    isCollapsed: true,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: kBlack, width: 1),
                      borderRadius: kBorderRadiusS,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: kGrey, width: 1),
                      borderRadius: kBorderRadiusS,
                    ),
                    hintText: '이메일',
                    hintStyle: TextStyle(fontSize: kContentM, color: kGrey),
                    counterText: '',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: pwCont,
                  maxLines: 1,
                  maxLength: 20,
                  obscureText: true,
                  obscuringCharacter: "*",
                  style: TextStyle(fontSize: kContentM),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_rounded),
                    isCollapsed: true,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: kBlack, width: 1),
                      borderRadius: kBorderRadiusS,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: kGrey, width: 1),
                      borderRadius: kBorderRadiusS,
                    ),
                    hintText: '비밀번호',
                    hintStyle: TextStyle(fontSize: kContentM, color: kGrey),
                    counterText: '',
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.only(
                  top: 30, left: screenWidth * 0.12, right: screenWidth * 0.12),
              child: Column(
                children: [
                  TextButton(
                    onPressed: () async {
                      try {
                        print("${emailCont.text} ${pwCont.text}");
                        UserCredential userCredential = await FirebaseAuth
                            .instance
                            .signInWithEmailAndPassword(
                                email: emailCont.text, password: pwCont.text);
                        if (userCredential.user != null) {
                          print("로그인 성공");
                          await loginUser(userCredential);
                          print({
                            'uid': uid,
                            'userName': userName,
                            'email': email,
                            'profileImg': profileImg,
                            'listViewSetting': listViewSetting,
                            'galleryViewSetting': galleryViewSetting,
                            'calendarViewSetting': calendarViewSetting,
                            'startingDayofWeekSetting':
                                startingDayofWeekSetting,
                            'fontFamily': fontFamily,
                          });
                          Fluttertoast.showToast(msg: "로그인 되었습니다.");
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const MainPage()),
                              (route) => false);
                        }
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          Fluttertoast.showToast(msg: "등록되지 않은 이메일입니다.");
                          print('등록되지 않은 이메일');
                        } else if (e.code == 'wrong-password') {
                          Fluttertoast.showToast(msg: "비밀번호가 틀렸습니다.");
                          print('비밀번호가 틀림');
                        } else if (e.code == 'invalid-email') {
                          Fluttertoast.showToast(msg: "잘못된 이메일 형식입니다.");
                          print('잘못된 이메일 형식');
                        } else {
                          print('${e.code} : 알 수 없는 오류');
                        }
                      }
                    },
                    style: TextButton.styleFrom(
                      primary: kBlack,
                      backgroundColor: kBlack,
                      shape:
                          RoundedRectangleBorder(borderRadius: kBorderRadius),
                      minimumSize: Size(screenWidth, 50),
                    ),
                    child: Text(
                      '로그인',
                      style: TextStyle(
                        color: kWhite,
                        fontSize: kContentM,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () async {
                      try {
                        print("${emailCont.text} ${pwCont.text}");
                        UserCredential userCredential = await FirebaseAuth
                            .instance
                            .createUserWithEmailAndPassword(
                                email: emailCont.text, password: pwCont.text);
                        if (userCredential.user != null) {
                          print("회원가입 성공");
                          await signupUser(userCredential, emailCont);
                          print({
                            'uid': uid,
                            'userName': userName,
                            'email': email,
                            'profileImg': '',
                            'listViewSetting': listViewSetting,
                            'galleryViewSetting': galleryViewSetting,
                            'calendarViewSetting': calendarViewSetting,
                            'startingDayofWeekSetting':
                                startingDayofWeekSetting,
                            'fontFamily': fontFamily,
                          });
                          Fluttertoast.showToast(msg: "회원가입 되었습니다.");
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MainPage()),
                              (route) => false);
                        }
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'email-already-in-use') {
                          Fluttertoast.showToast(
                            msg: "이미 있는 계정입니다.",
                          );
                          print('이미 계정이 있음');
                        } else if (e.code == 'weak-password') {
                          Fluttertoast.showToast(msg: "비밀번호가 너무 약합니다.");
                          print('비밀번호가 너무 약함');
                        } else if (e.code == 'invalid-email') {
                          Fluttertoast.showToast(msg: "잘못된 이메일 형식입니다.");
                          print('잘못된 이메일 형식');
                        } else {
                          print('${e.code} : 알 수 없는 오류');
                        }
                      }
                    },
                    style: TextButton.styleFrom(
                      primary: kBlack,
                      backgroundColor: Colors.transparent,
                      shape:
                          RoundedRectangleBorder(borderRadius: kBorderRadius),
                      side: BorderSide(color: kBlack, width: 1),
                      minimumSize: Size(screenWidth, 50),
                    ),
                    child: Text(
                      '회원가입',
                      style: TextStyle(
                        color: kBlack,
                        fontSize: kContentM,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
