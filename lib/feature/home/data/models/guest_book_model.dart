import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wedding/feature/home/domain/entities/guest_book.dart';

part 'guest_book_model.freezed.dart';
part 'guest_book_model.g.dart';

/// Firestore Timestamp <-> DateTime 변환
class TimestampConverter implements JsonConverter<DateTime, dynamic> {
  const TimestampConverter();

  @override
  DateTime fromJson(dynamic json) {
    if (json is Timestamp) {
      return json.toDate();
    }
    return DateTime.parse(json as String);
  }

  @override
  dynamic toJson(DateTime object) => Timestamp.fromDate(object);
}

@freezed
sealed class GuestBookModel with _$GuestBookModel {
  const factory GuestBookModel({
    required String id,
    required String name,
    required String message,
    @TimestampConverter() required DateTime createdAt,
  }) = _GuestBookModel;

  factory GuestBookModel.fromJson(Map<String, dynamic> json) =>
      _$GuestBookModelFromJson(json);

  factory GuestBookModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return GuestBookModel.fromJson({
      'id': doc.id,
      ...data,
    });
  }
}

/// Entity 변환 Extension
extension GuestBookModelExtension on GuestBookModel {
  GuestBook toEntity() => GuestBook(
        id: id,
        name: name,
        message: message,
        createdAt: createdAt,
      );
}

/// Entity -> Model 변환 (저장용)
extension GuestBookToModel on GuestBook {
  Map<String, dynamic> toFirestore() => {
        'name': name,
        'message': message,
        'createdAt': Timestamp.fromDate(createdAt),
      };
}
