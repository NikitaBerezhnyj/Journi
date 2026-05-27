import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_uk.dart';

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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('uk')
  ];

  /// No description provided for @days_in_row.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{day streak} other{day streak}}'**
  String days_in_row(num count);

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @languageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageLabel;

  /// No description provided for @themeLabel.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get themeLabel;

  /// No description provided for @systemThemeLabel.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get systemThemeLabel;

  /// No description provided for @lightThemeLabel.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get lightThemeLabel;

  /// No description provided for @darkThemeLabel.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get darkThemeLabel;

  /// No description provided for @monday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get monday;

  /// No description provided for @mondayShort.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get mondayShort;

  /// No description provided for @tuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get tuesday;

  /// No description provided for @tuesdayShort.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get tuesdayShort;

  /// No description provided for @wednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get wednesday;

  /// No description provided for @wednesdayShort.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get wednesdayShort;

  /// No description provided for @thursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get thursday;

  /// No description provided for @thursdayShort.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get thursdayShort;

  /// No description provided for @friday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get friday;

  /// No description provided for @fridayShort.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get fridayShort;

  /// No description provided for @saturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get saturday;

  /// No description provided for @saturdayShort.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get saturdayShort;

  /// No description provided for @sunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get sunday;

  /// No description provided for @sundayShort.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get sundayShort;

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get saving;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Saved!'**
  String get saved;

  /// No description provided for @freezeTitle.
  ///
  /// In en, this message translates to:
  /// **'Streak Freeze'**
  String get freezeTitle;

  /// No description provided for @freezeIntroTitle.
  ///
  /// In en, this message translates to:
  /// **'Protect your streak'**
  String get freezeIntroTitle;

  /// No description provided for @freezeIntroDescription.
  ///
  /// In en, this message translates to:
  /// **'Life happens. You have 2 freezes to protect your streak if you miss a day.'**
  String get freezeIntroDescription;

  /// No description provided for @freezeAutoRule.
  ///
  /// In en, this message translates to:
  /// **'If you miss a day, a freeze will activate automatically.'**
  String get freezeAutoRule;

  /// No description provided for @freezeRestoreRule.
  ///
  /// In en, this message translates to:
  /// **'Write for 3 days in a row to get one freeze back.'**
  String get freezeRestoreRule;

  /// No description provided for @freezeAvailable.
  ///
  /// In en, this message translates to:
  /// **'Freezes left'**
  String get freezeAvailable;

  /// No description provided for @freezeOutOf.
  ///
  /// In en, this message translates to:
  /// **'out of 2'**
  String get freezeOutOf;

  /// No description provided for @freezeGotIt.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get freezeGotIt;

  /// No description provided for @freezeRestoreNextLabel.
  ///
  /// In en, this message translates to:
  /// **'Next freeze restores in'**
  String get freezeRestoreNextLabel;

  /// No description provided for @freezeDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} day} other{{count} days}}'**
  String freezeDays(num count);

  /// No description provided for @freezeExplanation.
  ///
  /// In en, this message translates to:
  /// **'If you miss a day, a freeze keeps your progress safe.'**
  String get freezeExplanation;

  /// No description provided for @freezeRestoreExplanation.
  ///
  /// In en, this message translates to:
  /// **'Write for {days} {days, plural, one{day} other{days}} in a row to get a freeze back.'**
  String freezeRestoreExplanation(num days);

  /// No description provided for @freezeBreakWarning.
  ///
  /// In en, this message translates to:
  /// **'If you run out of freezes and miss a day, your streak resets.'**
  String get freezeBreakWarning;

  /// No description provided for @prompt_1.
  ///
  /// In en, this message translates to:
  /// **'How was your day?'**
  String get prompt_1;

  /// No description provided for @prompt_2.
  ///
  /// In en, this message translates to:
  /// **'What brought a smile to your face?'**
  String get prompt_2;

  /// No description provided for @prompt_3.
  ///
  /// In en, this message translates to:
  /// **'What was the toughest part?'**
  String get prompt_3;

  /// No description provided for @prompt_4.
  ///
  /// In en, this message translates to:
  /// **'What\'s a small discovery you made?'**
  String get prompt_4;

  /// No description provided for @prompt_5.
  ///
  /// In en, this message translates to:
  /// **'What are you grateful for today?'**
  String get prompt_5;

  /// No description provided for @prompt_6.
  ///
  /// In en, this message translates to:
  /// **'What moment is worth holding onto?'**
  String get prompt_6;

  /// No description provided for @prompt_7.
  ///
  /// In en, this message translates to:
  /// **'What did you do well today?'**
  String get prompt_7;

  /// No description provided for @prompt_8.
  ///
  /// In en, this message translates to:
  /// **'What would you change about today?'**
  String get prompt_8;

  /// No description provided for @prompt_9.
  ///
  /// In en, this message translates to:
  /// **'Describe your mood in a few words.'**
  String get prompt_9;

  /// No description provided for @prompt_10.
  ///
  /// In en, this message translates to:
  /// **'What caught you off guard today?'**
  String get prompt_10;

  /// No description provided for @prompt_11.
  ///
  /// In en, this message translates to:
  /// **'What are you proud of today?'**
  String get prompt_11;

  /// No description provided for @prompt_12.
  ///
  /// In en, this message translates to:
  /// **'What drained your battery the most?'**
  String get prompt_12;

  /// No description provided for @prompt_13.
  ///
  /// In en, this message translates to:
  /// **'What gave you a burst of energy?'**
  String get prompt_13;

  /// No description provided for @prompt_14.
  ///
  /// In en, this message translates to:
  /// **'What tiny step forward did you take?'**
  String get prompt_14;

  /// No description provided for @prompt_15.
  ///
  /// In en, this message translates to:
  /// **'What did you keep putting off?'**
  String get prompt_15;

  /// No description provided for @prompt_16.
  ///
  /// In en, this message translates to:
  /// **'What was the most valuable part?'**
  String get prompt_16;

  /// No description provided for @prompt_17.
  ///
  /// In en, this message translates to:
  /// **'Who was the best person to talk to?'**
  String get prompt_17;

  /// No description provided for @prompt_18.
  ///
  /// In en, this message translates to:
  /// **'What emotion drove you the most?'**
  String get prompt_18;

  /// No description provided for @prompt_19.
  ///
  /// In en, this message translates to:
  /// **'What made today feel special?'**
  String get prompt_19;

  /// No description provided for @prompt_20.
  ///
  /// In en, this message translates to:
  /// **'What thought was on repeat?'**
  String get prompt_20;

  /// No description provided for @prompt_21.
  ///
  /// In en, this message translates to:
  /// **'What nice thing did you do for yourself?'**
  String get prompt_21;

  /// No description provided for @prompt_22.
  ///
  /// In en, this message translates to:
  /// **'What are you ready to let go of?'**
  String get prompt_22;

  /// No description provided for @prompt_23.
  ///
  /// In en, this message translates to:
  /// **'What lesson did today leave behind?'**
  String get prompt_23;

  /// No description provided for @prompt_24.
  ///
  /// In en, this message translates to:
  /// **'What brought you a moment of peace?'**
  String get prompt_24;

  /// No description provided for @prompt_25.
  ///
  /// In en, this message translates to:
  /// **'What kept you moving forward?'**
  String get prompt_25;

  /// No description provided for @prompt_26.
  ///
  /// In en, this message translates to:
  /// **'What did you realize about yourself?'**
  String get prompt_26;

  /// No description provided for @prompt_27.
  ///
  /// In en, this message translates to:
  /// **'What was the most pleasant minute?'**
  String get prompt_27;

  /// No description provided for @prompt_28.
  ///
  /// In en, this message translates to:
  /// **'What will you look back on in a year?'**
  String get prompt_28;

  /// No description provided for @prompt_29.
  ///
  /// In en, this message translates to:
  /// **'What caused you the most stress?'**
  String get prompt_29;

  /// No description provided for @prompt_30.
  ///
  /// In en, this message translates to:
  /// **'What did you do despite feeling lazy?'**
  String get prompt_30;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es', 'uk'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
    case 'uk': return AppLocalizationsUk();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
