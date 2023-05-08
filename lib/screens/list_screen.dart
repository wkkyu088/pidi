import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:pidi/models/singleton.dart';
import 'package:pidi/screens/detail_screen.dart';

import '../models/item.dart';
import '../widgets/custom_appbar.dart';
import '../constants.dart';

import '../widgets/dropdown_button.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({Key? key}) : super(key: key);

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  var postList;
  final _current = List.filled(100, 0);
  late ScrollController _scrollController;

  Widget imageDialog(i, j) {
    return Column(
      children: [
        Expanded(
            child: CarouselSlider.builder(
                options: CarouselOptions(
                  initialPage: j,
                  enableInfiniteScroll: false,
                  disableCenter: true,
                  viewportFraction: 1.0,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current[i] = index;
                    });
                  },
                ),
                itemCount: postList[i].images.length,
                itemBuilder: (context, itemIndex, realidx) {
                  return CachedNetworkImage(
                    imageUrl: postList[i].images[itemIndex].toString(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  );
                })),
        Container(
          width: 40,
          height: 50,
          alignment: Alignment.center,
          padding: const EdgeInsets.only(bottom: 10),
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.close_rounded,
              size: 30,
              color: kWhite,
            ),
          ),
        ),
      ],
    );
  }

  Widget postItem(i, j) {
    return GestureDetector(
        onTap: () {
          showDialog(
              barrierColor: Colors.black.withOpacity(0.8),
              context: context,
              builder: (BuildContext context) {
                return imageDialog(i, j);
              });
        },
        child: CachedNetworkImage(
          imageUrl: postList[i].images[j].toString(),
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              borderRadius: kBorderRadius,
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ));
  }

  Widget moreText(i) {
    return TextButton(
        style: TextButton.styleFrom(
          primary: kGrey,
          minimumSize: Size.zero,
          padding: const EdgeInsets.symmetric(vertical: 5),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailScreen(post: postList[i])));
        },
        child: Text('더보기',
            style: TextStyle(color: Colors.grey, fontSize: kContentS)));
  }

  Widget multilineText(i) {
    List strList = postList[i].content.split('\n');
    if (strList.length > 3) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(strList.sublist(0, 3).join('\n'),
              style: TextStyle(fontSize: kContentM)),
          moreText(i)
        ],
      );
    } else {
      return Text(postList[i].content, style: TextStyle(fontSize: kContentM));
    }
  }

  Widget item(i) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                alignment: Alignment.centerLeft,
                child: Text(DateFormat('yyyy-MM-dd').format(postList[i].date),
                    style: TextStyle(fontSize: kContentS + 1))),
            dropDownIcon(context, postList[i])
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
                    height: MediaQuery.of(context).size.width - 30,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current[i] = index;
                      });
                    },
                  ),
                  itemCount: postList[i].images.length,
                  itemBuilder: (context, itemidx, realidx) {
                    return postItem(i, itemidx);
                  }),
            ),
            postList[i].images.length != 1
                ? Container(
                    width: MediaQuery.of(context).size.width - 30,
                    height: MediaQuery.of(context).size.width - 30,
                    alignment: Alignment.bottomRight,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.0),
                          color: Colors.black.withOpacity(0.4)),
                      child: Text(
                          '${_current[i] + 1} / ${postList[i].images.length}',
                          style: TextStyle(
                              color: kWhite.withOpacity(0.9),
                              fontSize: kContentS,
                              fontWeight: FontWeight.bold)),
                    ),
                  )
                : Container()
          ],
        ),
        Container(
          color: kWhite,
          width: MediaQuery.of(context).size.width - 30,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
          alignment: Alignment.centerLeft,
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: listViewSetting[0] == true
                          ? BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                stops: const [
                                  0.65,
                                  0.35,
                                ],
                                colors: [
                                  kWhite,
                                  kUnderline,
                                ],
                              ),
                            )
                          : const BoxDecoration(),
                      child: Text(
                        postList[i].title,
                        style: TextStyle(
                            fontSize: kTitle, fontWeight: FontWeight.bold),
                      ),
                    ),
                    listViewSetting[1] == true ? moreText(i) : Container()
                  ],
                ),
              ),
              listViewSetting[0] == true
                  ? Container(
                      padding: const EdgeInsets.only(top: 7),
                      alignment: Alignment.centerLeft,
                      child: multilineText(i),
                    )
                  : Container()
            ],
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    postList = Singleton().postList;
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar('리스트 보기'),
      body: RefreshIndicator(
        onRefresh: () {
          setState(() {});
          return Future<void>.value();
        },
        child: _buildListView(),
      ),
    );
  }

  Widget _buildListView() {
    if (postList.isEmpty) {
      return const Center(child: Text("기록이 없습니다."));
    }
    return ListView.separated(
      separatorBuilder: (context, index) => Container(
        height: 1,
        color: kBackground,
        margin: const EdgeInsets.symmetric(vertical: 5),
      ),
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      itemCount: postList.length,
      itemBuilder: (context, i) {
        if (i == postList.length - 1) {
          return Container(
              padding: const EdgeInsets.only(bottom: 30), child: item(i));
        }
        return item(i);
      },
    );
  }
}
