import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:intl/intl.dart';
import 'package:pidi/constants.dart';
import 'package:pidi/models/singleton.dart';
import 'package:pidi/screens/detail_screen.dart';
import '../models/item.dart';
import '../widgets/custom_appbar.dart';
import '../constants.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({Key? key}) : super(key: key);

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  var postList;
  List galleryList = [];

  void getGalleryList() {
    for (var value in postList) {
      for (int i = 0; i < value.images.length; i++) {
        galleryList.add([
          value.id,
          DateFormat('yyyy-MM-dd').format(value.date),
          value.images[i]
        ]);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    postList = Singleton().postList;
    getGalleryList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar('갤러리 보기'),
      body: RefreshIndicator(
        onRefresh: () {
          setState(() {});
          return Future<void>.value();
        },
        child: _buildGalleryView(),
      ),
    );
  }

  Widget _buildGalleryView() {
    if (postList.isEmpty) {
      return const Center(child: Text("기록이 없습니다."));
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: MasonryGridView.count(
        crossAxisCount: galleryViewSetting.indexOf(true) + 1,
        itemCount: galleryList.length,
        itemBuilder: (BuildContext context, int index) => Container(
          margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 3),
          child: GestureDetector(
            onTap: () async {
              // value를 통해 해당 id doc 접근 완료
              var detail;
              for (int i = 0; i < postList.length; i++) {
                if (postList[i].id == galleryList[index][0]) {
                  detail = postList[i];
                }
              }
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailScreen(post: detail)));
            },
            child: Stack(
              children: <Widget>[
                // 사진
                ClipRRect(
                    borderRadius: kBorderRadius,
                    // child: Image.network(
                    //   galleryList[index][2].toString(),
                    //   fit: BoxFit.contain,
                    //   // loadingBuilder: (BuildContext context, Widget child,
                    //   //     ImageChunkEvent? loadingProgress) {
                    //   //   if (loadingProgress == null) {
                    //   //     return child;
                    //   //   }
                    //   //   return Container(
                    //   //       height: 150,
                    //   //       decoration: BoxDecoration(color: kWhite),
                    //   //       child: Center(
                    //   //           child: CircularProgressIndicator(
                    //   //               color: kGrey, strokeWidth: 2)));
                    //   // },
                    // ),
                    child: CachedNetworkImage(
                        imageUrl: galleryList[index][2].toString(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error))),
                // 날짜 표시줄
                Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 14),
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        borderRadius: kBorderRadiusL),
                    child: Text(
                      galleryList[index][1],
                      style: TextStyle(color: kWhite, fontSize: kContentS),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
