import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:pidi/models/item.dart';
import 'package:pidi/widgets/dropdown_button.dart';

import '../constants.dart';

class DetailScreen extends StatefulWidget {
  final Item post;
  const DetailScreen({Key? key, required this.post}) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final _current = List.filled(100, 0);

  Widget imageDialog(i) {
    return Column(
      children: [
        Expanded(
          child: CarouselSlider.builder(
            options: CarouselOptions(
              initialPage: i,
              enableInfiniteScroll: false,
              disableCenter: true,
              viewportFraction: 1.0,
              onPageChanged: (index, reason) {
                setState(() {
                  _current[i] = index;
                });
              },
            ),
            itemCount: widget.post.images.length,
            itemBuilder: (context, itemIndex, realidx) {
              return CachedNetworkImage(
                imageUrl: widget.post.images[itemIndex].toString(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              );
            },
          ),
        ),
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

  Widget item(i) {
    return GestureDetector(
      onTap: () {
        showDialog(
            barrierColor: Colors.black.withOpacity(0.8),
            context: context,
            builder: (BuildContext context) {
              return imageDialog(i);
            });
      },
      child: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(right: 5.0),
        child: SizedBox(
          child: ClipRRect(
            borderRadius: kBorderRadius,
            child: CachedNetworkImage(
                imageUrl: widget.post.images[i].toString(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.fill),
          ),
        ),
      ),
    );
  }

  Widget _buildImages() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: widget.post.images.length,
      itemBuilder: (context, i) {
        return item(i);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String date = DateFormat('yyyy-MM-dd').format(widget.post.date);
    String titleValue = widget.post.title;
    String contentValue = widget.post.content;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_rounded,
              size: 22,
            ),
            color: kBlack,
            onPressed: () {
              Navigator.of(context).pop(context);
            },
            tooltip: '뒤로가기',
          ),
          title:
              Text(date, style: TextStyle(color: kBlack, fontSize: kContentM)),
          actions: [
            // IconButton(
            //   icon: const Icon(
            //     Icons.edit_rounded,
            //     size: 20,
            //   ),
            //   color: kBlack,
            //   iconSize: 20,
            //   onPressed: () {
            //     Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //             builder: (context) => ModifyScreen(post: post)));
            //   },
            //   tooltip: '수정',
            // ),
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: dropDownIcon(context, widget.post),
            )
          ],
          elevation: 0,
          backgroundColor: kWhite,
        ),
        body: Container(
            padding: const EdgeInsets.only(left: 15, top: 5, right: 15),
            child: Column(children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  decoration: BoxDecoration(
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
                  ),
                  child: Text(
                    '제목: $titleValue',
                    style: TextStyle(
                        color: kBlack,
                        fontWeight: FontWeight.bold,
                        fontSize: kTitle),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(flex: 1, child: _buildImages()),
              const SizedBox(height: 8),
              Expanded(
                flex: 2,
                child: RawScrollbar(
                  thumbColor: kUnderline,
                  radius: const Radius.circular(20),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    child: Container(
                      alignment: Alignment.topLeft,
                      decoration: const BoxDecoration(),
                      child: Text(
                        contentValue,
                        style: TextStyle(
                          height: fontFamily == fontList[2] ? 1.2 : 1.6,
                          fontSize: kContentM,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ])));
  }
}
