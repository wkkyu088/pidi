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
    return Scaffold(
        appBar: customAppBar('리스트 보기'), body: const Text('list screen'));
  }
}
