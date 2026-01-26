/// 방명록 Entity (순수 Dart)
class GuestBook {
  final String id;
  final String name;
  final String message;
  final DateTime createdAt;

  const GuestBook({
    required this.id,
    required this.name,
    required this.message,
    required this.createdAt,
  });

  /// Firestore 저장용 Map 변환
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'message': message,
      'createdAt': createdAt,
    };
  }
}
