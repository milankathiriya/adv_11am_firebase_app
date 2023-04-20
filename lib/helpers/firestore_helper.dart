import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreHelper {
  FirestoreHelper._();
  static final FirestoreHelper firestoreHelper = FirestoreHelper._();

  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> insertRecord({required Map<String, dynamic> data}) async {
    // setup auto-increment feature

    // todo: create a new collection which holds documents for record of counter and length of other
    // documents' length in respective collections

    // todo: initialize that counter and length with value of 0

    // todo: fetch that counter's value & length's value
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await db.collection("counter").doc("students_counter").get();

    Map<String, dynamic>? counterData = documentSnapshot.data();

    int counter = counterData!['counter']; // 0
    int length = counterData!['length']; // 0

    // todo: increment that counter and length by 1 when inserting a new record
    counter++; // 1
    length++; // 1

    await db.collection("students").doc("$counter").set(data); // 1

    // todo: update that incremented counter and length to collection
    await db
        .collection("counter")
        .doc("students_counter")
        .update({"counter": counter, "length": length});
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchAllRecords() {
    return db.collection("students").snapshots();
  }

  Future<void> deleteRecord({required String id}) async {
    // todo: fetch length's value from counter collection
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await db.collection("counter").doc("students_counter").get();

    Map<String, dynamic>? counterData = documentSnapshot.data();

    int length = counterData!['length'];

    // todo: decrement that length's value by 1 after deleting a record
    await db.collection("students").doc(id).delete();

    length--;

    // todo: update that decremented length value to collection
    await db
        .collection("counter")
        .doc("students_counter")
        .update({"length": length});
  }

  Future<void> updateRecord(
      {required String id, required Map<String, dynamic> data}) async {
    await db.collection("students").doc(id).update(data);
  }
}
