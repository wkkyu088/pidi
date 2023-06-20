import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:pidi/constants.dart';
import 'package:pidi/models/item.dart';

class DBConnection with ChangeNotifier {
  late final CollectionReference<Map<String, dynamic>> collections;

  late DocumentSnapshot lastDocument;
  final int _limit = 5;

  bool isFirstLoadRunning = false;
  bool hasNextPage = true;
  bool isLoadMoreRunning = false;

  List<String> getImages(List images) {
    List<String> imgList = [];
    for (int i = 0; i < images.length; i++) {
      imgList.add(images[i].toString());
    }
    return imgList;
  }

  void loadMore(ScrollController controller) async {
    debugPrint('-- loadMore');

    if (hasNextPage == true &&
        isFirstLoadRunning == false &&
        isLoadMoreRunning == false &&
        controller.position.extentAfter < 300) {
      isLoadMoreRunning = true;
      notifyListeners();

      try {
        var query = collections
            .doc(uid)
            .collection('postList')
            .orderBy('date', descending: true)
            .startAfterDocument(lastDocument)
            .limit(_limit);

        var snapshot = await query.get();

        List<Item> fetchedPosts = snapshot.docs
            .map((doc) => Item(
                id: doc.id,
                title: doc['title'],
                date: doc['date'].toDate(),
                content: doc['content'],
                images: getImages(doc['images'])))
            .toList();
        lastDocument = snapshot.docs[snapshot.size - 1];

        if (fetchedPosts.isNotEmpty) {
          postList.addAll(fetchedPosts);
          notifyListeners();
        } else {
          hasNextPage = false;
          notifyListeners();
        }
      } catch (err) {
        debugPrint('loadMore: $err');
      }

      isLoadMoreRunning = false;
      notifyListeners();
    }
  }

  void firstLoad() async {
    debugPrint('-- firstLoad $uid');

    isFirstLoadRunning = true;
    notifyListeners();

    try {
      collections = FirebaseFirestore.instance.collection("Users");

      var query = collections
          .doc(uid)
          .collection('postList')
          .orderBy('date', descending: true)
          .limit(_limit);

      var snapshot = await query.get();

      postList = snapshot.docs
          .map((doc) => Item(
              id: doc.id,
              title: doc['title'],
              date: doc['date'].toDate(),
              content: doc['content'],
              images: getImages(doc['images'])))
          .toList();
      lastDocument = snapshot.docs[snapshot.size - 1];
      notifyListeners();
      debugPrint('firstLoad :  ${postList.toList()}');
    } catch (err) {
      debugPrint('firstLoad :  $err');
    }

    isFirstLoadRunning = false;
    notifyListeners();
  }

  void createPost(pickedImages, title, content, date, uid) async {
    List<String> photoURL = [];
    final ref = FirebaseStorage.instance.ref();
    final id = DateTime.now().millisecondsSinceEpoch.toString();

    for (int i = 0; i < pickedImages.length; i++) {
      final imgRef = ref.child('$id-$i.jpg');
      File file = File(pickedImages[i]!.path);
      await imgRef.putFile(file);
      final url = await imgRef.getDownloadURL();
      photoURL.add(url);
    }

    postList = [
      Item(
        id: id,
        title: title,
        date: date,
        content: content,
        images: photoURL,
      ),
      ...postList
    ];
    postList.sort((b, a) => a.date.compareTo(b.date));

    collections.doc(uid).collection('postList').doc(id).set({
      'title': title,
      'content': content,
      'date': Timestamp.fromDate(date),
      'images': photoURL,
      'uid': uid
    }).catchError((error) => debugPrint(error));
  }

  void updatePost(id, title, content) {
    collections
        .doc(uid)
        .collection('postList')
        .doc(id)
        .update({'title': title, 'content': content});

    postList.firstWhere((element) => element.id == id).title = title;
    postList.firstWhere((element) => element.id == id).content = content;
  }

  void deletePost(id) {
    collections.doc(uid).collection('postList').doc(id).delete();
    postList.removeWhere((element) => element.id == id);

    // reload 필요
  }
}
