/// Tolerant readers for API JSON: the backend stores free text and may omit optional fields.
extension JsonMap on Map<String, dynamic> {
  /// Required number, read as an int.
  int intOf(String key) => (this[key] as num).toInt();

  /// Optional number, or null when missing.
  int? intOrNull(String key) => (this[key] as num?)?.toInt();

  /// Text value, or [fallback] when missing.
  String stringOf(String key, {String fallback = ''}) =>
      this[key] as String? ?? fallback;

  /// Optional text value, or null when missing.
  String? stringOrNull(String key) => this[key] as String?;
}

/// Decodes a JSON array of objects.
List<Map<String, dynamic>> jsonList(Object? data) =>
    (data as List<dynamic>).cast<Map<String, dynamic>>();
