import 'package:flutter/material.dart';

import '../constants.dart';
import '../widgets/custom_appbar.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({Key? key}) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final List<String> images = <String>['0', '1', '2', '3'];

  Widget item(i) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(right: 5.0),
      child: SizedBox(
        child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.asset('./assets/images/img${images[i]}.jpg',
                fit: BoxFit.fill)),
      ),
    );
  }

  Widget _buildImages() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: images.length,
      itemBuilder: (context, i) {
        return item(i);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String date = '2020-07-04';
    String titleValue = '디자인은 힘들다.';
    String contentValue = "일기를 쓸 공간이다.\n조금 허전하다.\n오늘의 일기 끝";

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              color: kBlack,
              onPressed: () {}),
          title: Text(date, style: TextStyle(color: kBlack)),
          actions: [
            IconButton(
                icon: const Icon(Icons.more_horiz_rounded),
                color: kBlack,
                onPressed: () {}),
          ],
          elevation: 0,
          backgroundColor: kWhite,
        ),
        body: Container(
            padding: const EdgeInsets.only(left: 20.0, top: 5.0, right: 20.0),
            child: Column(children: [
              Container(
                alignment: Alignment.centerLeft,
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
                child: Text('제목: $titleValue',
                    style:
                        TextStyle(color: kBlack, fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 20),
              Expanded(flex: 1, child: _buildImages()),
              Expanded(
                flex: 2,
                child: Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.only(top: 20),
                    child: Container(
                        child: Text(contentValue, style: TextStyle(height: 2)),
                        decoration: BoxDecoration())),
              )
            ])));
  }
}
