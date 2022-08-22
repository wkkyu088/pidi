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
  final Stream<QuerySnapshot> posts =
      FirebaseFirestore.instance.collection('posts').snapshots();
  List galleryList = [];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: posts,
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
                        Item detailPost = Item(
                            title: "투썸플레이스",
                            date: "2022-08-10",
                            content: "케이크 맛집으로 마케팅을 잘했어\n케이크 맛집",
                            images: ["./assets/images/img4.jpg"]);

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    TestDetailScreen(post: detailPost)));
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
