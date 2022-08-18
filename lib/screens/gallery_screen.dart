import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pidi/constants.dart';
import 'package:pidi/models/test.dart';
import 'package:pidi/screens/detail_screen.dart';

import '../widgets/custom_appbar.dart';
import '../constants.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({Key? key}) : super(key: key);

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  // posts에서 이미지 가져올 수 있도록 작성했는데 화면에 이미지가 안 나와서 주석처리
  // 함수 잘만들었는데 실행을 안해서 안보이던거였어...!! 유레카  -규진
  List images = [];
  void getImages() {
    for (int i = 0; i < posts.length; i++) {
      for (int j = 0; j < posts[i].images.length; j++) {
        images.add([posts[i].date, posts[i].images[j]]);
        // print(posts[i].images[j]);
      }
    }
  }

  // final images = [
  //   ['2020-02-02', './assets/images/img0.jpg'],
  //   ['2020-02-02', './assets/images/img1.jpg'],
  //   ['2020-02-02', './assets/images/img2.jpg'],
  //   ['2020-02-02', './assets/images/img3.jpg'],
  //   ['2020-02-02', './assets/images/img4.jpg'],
  //   ['2020-02-02', './assets/images/img5.jpg'],
  //   ['2020-02-02', './assets/images/img0.jpg'],
  //   ['2020-02-02', './assets/images/img1.jpg'],
  //   ['2020-02-02', './assets/images/img2.jpg'],
  //   ['2020-02-02', './assets/images/img3.jpg'],
  //   ['2020-02-02', './assets/images/img4.jpg'],
  //   ['2020-02-02', './assets/images/img5.jpg'],
  //   ['2020-02-02', './assets/images/img0.jpg'],
  //   ['2020-02-02', './assets/images/img1.jpg'],
  //   ['2020-02-02', './assets/images/img2.jpg'],
  //   ['2020-02-02', './assets/images/img3.jpg'],
  //   ['2020-02-02', './assets/images/img1.jpg'],
  //   ['2020-02-02', './assets/images/img4.jpg'],
  //   ['2020-02-02', './assets/images/img5.jpg'],
  //   ['2020-02-02', './assets/images/img0.jpg'],
  // ];

  @override
  Widget build(BuildContext context) {
    getImages();

    return Scaffold(
        appBar: customAppBar('갤러리 보기'),
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 6.0),
          child: MasonryGridView.count(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            crossAxisCount: galleryViewColumn.indexOf(true) + 1,
            itemCount: images.length,
            itemBuilder: (BuildContext context, int index) => Container(
              margin:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
              child: GestureDetector(
                onTap: () {
                  int idx = -1;
                  for (int i = 0; i < posts.length; i++) {
                    if (posts[i].date == images[index][0]) {
                      idx = i;
                      break;
                    }
                  }

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              DetailScreen(post: posts[idx])));
                },
                child: Stack(
                  children: <Widget>[
                    // 사진
                    ClipRRect(
                      borderRadius: kBorderRadius,
                      child: Image.asset(
                        images[index][1],
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
                        images[index][0],
                        style: TextStyle(color: kWhite, fontSize: kContentS),
                      ),
                    )),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
