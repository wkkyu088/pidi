import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pidi/constants.dart';
import 'package:pidi/screens/detail_screen.dart';
import 'package:pidi/screens/test_screen.dart';

import '../models/item.dart';
import '../widgets/custom_appbar.dart';
import '../constants.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({Key? key}) : super(key: key);

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  var db = FirebaseFirestore.instance.collection('posts');
  List galleryList = [];

  List<String> getImages(DocumentSnapshot<Map<String, dynamic>> value) {
    // 값도 잘 전달됨 확인
    print('in');
    print(value['images']);
    List<String> imgList = [];
    for (int i = 0; i < value['images'].length(); i++) {
      print(value['images'][i]);
      imgList.add(value['images'][i].toString());
    }
    print('out');
    print(imgList);
    return imgList;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: db.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Wrong");
          }
          //if (snapshot.connectionState == ConnectionState.waiting) {
          //  return LoadingScreen());
          //}
          for (var doc in snapshot.data!.docs) {
            for (int i = 0; i < doc['images'].length; i++) {
              galleryList.add([doc.id, doc['date'], doc['images'][i]]);
            }
          }

          return Scaffold(
              appBar: customAppBar('갤러리 보기'),
              body: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 6.0),
                child: MasonryGridView.count(
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  crossAxisCount: galleryViewSetting.indexOf(true) + 1,
                  itemCount: galleryList.length,
                  itemBuilder: (BuildContext context, int index) => Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 5.0),
                    child: GestureDetector(
                      onTap: () async {
                        // value를 통해 해당 id doc 접근 완료
                        var detail = await db
                            .doc(galleryList[index][0])
                            .get()
                            .then((value) {
                          return Item(
                              title: value['title'],
                              date: value['date'],
                              content: value['content'],
                              images: [
                                "https://firebasestorage.googleapis.com/v0/b/pidi-b580e.appspot.com/o/img1.jpg?alt=media&token=93fca8ea-f813-4a58-ba78-13337ea1f538"
                              ]);

                          // Error: NoSuchMethodError: 'call'
                          // Dynamic call of object has no instance method 'call'.
                          // Receiver: 4
                          // Arguments: []
                          // images: getImages(value));

                          // Error: Expected a value of type 'List<String>', but got one of type 'List<dynamic>'
                          // images: value['images']
                          //     .map((e) => e.toString())
                          //     .toList());
                        });
                        print(detail);
                        // Item detailPost = Item.fromJson(detail);
                        // Item(
                        //     title: "투썸플레이스",
                        //     date: "2022-08-10",
                        //     content: "케이크 맛집으로 마케팅을 잘했어\n케이크 맛집",
                        //     images: ["./assets/images/img4.jpg"]);

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    TestDetailScreen(post: detail)));
                      },
                      child: Stack(
                        children: <Widget>[
                          // 사진
                          ClipRRect(
                            borderRadius: kBorderRadius,
                            child: Image.network(
                              galleryList[index][2].toString(),
                              fit: BoxFit.contain,
                            ),
                          ),
                          // 날짜 표시줄
                          Center(
                              child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 7.0),
                            padding: const EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 15.0),
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.4),
                                borderRadius: kBorderRadiusL),
                            child: Text(
                              galleryList[index][1],
                              style:
                                  TextStyle(color: kWhite, fontSize: kContentS),
                            ),
                          )),
                        ],
                      ),
                    ),
                  ),
                ),
              ));
        });
  }
}
