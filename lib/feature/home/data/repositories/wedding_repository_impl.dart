import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wedding/feature/home/data/datasource/firestore_datasource.dart';
import 'package:wedding/feature/home/data/models/guest_book_model.dart';
import 'package:wedding/feature/home/domain/entities/guest_book.dart';
import 'package:wedding/feature/home/domain/repositories/wedding_repository.dart';

part 'wedding_repository_impl.g.dart';

/// Wedding Repository 구현체 (Data Layer)
class WeddingRepositoryImpl implements WeddingRepository {
  final FirestoreDataSource _dataSource;

  WeddingRepositoryImpl(this._dataSource);

  @override
  Future<void> saveGuestBook(String weddingId, GuestBook guestBook) async {
    await _dataSource.saveGuestBook(weddingId, guestBook);
  }

  @override
  Future<List<GuestBook>> getGuestBooks(String weddingId) async {
    final models = await _dataSource.getGuestBooks(weddingId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Stream<List<GuestBook>> watchGuestBooks(String weddingId) {
    return _dataSource
        .watchGuestBooks(weddingId)
        .map((models) => models.map((m) => m.toEntity()).toList());
  }
}

@riverpod
WeddingRepository weddingRepository(Ref ref) {
  final dataSource = ref.watch(firestoreDataSourceProvider);
  return WeddingRepositoryImpl(dataSource);
}
