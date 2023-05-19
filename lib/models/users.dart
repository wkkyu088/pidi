import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '../constants.dart';

final firestore = FirebaseFirestore.instance.collection('Users');

Future<void> loginUser(userCredential) async {
  // Firebase에서 user 정보 불러오기
  var user = await firestore.doc(userCredential.user!.uid).get();

  // 불러온 user 정보 constants에 설정
  final v = user.data() as Map;
  uid = userCredential.user!.uid;
  userName = v['userName'];
  email = v['email'];
  profileImg = v['profileImg'];
  calendarViewSetting = [
    v['calendarViewSetting'][0],
    v['calendarViewSetting'][1]
  ];
  listViewSetting = [v['listViewSetting'][0], v['listViewSetting'][1]];
  galleryViewSetting = [
    v['galleryViewSetting'][0],
    v['galleryViewSetting'][1],
    v['galleryViewSetting'][2]
  ];
  startingDayofWeekSetting = [
    v['startingDayofWeekSetting'][0],
    v['startingDayofWeekSetting'][1]
  ];
  fontFamily = v['fontFamily'];
}

Future<void> signupUser(userCredential, emailCont) async {
  // User 컬렉션의 개인 doc 초기화
  final _uid = userCredential.user!.uid;
  final DocumentReference userRef = firestore.doc(_uid);
  await userRef.set({
    'userName': emailCont.text.split('@')[0],
    'email': emailCont.text,
    'profileImg': "",
    'settings': [0, 2, 0, 0, 0],
    'uid': userCredential.user!.uid,
    'listViewSetting': [true, false],
    'galleryViewSetting': [false, false, true],
    'calendarViewSetting': [false, true],
    'startingDayofWeekSetting': [true, false],
    'fontFamily': fontList[0],
  });

  // 해당 doc 하위에 post 컬렉션 생성, sample post 생성
  final CollectionReference postsRef = userRef.collection('postList');
  final postId = DateTime.now().millisecondsSinceEpoch.toString();
  await postsRef.doc(postId).set({
    'title': 'Welcome to PiDi',
    'content': 'This is an example post. You can delete it at any time.',
    'date': Timestamp.fromDate(kToday),
    'images': [
      'https://firebasestorage.googleapis.com/v0/b/pidi-b580e.appspot.com/o/img2.jpg?alt=media&token=cc9a4d7e-84b9-4ca2-afa5-0c5b6d300e14'
    ],
  });

  // constants에 user 정보 초기화
  uid = _uid;
  userName = emailCont.text.split('@')[0];
  email = emailCont.text;
  profileImg = "";
  listViewSetting = [true, false];
  galleryViewSetting = [false, false, true];
  calendarViewSetting = [false, true];
  startingDayofWeekSetting = [true, false];
  fontFamily = fontList[0];
}

Future<void> deleteUser() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    try {
      // 3. 사용자 삭제 요청
      await user.delete();
      await firestore.doc(user.uid).delete();
      print('사용자 정보가 성공적으로 삭제되었습니다.');
    } catch (e) {
      print('사용자 정보 삭제 중 오류가 발생했습니다: $e');
    }
  } else {
    print('현재 로그인된 사용자가 없습니다.');
  }
}
