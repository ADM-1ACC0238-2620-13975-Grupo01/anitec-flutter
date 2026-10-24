/// Tolerant readers for API JSON: the backend stores free text and may omit optional fields.
extension JsonMap on Map<String, dynamic> {
  int intOf(String key) => (this[key] as num).toInt();

  int? intOrNull(String key) => (this[key] as num?)?.toInt();

  String stringOf(String key, {String fallback = ''}) =>
      this[key] as String? ?? fallback;

  String? stringOrNull(String key) => this[key] as String?;
}

/// Decodes a JSON array of objects.
List<Map<String, dynamic>> jsonList(Object? data) =>
    (data as List<dynamic>).cast<Map<String, dynamic>>();
