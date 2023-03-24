import 'dart:core';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'item.dart';

class Singleton {
  // 싱글톤 인스턴스 변수
  Singleton._privateConstructor();

  // 생성자를 호출하고 반환된 Singleton 인스턴스를 _instance 변수에 할당
  static final Singleton _instance = Singleton._privateConstructor();
  // Singleton() 호출시에 _instance 변수를 반환
  factory Singleton() {
    return _instance;
  }
  // 싱글톤 인스턴스에서 사용할 데이터
  List<Item> _postList = [];

  // 데이터 getter 메소드
  List<Item> get postList => _postList;
  final firestore = FirebaseFirestore.instance.collection('Posts');

  Future<void> getPost(uid) async {
    print("\ninvoked");
    try {
      var query = firestore
          .where('uid', isEqualTo: uid)
          .orderBy('date', descending: true);

      var snapshot = await query.get();

      _postList = snapshot.docs
          .map((doc) => Item(
              id: doc.id,
              title: doc['title'],
              date: doc['date'].toDate(),
              content: doc['content'],
              images: getImages(doc['images'])))
          .toList();
    } catch (e) {
      print("error --> $e");
    }
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

    _postList = [
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

    firestore.doc(id).set({
      'title': title,
      'content': content,
      'date': Timestamp.fromDate(date),
      'images': photoURL,
      'uid': uid
    }).catchError((error) => debugPrint(error));
  }

  void updatePost(id, title, content) {
    firestore.doc(id).update({'title': title, 'content': content});
  }

  void deletePost(id) {
    firestore.doc(id).delete();
  }

  List<String> getImages(List images) {
    List<String> imgList = [];
    for (int i = 0; i < images.length; i++) {
      imgList.add(images[i].toString());
    }
    return imgList;
  }
}
