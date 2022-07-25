import 'package:flutter/material.dart';
import '../widgets/custom_appbar.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({Key? key}) : super(key: key);

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppBar('갤러리 보기'),
        body: const Center(
            child: Text(
          '갤러리 스크린',
          style: TextStyle(fontSize: 40, fontFamily: 'GowunDodum'),
        )));
  }
}
