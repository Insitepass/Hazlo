import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hazlo/Model/Note.dart';
import 'package:hazlo/Model/database_item.dart';


class DatabaseService<T extends DatabaseItem> {
  final String collection;
  final String userId;
  final Firestore _db = Firestore.instance;
  final T Function(String, Map<String, dynamic>) fromDS;
  final Map<String, dynamic>Function(T) toMap;

  DatabaseService(this.collection, {this.fromDS, this.toMap,this.userId});


  Future<T> getSingle(String id) async {
    var snap = await _db.collection(collection).document(id).get();
    if (!snap.exists) return null;
    return fromDS(snap.documentID, snap.data);
  }

  Stream<T> streamSingle(String id) {
    return _db
        .collection(collection)
        .document(id)
        .snapshots()
        .map((snap) => fromDS(snap.documentID, snap.data));
  }

  Stream<List<T>> streamList() async* {
    var user = await FirebaseAuth.instance.currentUser();

    var ref = _db.collection(collection).where('userid',isEqualTo: user.uid);

    yield*  ref.snapshots().map((list) =>
        list.documents.map((doc) => fromDS(doc.documentID, doc.data)).toList());
  }

//look here
  Future<List<T>> getQueryList({List<QueryArgs> args = const[]}) async {
    var user = await FirebaseAuth.instance.currentUser();
   // var uid = user.uid;
    CollectionReference collref = _db.collection(collection).where('userid',isEqualTo: user.uid);
    Query ref;
    for (QueryArgs arg in args) {
      if (ref = null)
        ref = collref.where(arg.key, isEqualTo: arg.value);
      else
        ref = ref.where(arg.key, isEqualTo: arg.value);
    }
    QuerySnapshot query;
    if (ref != null)
      query = await ref.getDocuments();
    else
      query = await collref.getDocuments();

    return query.documents.map((doc) => fromDS(doc.documentID, doc.data))
        .toList();
  }

  Future<Stream<List<T>>> streamQueryList({List<QueryArgs> args = const [] })async {
    var user = await FirebaseAuth.instance.currentUser();
    CollectionReference collref = _db.collection(collection).where('userid',isEqualTo: user.uid);
    Query ref;
    for (QueryArgs arg in args) {
      ref = ref.where(arg.key, isEqualTo: arg.value);
    }
    var query;
    if (ref != null)
      query = ref.snapshots();
    else
      query = collref.snapshots();
    return query.map((snap) =>
        snap.documents.map((doc) => fromDS(doc.documentID, doc.data)).toList());

    
  }

  Future<List<T>> getListFromTo(String field, DateTime from, DateTime to,
      {List<QueryArgs>
      args = const []}) async {
     var user = await FirebaseAuth.instance.currentUser();
    // look here
    // var ref = _db.collection(collection)
    //     .orderBy('created_at');
    var ref = _db.collection(collection).where('userid',isEqualTo: user.uid).orderBy(field);
    for (QueryArgs arg in args) {
      ref = ref.where(arg.key, isEqualTo: arg.value);
    }
    QuerySnapshot query = await ref.startAt([from])
        .endAt([to])
        .getDocuments();
    return query.documents.map((doc) => fromDS(doc.documentID, doc.data))
        .toList();
  }

  Future<Stream<List<T>>> streamListFromTo(String field, DateTime from, DateTime to,
      {List<QueryArgs>
      args = const[]}) async{
    var user = await FirebaseAuth.instance.currentUser();
    // var ref = _db.collection(collection)
    //     .orderBy('created_at', descending: false);
     var ref = _db.collection(collection).where('userid',isEqualTo: user.uid).orderBy(field, descending: false);
    for (QueryArgs arg in args) {
      ref = ref.where(arg.key, isEqualTo: arg.value);
    }
    var query = ref.startAfter([to])
        .endAt([from])
        .snapshots();
    return query.map((snap) =>
        snap.documents.map((doc) => fromDS(doc.documentID, doc.data)).toList());
  }

  Future<dynamic> createItem(T item, {String id}) {
    if (id != null) {
      return _db
          .collection(collection)
          .document(id)
          .setData(toMap(item));
    } else {
      return _db
          .collection(collection)
          .add(toMap(item));
    }
  }

  Future<void> updateItem(T item) {
    return _db
        .collection(collection)
        .document(item.id)
        .setData(toMap(item), merge: true);
  }

  Future<void> removeItem(String id) {
    return _db
        .collection(collection)
        .document(id)
        .delete();
  }

  updateData(String id, Map<String, String> map) {}

  // Delete user account
  Future<void> deleteAccount(String id) async {
    var user = await FirebaseAuth.instance.currentUser();
    user.delete();
    await _db
        .collection(collection)
        .where('userid',isEqualTo: user.uid).getDocuments().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.documents) {
        ds.reference.delete();
      }
    });
  }
}


class QueryArgs {
  final String key;
  final dynamic value;

  QueryArgs(this.key, this.value, {int isGreaterThanOrEqualTo});
}
DatabaseService<Note> notesDb = DatabaseService<Note>("notes",fromDS: (id,data) =>  Note.fromDS(id,data), toMap:(note) => note.toMap() );
