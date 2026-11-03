/// Health/commercial status of an animal. `apiValue` is what the web client sends; `aliases` are the
/// English values found in the backend seed data, so both are understood.
enum AnimalStatus {
  healthy('Saludable', {'healthy', 'sano'}),
  observation('Observacion', {'observation'}),
  inTreatment('En tratamiento', {'in treatment', 'treatment', 'sick'}),
  sold('Vendido', {'sold'}),

  /// Left the active herd but its record is kept; it does not count in the dashboard.
  archived('Archivado', {'archived'}),
  /// Empty or unrecognized status from the API.
  unknown('', {});

  const AnimalStatus(this.apiValue, this._aliases);

  /// Spanish text sent to the API.
  final String apiValue;
  final Set<String> _aliases;

  /// True when the animal left the active herd.
  bool get isArchived => this == archived;

  /// True for animals that need attention (not healthy and not sold).
  bool get needsAttention => this == observation || this == inTreatment;

  /// Status for an API value, matched case-insensitively against [apiValue] and the aliases.
  static AnimalStatus fromApi(String? value) {
    final normalized = value?.trim().toLowerCase() ?? '';
    if (normalized.isEmpty) return unknown;
    for (final status in values) {
      if (status == unknown) continue;
      if (status.apiValue.toLowerCase() == normalized ||
          status._aliases.contains(normalized)) {
        return status;
      }
    }
    return unknown;
  }
}
