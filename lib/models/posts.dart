import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:pidi/constants.dart';

import 'item.dart';

final firestore = FirebaseFirestore.instance.collection('Posts');

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
