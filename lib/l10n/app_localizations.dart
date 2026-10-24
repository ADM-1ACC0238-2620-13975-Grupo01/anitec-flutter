import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('es', '419'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'AniTec'**
  String get appName;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// No description provided for @commonLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get commonLoading;

  /// No description provided for @commonShowPassword.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get commonShowPassword;

  /// No description provided for @commonHidePassword.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get commonHidePassword;

  /// No description provided for @errorNetwork.
  ///
  /// In en, this message translates to:
  /// **'Could not reach the server. Check your connection and try again.'**
  String get errorNetwork;

  /// No description provided for @errorUnauthorized.
  ///
  /// In en, this message translates to:
  /// **'Your session is not valid. Please sign in again.'**
  String get errorUnauthorized;

  /// No description provided for @errorSessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Your session expired. Please sign in again.'**
  String get errorSessionExpired;

  /// No description provided for @errorForbidden.
  ///
  /// In en, this message translates to:
  /// **'You do not have permission to do this.'**
  String get errorForbidden;

  /// No description provided for @errorNotFound.
  ///
  /// In en, this message translates to:
  /// **'The requested item was not found.'**
  String get errorNotFound;

  /// No description provided for @errorConflict.
  ///
  /// In en, this message translates to:
  /// **'This item already exists.'**
  String get errorConflict;

  /// No description provided for @errorServer.
  ///
  /// In en, this message translates to:
  /// **'The server had a problem. Please try again later.'**
  String get errorServer;

  /// No description provided for @errorUnknown.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorUnknown;

  /// No description provided for @errorFieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get errorFieldRequired;

  /// No description provided for @languageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageLabel;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageSpanish.
  ///
  /// In en, this message translates to:
  /// **'Español'**
  String get languageSpanish;

  /// No description provided for @roleRancher.
  ///
  /// In en, this message translates to:
  /// **'Rancher'**
  String get roleRancher;

  /// No description provided for @roleVeterinarian.
  ///
  /// In en, this message translates to:
  /// **'Veterinarian'**
  String get roleVeterinarian;

  /// No description provided for @authHeroChip.
  ///
  /// In en, this message translates to:
  /// **'Livestock management'**
  String get authHeroChip;

  /// No description provided for @authHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'Care for every animal, from any field.'**
  String get authHeroTitle;

  /// No description provided for @authHeroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Records, health history and activities for ranchers and veterinarians.'**
  String get authHeroSubtitle;

  /// No description provided for @authSignInTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get authSignInTitle;

  /// No description provided for @authSignInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue with your livestock records.'**
  String get authSignInSubtitle;

  /// No description provided for @authSignInAction.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get authSignInAction;

  /// No description provided for @authUsername.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get authUsername;

  /// No description provided for @authPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPassword;

  /// No description provided for @authInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid username or password.'**
  String get authInvalidCredentials;

  /// No description provided for @authVeterinarianNotSupported.
  ///
  /// In en, this message translates to:
  /// **'This app is for ranchers only. Veterinarian accounts are not supported here yet.'**
  String get authVeterinarianNotSupported;

  /// No description provided for @authUnsupportedRole.
  ///
  /// In en, this message translates to:
  /// **'This account type is not supported.'**
  String get authUnsupportedRole;

  /// No description provided for @authReadTerms.
  ///
  /// In en, this message translates to:
  /// **'Read the Terms of Service'**
  String get authReadTerms;

  /// No description provided for @termsTitle.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsTitle;

  /// No description provided for @termsIntro.
  ///
  /// In en, this message translates to:
  /// **'By creating an AniTec account you agree to the following terms. This text is a working draft prepared by the team and must be reviewed before publication.'**
  String get termsIntro;

  /// No description provided for @termsSectionUseTitle.
  ///
  /// In en, this message translates to:
  /// **'1. Purpose'**
  String get termsSectionUseTitle;

  /// No description provided for @termsSectionUseBody.
  ///
  /// In en, this message translates to:
  /// **'AniTec helps ranchers and veterinarians record animals, health events and farm activities. It does not replace professional veterinary judgment.'**
  String get termsSectionUseBody;

  /// No description provided for @termsSectionAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'2. Your account'**
  String get termsSectionAccountTitle;

  /// No description provided for @termsSectionAccountBody.
  ///
  /// In en, this message translates to:
  /// **'You are responsible for the accuracy of the information you register and for keeping your credentials private. Each account belongs to one person and one role.'**
  String get termsSectionAccountBody;

  /// No description provided for @termsSectionDataTitle.
  ///
  /// In en, this message translates to:
  /// **'3. Data and privacy'**
  String get termsSectionDataTitle;

  /// No description provided for @termsSectionDataBody.
  ///
  /// In en, this message translates to:
  /// **'We store only the data needed to provide the service: your profile, your animals, farms, health records, activities and subscription information. Veterinarians can see only the ranchers who have been linked to them. We do not sell personal data.'**
  String get termsSectionDataBody;

  /// No description provided for @termsSectionEthicsTitle.
  ///
  /// In en, this message translates to:
  /// **'4. Professional and ethical use'**
  String get termsSectionEthicsTitle;

  /// No description provided for @termsSectionEthicsBody.
  ///
  /// In en, this message translates to:
  /// **'Users must register truthful health information and respect animal welfare. Veterinarians must follow the ethical principles of their profession and the applicable ACM/IEEE software engineering code of ethics for the use of this tool.'**
  String get termsSectionEthicsBody;

  /// No description provided for @termsSectionPaymentsTitle.
  ///
  /// In en, this message translates to:
  /// **'5. Subscriptions and payments'**
  String get termsSectionPaymentsTitle;

  /// No description provided for @termsSectionPaymentsBody.
  ///
  /// In en, this message translates to:
  /// **'Paid plans are processed by Stripe. AniTec does not store card numbers. Current payments run in test mode.'**
  String get termsSectionPaymentsBody;

  /// No description provided for @termsSectionAvailabilityTitle.
  ///
  /// In en, this message translates to:
  /// **'6. Availability'**
  String get termsSectionAvailabilityTitle;

  /// No description provided for @termsSectionAvailabilityBody.
  ///
  /// In en, this message translates to:
  /// **'The service is provided as is and may be unavailable during maintenance. Data saved on the device may be synchronized later when a connection is available.'**
  String get termsSectionAvailabilityBody;

  /// No description provided for @termsSectionChangesTitle.
  ///
  /// In en, this message translates to:
  /// **'7. Changes'**
  String get termsSectionChangesTitle;

  /// No description provided for @termsSectionChangesBody.
  ///
  /// In en, this message translates to:
  /// **'These terms may change. We will notify users inside the app when they do.'**
  String get termsSectionChangesBody;

  /// No description provided for @menuMore.
  ///
  /// In en, this message translates to:
  /// **'More options'**
  String get menuMore;

  /// No description provided for @menuTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get menuTerms;

  /// No description provided for @menuSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get menuSignOut;

  /// No description provided for @homeGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hello, {name}'**
  String homeGreeting(String name);

  /// No description provided for @homeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This is how your livestock is doing.'**
  String get homeSubtitle;

  /// No description provided for @homeAllFarms.
  ///
  /// In en, this message translates to:
  /// **'All farms'**
  String get homeAllFarms;

  /// No description provided for @homeFarmFilter.
  ///
  /// In en, this message translates to:
  /// **'Farm'**
  String get homeFarmFilter;

  /// No description provided for @homeMetricAnimals.
  ///
  /// In en, this message translates to:
  /// **'Animals'**
  String get homeMetricAnimals;

  /// No description provided for @homeMetricAttention.
  ///
  /// In en, this message translates to:
  /// **'Need attention'**
  String get homeMetricAttention;

  /// No description provided for @homeMetricAttentionCaption.
  ///
  /// In en, this message translates to:
  /// **'Under observation or in treatment'**
  String get homeMetricAttentionCaption;

  /// No description provided for @homeMetricRecords.
  ///
  /// In en, this message translates to:
  /// **'Health records'**
  String get homeMetricRecords;

  /// No description provided for @homeMetricFollowUps.
  ///
  /// In en, this message translates to:
  /// **'Pending follow-ups'**
  String get homeMetricFollowUps;

  /// No description provided for @homeMetricUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming activities'**
  String get homeMetricUpcoming;

  /// No description provided for @homeUpcomingTitle.
  ///
  /// In en, this message translates to:
  /// **'Upcoming activities'**
  String get homeUpcomingTitle;

  /// No description provided for @homeUpcomingEmpty.
  ///
  /// In en, this message translates to:
  /// **'No upcoming activities.'**
  String get homeUpcomingEmpty;

  /// No description provided for @homeRecentTitle.
  ///
  /// In en, this message translates to:
  /// **'Recent health records'**
  String get homeRecentTitle;

  /// No description provided for @homeRecentEmpty.
  ///
  /// In en, this message translates to:
  /// **'No health records yet.'**
  String get homeRecentEmpty;

  /// No description provided for @homeOfflineBanner.
  ///
  /// In en, this message translates to:
  /// **'You are offline. Showing the last data loaded.'**
  String get homeOfflineBanner;

  /// No description provided for @homeRefreshFailedBanner.
  ///
  /// In en, this message translates to:
  /// **'Could not refresh. Showing the last data loaded.'**
  String get homeRefreshFailedBanner;

  /// No description provided for @homeLoadingHint.
  ///
  /// In en, this message translates to:
  /// **'Loading your livestock… the server can take up to a minute to wake up.'**
  String get homeLoadingHint;

  /// No description provided for @healthType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get healthType;

  /// No description provided for @healthDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get healthDescription;

  /// No description provided for @healthVeterinarian.
  ///
  /// In en, this message translates to:
  /// **'Veterinarian'**
  String get healthVeterinarian;

  /// No description provided for @healthDiagnosis.
  ///
  /// In en, this message translates to:
  /// **'Diagnosis'**
  String get healthDiagnosis;

  /// No description provided for @healthTreatment.
  ///
  /// In en, this message translates to:
  /// **'Treatment'**
  String get healthTreatment;

  /// No description provided for @healthPrescription.
  ///
  /// In en, this message translates to:
  /// **'Prescription'**
  String get healthPrescription;

  /// No description provided for @healthFollowUp.
  ///
  /// In en, this message translates to:
  /// **'Follow-up notes'**
  String get healthFollowUp;

  /// No description provided for @healthNextDue.
  ///
  /// In en, this message translates to:
  /// **'Next due date'**
  String get healthNextDue;

  /// No description provided for @healthTagFollowUp.
  ///
  /// In en, this message translates to:
  /// **'Follow-up'**
  String get healthTagFollowUp;

  /// No description provided for @healthTagClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get healthTagClosed;

  /// No description provided for @healthTypeIncident.
  ///
  /// In en, this message translates to:
  /// **'Incident'**
  String get healthTypeIncident;

  /// No description provided for @healthTypeVaccine.
  ///
  /// In en, this message translates to:
  /// **'Vaccine'**
  String get healthTypeVaccine;

  /// No description provided for @healthTypeTreatment.
  ///
  /// In en, this message translates to:
  /// **'Treatment'**
  String get healthTypeTreatment;

  /// No description provided for @healthTypeDiagnosis.
  ///
  /// In en, this message translates to:
  /// **'Diagnosis'**
  String get healthTypeDiagnosis;

  /// No description provided for @healthTypeCheckup.
  ///
  /// In en, this message translates to:
  /// **'Check-up'**
  String get healthTypeCheckup;

  /// No description provided for @activityType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get activityType;

  /// No description provided for @activityStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get activityStatus;

  /// No description provided for @activityOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get activityOverdue;

  /// No description provided for @activityTypeHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get activityTypeHealth;

  /// No description provided for @activityTypeVetVisit.
  ///
  /// In en, this message translates to:
  /// **'Veterinary visit'**
  String get activityTypeVetVisit;

  /// No description provided for @activityTypeProduction.
  ///
  /// In en, this message translates to:
  /// **'Production'**
  String get activityTypeProduction;

  /// No description provided for @activityTypeFinancial.
  ///
  /// In en, this message translates to:
  /// **'Financial'**
  String get activityTypeFinancial;

  /// No description provided for @activityTypeReproductive.
  ///
  /// In en, this message translates to:
  /// **'Reproductive'**
  String get activityTypeReproductive;

  /// No description provided for @activityTypeVaccination.
  ///
  /// In en, this message translates to:
  /// **'Vaccination'**
  String get activityTypeVaccination;

  /// No description provided for @activityTypeTreatmentFollowUp.
  ///
  /// In en, this message translates to:
  /// **'Treatment follow-up'**
  String get activityTypeTreatmentFollowUp;

  /// No description provided for @activityPriorityHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get activityPriorityHigh;

  /// No description provided for @activityPriorityMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get activityPriorityMedium;

  /// No description provided for @activityPriorityLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get activityPriorityLow;

  /// No description provided for @activityStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get activityStatusPending;

  /// No description provided for @activityStatusScheduled.
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get activityStatusScheduled;

  /// No description provided for @activityStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get activityStatusCompleted;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'es':
      {
        switch (locale.countryCode) {
          case '419':
            return AppLocalizationsEs419();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
