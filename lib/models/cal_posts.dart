import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pidi/constants.dart';
import 'package:pidi/models/item.dart';
import 'package:pidi/models/posts.dart';

class CalPosts {
  List<Item> _calPosts = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Item>> getCalPosts(DateTime date) async {
    await getPostsByMonth(date);
    return _calPosts;
  }

  Future<void> getPostsByMonth(DateTime date) async {
    final startTimestamp =
        Timestamp.fromDate(DateTime(date.year, date.month, 1));
    final endTimestamp =
        Timestamp.fromDate(DateTime(date.year, date.month + 1, 1));
    final snapshot = await _firestore
        .collection('Users')
        .doc(uid)
        .collection('postList')
        .where('date', isGreaterThanOrEqualTo: startTimestamp)
        .where('date', isLessThan: endTimestamp)
        .get();

    _calPosts = snapshot.docs.map((doc) {
      final data = doc.data();
      print(data['date'].toDate());
      return Item(
          id: doc.id,
          title: data['title'],
          date: data['date'].toDate(),
          content: data['content'],
          images: getImages(doc['images']));
    }).toList();
  }
}
