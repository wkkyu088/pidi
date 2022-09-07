import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pidi/constants.dart';

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

List<String> getImages(List images) {
  List<String> imgList = [];
  for (int i = 0; i < images.length; i++) {
    imgList.add(images[i].toString());
  }
  return imgList;
}

Stream<QuerySnapshot> readItems() {
  var query = firestore.where('uid', isEqualTo: userid).limit(3);
  query = query.orderBy('date', descending: true);
  return query.snapshots();
}

Future<QuerySnapshot<Map<String, dynamic>>> readMoreItems(lastDoc) {
  return firestore.limit(10).startAfterDocument(lastDoc).get().then((value) {
    for (var doc in value.docs) {
      postList.add(Item(
          id: doc.id,
          title: doc['title'],
          date: doc['date'].toDate(),
          content: doc['content'],
          images: getImages(doc['images'])));
    }
    return lastDoc;
  });
}
