/// Health/commercial status of an animal. `apiValue` is what the web client sends; `aliases` are the
/// English values found in the backend seed data, so both are understood.
enum AnimalStatus {
  healthy('Saludable', {'healthy', 'sano'}),
  observation('Observacion', {'observation'}),
  inTreatment('En tratamiento', {'in treatment', 'treatment', 'sick'}),
  sold('Vendido', {'sold'}),
  unknown('', {});

  const AnimalStatus(this.apiValue, this._aliases);

  final String apiValue;
  final Set<String> _aliases;

  /// True for animals that need attention (not healthy and not sold).
  bool get needsAttention => this == observation || this == inTreatment;

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
