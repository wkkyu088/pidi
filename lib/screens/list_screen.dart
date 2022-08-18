import 'package:flutter/material.dart';
import 'package:pidi/constants.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:pidi/screens/detail_screen.dart';
// import 'package:pidi/screens/modify_screen.dart';

import '../widgets/custom_appbar.dart';
import '../constants.dart';

import 'package:pidi/models/test.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({Key? key}) : super(key: key);

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final _current = List.filled(posts.length, 0);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width - 30;

    Widget postItem(i, j) {
      return Stack(
        alignment: Alignment.center,
        children: [
          listViewRatio[0] == true
              // 1:1 비율 이미지
              ? Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                      borderRadius: kBorderRadius,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: Image.asset(posts[i].images[j].toString()).image,
                      )),
                )
              : Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    fit: BoxFit.scaleDown,
                    image: Image.asset(posts[i].images[j].toString()).image,
                  )),
                ),
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 7),
                  alignment: Alignment.centerLeft,
                  child: Text(posts[i].date,
                      style: TextStyle(fontSize: kContentS))),
              IconButton(
                  icon: const Icon(Icons.more_horiz_rounded),
                  constraints: const BoxConstraints(),
                  color: kBlack,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                DetailScreen(post: posts[i])));
                  }),
            ],
          ),
          Stack(
            children: [
              Container(
                alignment: Alignment.center,
                child: CarouselSlider.builder(
                    options: CarouselOptions(
                      enableInfiniteScroll: false,
                      viewportFraction: 1.0,
                      height: width,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _current[i] = index;
                        });
                      },
                    ),
                    itemCount: posts[i].images.length,
                    itemBuilder: (context, itemidx, realidx) {
                      return postItem(i, itemidx);
                    }),
              ),
              posts[i].images.length != 1
                  ? Container(
                      width: width,
                      height: width,
                      alignment: Alignment.bottomRight,
                      padding: const EdgeInsets.symmetric(
                          vertical: 9, horizontal: 15),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.black.withOpacity(0.4)),
                        child: Text(
                            '${_current[i] + 1} / ${posts[i].images.length}',
                            style: TextStyle(
                                color: kWhite.withOpacity(0.8),
                                fontSize: kContentS,
                                fontWeight: FontWeight.bold)),
                      ),
                    )
                  : Container()
            ],
          ),
          Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 7),
              alignment: Alignment.centerLeft,
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      // decoration: BoxDecoration(
                      //   gradient: LinearGradient(
                      //     begin: Alignment.topCenter,
                      //     end: Alignment.bottomCenter,
                      //     stops: const [
                      //       0.65,
                      //       0.35,
                      //     ],
                      //     colors: [
                      //       kWhite,
                      //       kUnderline,
                      //     ],
                      //   ),
                      // ),
                      child: Text(
                        posts[i].title,
                        style: TextStyle(fontSize: kTitle),
                      ),
                    ),
                  ),
                  // Container(
                  //   padding: const EdgeInsets.only(top: 7),
                  //   alignment: Alignment.centerLeft,
                  //   child: Text(posts[i].content,
                  //       style: TextStyle(fontSize: kContentM)),
                  // ),
                ],
              )),
        ],
      );
    }

    Widget _buildListView() {
      return ListView.separated(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        itemCount: posts.length,
        itemBuilder: (context, i) {
          if (i == posts.length - 1) {
            return Container(
                padding: const EdgeInsets.only(bottom: 30), child: item(i));
          }
          return item(i);
        },
        separatorBuilder: (context, i) => const Divider(),
      );
    }

    return Scaffold(appBar: customAppBar('리스트 보기'), body: _buildListView());
  }
}
