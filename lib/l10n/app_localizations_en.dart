// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String days_in_row(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'day streak',
      one: 'day streak',
    );
    return '$_temp0';
  }

  @override
  String get settingsTitle => 'Settings';

  @override
  String get languageLabel => 'Language';

  @override
  String get themeLabel => 'Appearance';

  @override
  String get systemThemeLabel => 'System';

  @override
  String get lightThemeLabel => 'Light';

  @override
  String get darkThemeLabel => 'Dark';

  @override
  String get monday => 'Monday';

  @override
  String get mondayShort => 'Mon';

  @override
  String get tuesday => 'Tuesday';

  @override
  String get tuesdayShort => 'Tue';

  @override
  String get wednesday => 'Wednesday';

  @override
  String get wednesdayShort => 'Wed';

  @override
  String get thursday => 'Thursday';

  @override
  String get thursdayShort => 'Thu';

  @override
  String get friday => 'Friday';

  @override
  String get fridayShort => 'Fri';

  @override
  String get saturday => 'Saturday';

  @override
  String get saturdayShort => 'Sat';

  @override
  String get sunday => 'Sunday';

  @override
  String get sundayShort => 'Sun';

  @override
  String get saving => 'Saving...';

  @override
  String get saved => 'Saved!';

  @override
  String get freezeTitle => 'Streak Freeze';

  @override
  String get freezeIntroTitle => 'Protect your streak';

  @override
  String get freezeIntroDescription => 'Life happens. You have 2 freezes to protect your streak if you miss a day.';

  @override
  String get freezeAutoRule => 'If you miss a day, a freeze will activate automatically.';

  @override
  String get freezeRestoreRule => 'Write for 3 days in a row to get one freeze back.';

  @override
  String get freezeAvailable => 'Freezes left';

  @override
  String get freezeOutOf => 'out of 2';

  @override
  String get freezeGotIt => 'Got it';

  @override
  String get freezeRestoreNextLabel => 'Next freeze restores in';

  @override
  String freezeDays(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '$count day',
    );
    return '$_temp0';
  }

  @override
  String get freezeExplanation => 'If you miss a day, a freeze keeps your progress safe.';

  @override
  String freezeRestoreExplanation(num days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'days',
      one: 'day',
    );
    return 'Write for $days $_temp0 in a row to get a freeze back.';
  }

  @override
  String get freezeBreakWarning => 'If you run out of freezes and miss a day, your streak resets.';

  @override
  String get prompt_1 => 'How was your day?';

  @override
  String get prompt_2 => 'What brought a smile to your face?';

  @override
  String get prompt_3 => 'What was the toughest part?';

  @override
  String get prompt_4 => 'What\'s a small discovery you made?';

  @override
  String get prompt_5 => 'What are you grateful for today?';

  @override
  String get prompt_6 => 'What moment is worth holding onto?';

  @override
  String get prompt_7 => 'What did you do well today?';

  @override
  String get prompt_8 => 'What would you change about today?';

  @override
  String get prompt_9 => 'Describe your mood in a few words.';

  @override
  String get prompt_10 => 'What caught you off guard today?';

  @override
  String get prompt_11 => 'What are you proud of today?';

  @override
  String get prompt_12 => 'What drained your battery the most?';

  @override
  String get prompt_13 => 'What gave you a burst of energy?';

  @override
  String get prompt_14 => 'What tiny step forward did you take?';

  @override
  String get prompt_15 => 'What did you keep putting off?';

  @override
  String get prompt_16 => 'What was the most valuable part?';

  @override
  String get prompt_17 => 'Who was the best person to talk to?';

  @override
  String get prompt_18 => 'What emotion drove you the most?';

  @override
  String get prompt_19 => 'What made today feel special?';

  @override
  String get prompt_20 => 'What thought was on repeat?';

  @override
  String get prompt_21 => 'What nice thing did you do for yourself?';

  @override
  String get prompt_22 => 'What are you ready to let go of?';

  @override
  String get prompt_23 => 'What lesson did today leave behind?';

  @override
  String get prompt_24 => 'What brought you a moment of peace?';

  @override
  String get prompt_25 => 'What kept you moving forward?';

  @override
  String get prompt_26 => 'What did you realize about yourself?';

  @override
  String get prompt_27 => 'What was the most pleasant minute?';

  @override
  String get prompt_28 => 'What will you look back on in a year?';

  @override
  String get prompt_29 => 'What caused you the most stress?';

  @override
  String get prompt_30 => 'What did you do despite feeling lazy?';
}
