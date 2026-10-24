import '../../l10n/app_localizations.dart';
import '../network/app_error.dart';

/// Localized message for an [AppError]; never shows server text.
String appErrorMessage(AppLocalizations l10n, AppError error) =>
    switch (error) {
      NetworkError() => l10n.errorNetwork,
      UnauthorizedError() => l10n.errorUnauthorized,
      ForbiddenError() => l10n.errorForbidden,
      NotFoundError() => l10n.errorNotFound,
      ConflictError() => l10n.errorConflict,
      ValidationError() => l10n.errorUnknown,
      ServerError() => l10n.errorServer,
      UnknownError() => l10n.errorUnknown,
    };
