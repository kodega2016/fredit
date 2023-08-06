// ignore_for_file: public_member_api_docs, sort_constructors_first
class Failure {
  final String message;
  Failure({required this.message});

  @override
  bool operator ==(covariant Failure other) {
    if (identical(this, other)) return true;

    return other.message == message;
  }

  @override
  int get hashCode => message.hashCode;

  @override
  String toString() => 'Failure(message: $message)';
}
