import 'package:flutter/material.dart';

import '../widgets/custom_appbar.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({Key? key}) : super(key: key);

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  @override
  Widget build(BuildContext context) {
    final List<String> dates = <String>[
      '2022-07-25',
      '2022-07-10',
      '2022-07-02'
    ];
    final List<String> images = <String>['0', '1', '2'];
    final List<String> titles = <String>[
      '사진 진짜 마음에 든다 너무 이뻐',
      '구름이 양털같네',
      '어떻게 구름이 하나도 없지?'
    ];

    Widget item(i) {
      return Column(
        children: [
          Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
              alignment: Alignment.centerLeft,
              child: Text(dates[i], style: const TextStyle(fontSize: 14))),
          Container(
            alignment: Alignment.center,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.asset('./assets/images/img${images[i]}.jpg')),
          ),
          Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
              alignment: Alignment.centerLeft,
              child: Text(titles[i], style: const TextStyle(fontSize: 18))),
        ],
      );
    }

    Widget _buildListView() {
      return ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        itemCount: dates.length,
        itemBuilder: (context, i) {
          return item(i);
        },
        separatorBuilder: (context, i) => const Divider(),
      );
    }

    return Scaffold(appBar: customAppBar('리스트 보기'), body: _buildListView());
  }
}
