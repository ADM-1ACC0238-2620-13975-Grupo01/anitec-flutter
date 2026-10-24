/// Parses the day of an API date (`yyyy-MM-dd`, optionally followed by a time) or returns null.
DateTime? parseApiDay(String value) {
  final parsed = DateTime.tryParse(value);
  if (parsed == null) return null;
  return DateTime(parsed.year, parsed.month, parsed.day);
}

/// The `yyyy-MM-dd` part of an API date, for display; other text is returned untouched.
String displayApiDay(String value) =>
    parseApiDay(value) == null || value.length < 10
    ? value
    : value.substring(0, 10);
