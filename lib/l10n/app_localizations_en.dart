// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'AniTec';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonLoading => 'Loading…';

  @override
  String get commonShowPassword => 'Show password';

  @override
  String get commonHidePassword => 'Hide password';

  @override
  String get errorNetwork =>
      'Could not reach the server. Check your connection and try again.';

  @override
  String get errorUnauthorized =>
      'Your session is not valid. Please sign in again.';

  @override
  String get errorSessionExpired =>
      'Your session expired. Please sign in again.';

  @override
  String get errorForbidden => 'You do not have permission to do this.';

  @override
  String get errorNotFound => 'The requested item was not found.';

  @override
  String get errorConflict => 'This item already exists.';

  @override
  String get errorServer => 'The server had a problem. Please try again later.';

  @override
  String get errorUnknown => 'Something went wrong. Please try again.';

  @override
  String get errorFieldRequired => 'This field is required';

  @override
  String get languageLabel => 'Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSpanish => 'Español';

  @override
  String get roleRancher => 'Rancher';

  @override
  String get roleVeterinarian => 'Veterinarian';

  @override
  String get authHeroChip => 'Livestock management';

  @override
  String get authHeroTitle => 'Care for every animal, from any field.';

  @override
  String get authHeroSubtitle =>
      'Records, health history and activities for ranchers and veterinarians.';

  @override
  String get authSignInTitle => 'Welcome back';

  @override
  String get authSignInSubtitle =>
      'Sign in to continue with your livestock records.';

  @override
  String get authSignInAction => 'Sign in';

  @override
  String get authUsername => 'Username';

  @override
  String get authPassword => 'Password';

  @override
  String get authInvalidCredentials => 'Invalid username or password.';

  @override
  String get authVeterinarianNotSupported =>
      'This app is for ranchers only. Veterinarian accounts are not supported here yet.';

  @override
  String get authUnsupportedRole => 'This account type is not supported.';

  @override
  String get authReadTerms => 'Read the Terms of Service';

  @override
  String get termsTitle => 'Terms of Service';

  @override
  String get termsIntro =>
      'By creating an AniTec account you agree to the following terms. This text is a working draft prepared by the team and must be reviewed before publication.';

  @override
  String get termsSectionUseTitle => '1. Purpose';

  @override
  String get termsSectionUseBody =>
      'AniTec helps ranchers and veterinarians record animals, health events and farm activities. It does not replace professional veterinary judgment.';

  @override
  String get termsSectionAccountTitle => '2. Your account';

  @override
  String get termsSectionAccountBody =>
      'You are responsible for the accuracy of the information you register and for keeping your credentials private. Each account belongs to one person and one role.';

  @override
  String get termsSectionDataTitle => '3. Data and privacy';

  @override
  String get termsSectionDataBody =>
      'We store only the data needed to provide the service: your profile, your animals, farms, health records, activities and subscription information. Veterinarians can see only the ranchers who have been linked to them. We do not sell personal data.';

  @override
  String get termsSectionEthicsTitle => '4. Professional and ethical use';

  @override
  String get termsSectionEthicsBody =>
      'Users must register truthful health information and respect animal welfare. Veterinarians must follow the ethical principles of their profession and the applicable ACM/IEEE software engineering code of ethics for the use of this tool.';

  @override
  String get termsSectionPaymentsTitle => '5. Subscriptions and payments';

  @override
  String get termsSectionPaymentsBody =>
      'Paid plans are processed by Stripe. AniTec does not store card numbers. Current payments run in test mode.';

  @override
  String get termsSectionAvailabilityTitle => '6. Availability';

  @override
  String get termsSectionAvailabilityBody =>
      'The service is provided as is and may be unavailable during maintenance. Data saved on the device may be synchronized later when a connection is available.';

  @override
  String get termsSectionChangesTitle => '7. Changes';

  @override
  String get termsSectionChangesBody =>
      'These terms may change. We will notify users inside the app when they do.';

  @override
  String get menuMore => 'More options';

  @override
  String get menuTerms => 'Terms of Service';

  @override
  String get menuSignOut => 'Sign out';

  @override
  String homeGreeting(String name) {
    return 'Hello, $name';
  }

  @override
  String get homeSubtitle => 'This is how your livestock is doing.';

  @override
  String get homeAllFarms => 'All farms';

  @override
  String get homeFarmFilter => 'Farm';

  @override
  String get homeMetricAnimals => 'Animals';

  @override
  String get homeMetricAttention => 'Need attention';

  @override
  String get homeMetricAttentionCaption => 'Under observation or in treatment';

  @override
  String get homeMetricRecords => 'Health records';

  @override
  String get homeMetricFollowUps => 'Pending follow-ups';

  @override
  String get homeMetricUpcoming => 'Upcoming activities';

  @override
  String get homeUpcomingTitle => 'Upcoming activities';

  @override
  String get homeUpcomingEmpty => 'No upcoming activities.';

  @override
  String get homeRecentTitle => 'Recent health records';

  @override
  String get homeRecentEmpty => 'No health records yet.';

  @override
  String get homeOfflineBanner =>
      'You are offline. Showing the last data loaded.';

  @override
  String get homeRefreshFailedBanner =>
      'Could not refresh. Showing the last data loaded.';

  @override
  String get homeLoadingHint =>
      'Loading your livestock… the server can take up to a minute to wake up.';

  @override
  String get healthType => 'Type';

  @override
  String get healthDescription => 'Description';

  @override
  String get healthVeterinarian => 'Veterinarian';

  @override
  String get healthDiagnosis => 'Diagnosis';

  @override
  String get healthTreatment => 'Treatment';

  @override
  String get healthPrescription => 'Prescription';

  @override
  String get healthFollowUp => 'Follow-up notes';

  @override
  String get healthNextDue => 'Next due date';

  @override
  String get healthTagFollowUp => 'Follow-up';

  @override
  String get healthTagClosed => 'Closed';

  @override
  String get healthTypeIncident => 'Incident';

  @override
  String get healthTypeVaccine => 'Vaccine';

  @override
  String get healthTypeTreatment => 'Treatment';

  @override
  String get healthTypeDiagnosis => 'Diagnosis';

  @override
  String get healthTypeCheckup => 'Check-up';

  @override
  String get activityType => 'Type';

  @override
  String get activityStatus => 'Status';

  @override
  String get activityOverdue => 'Overdue';

  @override
  String get activityTypeHealth => 'Health';

  @override
  String get activityTypeVetVisit => 'Veterinary visit';

  @override
  String get activityTypeProduction => 'Production';

  @override
  String get activityTypeFinancial => 'Financial';

  @override
  String get activityTypeReproductive => 'Reproductive';

  @override
  String get activityTypeVaccination => 'Vaccination';

  @override
  String get activityTypeTreatmentFollowUp => 'Treatment follow-up';

  @override
  String get activityPriorityHigh => 'High';

  @override
  String get activityPriorityMedium => 'Medium';

  @override
  String get activityPriorityLow => 'Low';

  @override
  String get activityStatusPending => 'Pending';

  @override
  String get activityStatusScheduled => 'Scheduled';

  @override
  String get activityStatusCompleted => 'Completed';
}
