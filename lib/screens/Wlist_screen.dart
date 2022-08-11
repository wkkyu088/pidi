import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../widgets/custom_appbar.dart';
import '../constants.dart';

import 'package:pidi/models/test.dart';

class WListScreen extends StatefulWidget {
  const WListScreen({Key? key}) : super(key: key);

  @override
  State<WListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<WListScreen> {
  final _current = List.filled(posts.length, 0);
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    Widget item(i) {
      return Column(
        children: [
          Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 7.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(posts[i].date, style: TextStyle(fontSize: kContentS)),
                  IconButton(
                      icon: const Icon(Icons.more_horiz_rounded),
                      constraints: const BoxConstraints(),
                      color: kBlack,
                      onPressed: () {}),
                ],
              )),
          Column(children: [
            Stack(
              children: [
                CarouselSlider(
                  carouselController: _controller,
                  options: CarouselOptions(
                    enableInfiniteScroll: false,
                    viewportFraction: 1.0,
                    height: width - 40,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current[i] = index;
                      });
                    },
                  ),
                  items: posts[i].images.map((src) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                              borderRadius: kBorderRadius,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: Image.asset(src).image,
                              )),
                        );
                      },
                    );
                  }).toList(),
                ),
                // 인디케이터 1번
                // imgList[i].length != 1
                //     ? Container(
                //         width: width - 40,
                //         height: width-40,
                //         alignment: Alignment.bottomRight,
                //         padding: const EdgeInsets.symmetric(
                //             vertical: 8, horizontal: 18),
                //         child: Text('${_current[i] + 1} / ${imgList[i].length}',
                //             style: TextStyle(
                //                 color: kWhite.withOpacity(0.8),
                //                 fontSize: kContentM,
                //                 fontWeight: FontWeight.bold)))
                //     : Container(),
                // 인디케이터 2번
                posts[i].images.length != 1
                    ? Container(
                        width: width - 40,
                        height: width - 40,
                        alignment: Alignment.bottomRight,
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 3),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.black.withOpacity(0.4)),
                          child: Text(
                              '${_current[i] + 1} / ${posts[i].images.length}',
                              style: TextStyle(
                                  color: kWhite.withOpacity(0.8),
                                  fontSize: kContentM,
                                  fontWeight: FontWeight.bold)),
                        ))
                    : Container()
              ],
            ),
            // 인디케이터 3번
            // imgList[i].length != 1
            //     ? Row(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: imgList[i].asMap().entries.map((entry) {
            //           return GestureDetector(
            //             child: Container(
            //               width: 10.0,
            //               height: 10.0,
            //               margin:
            //                   const EdgeInsets.only(top: 10, left: 5, right: 5),
            //               decoration: BoxDecoration(
            //                   shape: BoxShape.circle,
            //                   color: Colors.black.withOpacity(
            //                       _current[i] == entry.key ? 0.9 : 0.3)),
            //             ),
            //           );
            //         }).toList(),
            //       )
            //     : Container(),
            // 인디케이터 4번
            // imgList[i].length != 1
            //     ? Row(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: imgList[i].asMap().entries.map((entry) {
            //           return GestureDetector(
            //             child: Container(
            //               width: 23,
            //               height: 3,
            //               margin:
            //                   const EdgeInsets.only(top: 10, left: 3, right: 3),
            //               decoration: BoxDecoration(
            //                   color: Colors.black.withOpacity(
            //                       _current[i] == entry.key ? 0.9 : 0.2)),
            //             ),
            //           );
            //         }).toList(),
            //       )
            //     : Container()
          ]),
          Container(
              alignment: Alignment.centerLeft,
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 7.0),
              child: Text(
                posts[i].title,
                style: TextStyle(fontSize: kTitle),
              )),
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
