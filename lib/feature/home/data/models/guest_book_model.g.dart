// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guest_book_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GuestBookModel _$GuestBookModelFromJson(Map<String, dynamic> json) =>
    _GuestBookModel(
      id: json['id'] as String,
      name: json['name'] as String,
      message: json['message'] as String,
      createdAt: const TimestampConverter().fromJson(json['createdAt']),
    );

Map<String, dynamic> _$GuestBookModelToJson(_GuestBookModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'message': instance.message,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
    };
