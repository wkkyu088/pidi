import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../firestore.dart';
import '../models/item.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final Stream<QuerySnapshot> posts =
      FirebaseFirestore.instance.collection('posts').snapshots();

  List<Item> postLists = [];

  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: posts,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Wrong");
          }
          //if (snapshot.connectionState == ConnectionState.waiting) {
          //  return LoadingPage();
          //}
          for (var doc in snapshot.data!.docs) {
            postLists.add(Item(
              date: doc["date"],
              title: doc["title"],
              content: doc["content"],
              images: doc["images"],
            ));
          }
          return Scaffold(
            backgroundColor: kWhite,
            body: Center(child: Text('child')),
          );
        });
  }
}
