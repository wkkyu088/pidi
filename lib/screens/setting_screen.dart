import 'package:flutter/material.dart';

import '../widgets/custom_appbar.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppBar('설정'),
        body: const Text(
          'gallery screen',
          style: TextStyle(fontFamily: "GowunDodum"),
        ));
  }
}
