import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:pidi/models/item.dart';
import 'package:pidi/widgets/dropdown_button.dart';

import '../constants.dart';

class DetailScreen extends StatelessWidget {
  final Item post;
  const DetailScreen({Key? key, required this.post}) : super(key: key);

  Widget item(i) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(right: 5.0),
      child: SizedBox(
        child: ClipRRect(
          borderRadius: kBorderRadius,
          child: CachedNetworkImage(
              imageUrl: post.images[i].toString(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              fit: BoxFit.fill),
        ),
      ),
    );
  }

  Widget _buildImages() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: post.images.length,
      itemBuilder: (context, i) {
        return item(i);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String date = DateFormat('yyyy-MM-dd').format(post.date);
    String titleValue = post.title;
    String contentValue = post.content;
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
              child: dropDownIcon(context, post),
            )
          ],
          elevation: 0,
          backgroundColor: kWhite,
        ),
        body: Container(
            padding: const EdgeInsets.only(left: 20.0, top: 5.0, right: 20.0),
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
              const SizedBox(height: 20),
              Expanded(flex: 1, child: _buildImages()),
              const SizedBox(height: 10),
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
                          child: Text(contentValue,
                              style:
                                  TextStyle(height: 2, fontSize: kContentM)))),
                ),
              )
            ])));
  }
}
