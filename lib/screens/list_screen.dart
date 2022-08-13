import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:pidi/constants.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../widgets/custom_appbar.dart';
import '../constants.dart';

import 'package:pidi/models/test.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({Key? key}) : super(key: key);

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  @override
  Widget build(BuildContext context) {
    // final List<String> dates = <String>[
    //   '2022-07-25',
    //   '2022-07-10',
    //   '2022-07-02'
    // ];
    // final List<String> images = <String>['0', '1', '2'];
    // final List<String> titles = <String>[
    //   '사진 진짜 마음에 든다 너무 이뻐',
    //   '구름이 양털같네',
    //   '어떻게 구름이 하나도 없지?'
    // ];

    Widget postItem(i, j) {
      return Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
              borderRadius: kBorderRadiusL,
              child: Image.asset(posts[i].images[j].toString(),
                  fit: BoxFit.cover)),
          // 몇페이지인지 나타내기
          posts[i].images.length != 1
              ? Positioned(
                  bottom: 20,
                  child: AnimatedSmoothIndicator(
                    activeIndex: j,
                    count: posts[i].images.length,
                    effect: ScrollingDotsEffect(
                      dotHeight: 8,
                      dotWidth: 8,
                      dotColor: kGrey,
                      activeDotColor: kWhite,
                    ),
                  ))
              : Container(),
        ],
      );
    }

    Widget item(i) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 5.0),
                  alignment: Alignment.centerLeft,
                  child: Text(posts[i].date,
                      style: TextStyle(fontSize: kContentS))),
              IconButton(
                  icon: const Icon(Icons.more_horiz_rounded),
                  color: kBlack,
                  onPressed: () {}),
            ],
          ),
          Container(
            alignment: Alignment.center,
            child: CarouselSlider.builder(
                options: CarouselOptions(
                  enableInfiniteScroll: false,
                  viewportFraction: 1.0,
                  height: MediaQuery.of(context).size.width - 40,
                ),
                itemCount: posts[i].images.length,
                itemBuilder: (context, itemidx, realidx) {
                  return postItem(i, itemidx);
                }),
          ),
          Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
              alignment: Alignment.centerLeft,
              child: Text(posts[i].title, style: TextStyle(fontSize: kTitle))),
        ],
      );
    }

    Widget _buildListView() {
      return ListView.separated(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        itemCount: posts.length,
        itemBuilder: (context, i) {
          return item(i);
        },
        separatorBuilder: (context, i) => const Divider(),
      );
    }

    return Scaffold(appBar: customAppBar('리스트 보기'), body: _buildListView());
  }
}
