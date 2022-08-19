import 'package:flutter/material.dart';

import 'package:pidi/models/item.dart';
import 'package:pidi/screens/modify_screen.dart';

import '../constants.dart';

class DetailScreen extends StatelessWidget {
  final Item post;
  const DetailScreen({
    Key? key,
    required this.post,
  }) : super(key: key);

  Widget item(i) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(right: 5.0),
      child: SizedBox(
        child: ClipRRect(
            borderRadius: kBorderRadius,
            child: Image.asset(post.images[i].toString(), fit: BoxFit.fill)),
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
    String date = post.date;
    String titleValue = post.title;
    String contentValue = post.content;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              color: kBlack,
              onPressed: () {
                Navigator.of(context).pop(context);
              }),
          title:
              Text(date, style: TextStyle(color: kBlack, fontSize: kContentM)),
          actions: [
            IconButton(
                icon: const Icon(Icons.more_horiz_rounded),
                color: kBlack,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ModifyScreen(post: post)));
                }),
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
