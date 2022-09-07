import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'item.dart';

final firestore = FirebaseFirestore.instance.collection('Posts');

void createPost(pickedImages, title, content, date, uid) async {
  List<String> photoURL = [];
  final ref = FirebaseStorage.instance.ref();

  for (int i = 0; i < pickedImages.length; i++) {
    final imgRef = ref.child('${DateTime.now().millisecondsSinceEpoch}-$i.jpg');
    File file = File(pickedImages[i]!.path);
    await imgRef.putFile(file);
    final url = await imgRef.getDownloadURL();
    photoURL.add(url);
  }

  firestore.add({
    'title': title,
    'content': content,
    'date': Timestamp.fromDate(date),
    'images': photoURL,
    'uid': uid
  }).catchError((error) => print(error));
}

// Item getPost() {}

void updatePost(id, title, content) {
  firestore.doc(id).update({'title': title, 'content': content});
}

void deletePost(id) {
  firestore.doc(id).delete();
}
