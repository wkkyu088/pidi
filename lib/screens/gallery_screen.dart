import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pidi/constants.dart';

import '../widgets/custom_appbar.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({Key? key}) : super(key: key);

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final images = [
    ['2020-02-02', './assets/images/img0.jpg'],
    ['2020-02-02', './assets/images/img1.jpg'],
    ['2020-02-02', './assets/images/img2.jpg'],
    ['2020-02-02', './assets/images/img3.jpg'],
    ['2020-02-02', './assets/images/img4.jpg'],
    ['2020-02-02', './assets/images/img5.JPG'],
    ['2020-02-02', './assets/images/img0.jpg'],
    ['2020-02-02', './assets/images/img1.jpg'],
    ['2020-02-02', './assets/images/img2.jpg'],
    ['2020-02-02', './assets/images/img3.jpg'],
    ['2020-02-02', './assets/images/img4.jpg'],
    ['2020-02-02', './assets/images/img5.JPG'],
    ['2020-02-02', './assets/images/img0.jpg'],
    ['2020-02-02', './assets/images/img1.jpg'],
    ['2020-02-02', './assets/images/img2.jpg'],
    ['2020-02-02', './assets/images/img3.jpg'],
    ['2020-02-02', './assets/images/img4.jpg'],
    ['2020-02-02', './assets/images/img5.JPG'],
    ['2020-02-02', './assets/images/img0.jpg'],
    ['2020-02-02', './assets/images/img1.jpg'],
    ['2020-02-02', './assets/images/img2.jpg'],
    ['2020-02-02', './assets/images/img3.jpg'],
    ['2020-02-02', './assets/images/img4.jpg'],
    ['2020-02-02', './assets/images/img5.JPG'],
  ];
  Radius kborderRadius = Radius.circular(10.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppBar('갤러리 보기'),
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 6.0),
          child: MasonryGridView.count(
            crossAxisCount: 3,
            itemCount: images.length,
            itemBuilder: (BuildContext context, int index) => Container(
              margin:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
              child: Stack(
                children: <Widget>[
                  // 사진
                  ClipRRect(
                    borderRadius: BorderRadius.all(kborderRadius),
                    child: Image.asset(
                      images[index][1],
                      fit: BoxFit.contain,
                    ),
                  ),
                  // 날짜 표시줄
                  Center(
                      child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 10.0),
                    decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.all(kborderRadius)),
                    child: Text(
                      images[index][0],
                      style: TextStyle(color: kWhite),
                    ),
                  )),
                ],
              ),
            ),
          ),
        ));
  }
}
