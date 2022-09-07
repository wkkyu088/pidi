import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pidi/constants.dart';
import 'package:pidi/models/item.dart';

final _collection = FirebaseFirestore.instance.collection('Posts');

class Database {
  static List<String> getImages(List images) {
    List<String> imgList = [];
    for (int i = 0; i < images.length; i++) {
      imgList.add(images[i].toString());
    }
    return imgList;
  }

  static Stream<QuerySnapshot> readItems() {
    var query = _collection.where('uid', isEqualTo: userid);
    query = query.orderBy('date', descending: true);
    return query.snapshots();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> readMoreItems(lastDoc) {
    return _collection
        .limit(10)
        .startAfterDocument(lastDoc)
        .get()
        .then((value) {
      for (var doc in value.docs) {
        postList.add(Item(
            id: doc.id,
            title: doc['title'],
            date: doc['date'].toDate(),
            content: doc['content'],
            images: Database.getImages(doc['images'])));
      }
      return lastDoc;
    });
  }

  static Future<void> addItem(
      {required String title,
      required DateTime date,
      required String content,
      required List<String> images}) async {
    DocumentReference documentReferencer = _collection.doc();

    Map<String, dynamic> data = <String, dynamic>{
      "title": title,
      "date": date,
      "content": content,
      "images": images
    };

    await documentReferencer
        .set(data)
        .whenComplete(() => print("Note item added to the database"))
        .catchError((e) => print(e));
  }

  static Future<void> updateItem(
      {required String title,
      required DateTime date,
      required String content,
      required List<String> images}) async {
    DocumentReference documentReferencer = _collection.doc();

    Map<String, dynamic> data = <String, dynamic>{
      "title": title,
      "date": date,
      "content": content,
      "images": images
    };

    await documentReferencer
        .update(data)
        .whenComplete(() => print("Note item updated in the database"))
        .catchError((e) => print(e));
  }

  static Future<void> deleteItem({
    required String docId,
  }) async {
    DocumentReference documentReferencer = _collection.doc(docId);

    await documentReferencer
        .delete()
        .whenComplete(() => print('Note item deleted from the database'))
        .catchError((e) => print(e));
  }
}
