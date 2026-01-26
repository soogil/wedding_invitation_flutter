import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wedding/core/firebase/firestore_provider.dart';
import 'package:wedding/feature/home/data/models/guest_book_model.dart';
import 'package:wedding/feature/home/domain/entities/guest_book.dart';

part 'firestore_datasource.g.dart';

/// Firestore DataSource 인터페이스
abstract class FirestoreDataSource {
  Future<void> saveGuestBook(String weddingId, GuestBook guestBook);
  Stream<List<GuestBookModel>> watchGuestBooks(String weddingId);
  Future<List<GuestBookModel>> getGuestBooks(String weddingId);
}

/// Firestore DataSource 구현체
class FirestoreDataSourceImpl implements FirestoreDataSource {
  final FirebaseFirestore _firestore;

  FirestoreDataSourceImpl(this._firestore);

  // 컬렉션 참조
  CollectionReference<Map<String, dynamic>> get _weddingsRef =>
      _firestore.collection('weddings');

  CollectionReference<Map<String, dynamic>> _guestBooksRef(String weddingId) =>
      _weddingsRef.doc(weddingId).collection('guestBooks');

  @override
  Future<void> saveGuestBook(String weddingId, GuestBook guestBook) async {
    await _guestBooksRef(weddingId).add(guestBook.toFirestore());
  }

  @override
  Stream<List<GuestBookModel>> watchGuestBooks(String weddingId) {
    return _guestBooksRef(weddingId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => GuestBookModel.fromFirestore(doc))
            .toList());
  }

  @override
  Future<List<GuestBookModel>> getGuestBooks(String weddingId) async {
    final snapshot = await _guestBooksRef(weddingId)
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs
        .map((doc) => GuestBookModel.fromFirestore(doc))
        .toList();
  }
}

@riverpod
FirestoreDataSource firestoreDataSource(Ref ref) {
  final firestore = ref.watch(firestoreProvider);
  return FirestoreDataSourceImpl(firestore);
}
