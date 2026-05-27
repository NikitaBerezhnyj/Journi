// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String days_in_row(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'днів поспіль',
      many: 'днів поспіль',
      few: 'дні поспіль',
      one: 'день поспіль',
    );
    return '$_temp0';
  }

  @override
  String get settingsTitle => 'Налаштування';

  @override
  String get languageLabel => 'Мова';

  @override
  String get themeLabel => 'Оформлення';

  @override
  String get systemThemeLabel => 'Системна';

  @override
  String get lightThemeLabel => 'Світла';

  @override
  String get darkThemeLabel => 'Темна';

  @override
  String get monday => 'Понеділок';

  @override
  String get mondayShort => 'Пн';

  @override
  String get tuesday => 'Вівторок';

  @override
  String get tuesdayShort => 'Вт';

  @override
  String get wednesday => 'Середа';

  @override
  String get wednesdayShort => 'Ср';

  @override
  String get thursday => 'Четвер';

  @override
  String get thursdayShort => 'Чт';

  @override
  String get friday => 'П’ятниця';

  @override
  String get fridayShort => 'Пт';

  @override
  String get saturday => 'Субота';

  @override
  String get saturdayShort => 'Сб';

  @override
  String get sunday => 'Неділя';

  @override
  String get sundayShort => 'Нд';

  @override
  String get saving => 'Зберігаю...';

  @override
  String get saved => 'Збережено!';

  @override
  String get freezeTitle => 'Заморозка серії';

  @override
  String get freezeIntroTitle => 'Захисти свою серію';

  @override
  String get freezeIntroDescription => 'Іноді бувають форс-мажори. Твої 2 заморозки підстрахують серію, якщо ти пропустиш день.';

  @override
  String get freezeAutoRule => 'Якщо не вдасться зробити запис — заморозка спрацює сама.';

  @override
  String get freezeRestoreRule => 'Пиши 3 дні поспіль, щоб повернути одну заморозку назад.';

  @override
  String get freezeAvailable => 'Захисту залишилось';

  @override
  String get freezeOutOf => 'із 2';

  @override
  String get freezeGotIt => 'Зрозуміло';

  @override
  String get freezeRestoreNextLabel => 'Відновлення захисту за';

  @override
  String freezeDays(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count днів',
      many: '$count днів',
      few: '$count дні',
      one: '$count день',
    );
    return '$_temp0';
  }

  @override
  String get freezeExplanation => 'Якщо пропустиш день — заморозка збереже твою серію.';

  @override
  String freezeRestoreExplanation(num days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'днів',
      many: 'днів',
      few: 'дні',
      one: 'день',
    );
    return 'Пиши $days $_temp0 поспіль, щоб повернути одну заморозку.';
  }

  @override
  String get freezeBreakWarning => 'Якщо захисту немає і день пропущено — серія згорить.';

  @override
  String get prompt_1 => 'Як минув твій день?';

  @override
  String get prompt_2 => 'Що сьогодні викликало посмішку?';

  @override
  String get prompt_3 => 'Що сьогодні було найважчим?';

  @override
  String get prompt_4 => 'Яке маленьке відкриття ти зробив?';

  @override
  String get prompt_5 => 'За що ти сьогодні вдячний?';

  @override
  String get prompt_6 => 'Який момент хочеться запам\'ятати?';

  @override
  String get prompt_7 => 'У чому ти сьогодні молодець?';

  @override
  String get prompt_8 => 'Що б ти змінив у цьому дні?';

  @override
  String get prompt_9 => 'Опиши свій настрій прямо зараз.';

  @override
  String get prompt_10 => 'Що сьогодні здивувало тебе?';

  @override
  String get prompt_11 => 'Чим ти сьогодні пишаєшся?';

  @override
  String get prompt_12 => 'Що сьогодні виснажило найбільше?';

  @override
  String get prompt_13 => 'Що сьогодні зарядило енергією?';

  @override
  String get prompt_14 => 'Який маленький крок уперед ти зробив?';

  @override
  String get prompt_15 => 'Що ти відкладав до останнього?';

  @override
  String get prompt_16 => 'Що було найціннішим сьогодні?';

  @override
  String get prompt_17 => 'З ким було приємно поспілкуватися?';

  @override
  String get prompt_18 => 'Яка емоція була головною сьогодні?';

  @override
  String get prompt_19 => 'Що зробило цей день особливим?';

  @override
  String get prompt_20 => 'Яка думка крутилася в голові?';

  @override
  String get prompt_21 => 'Що приємне ти зробив для себе?';

  @override
  String get prompt_22 => 'Що з сьогоднішнього дня варто відпустити?';

  @override
  String get prompt_23 => 'Який урок залишив цей день?';

  @override
  String get prompt_24 => 'Що сьогодні подарувало спокій?';

  @override
  String get prompt_25 => 'Що надихало тебе рухатися далі?';

  @override
  String get prompt_26 => 'Що ти сьогодні зрозумів про себе?';

  @override
  String get prompt_27 => 'Яка хвилина була найприємнішою?';

  @override
  String get prompt_28 => 'Про що ти згадаєш через рік?';

  @override
  String get prompt_29 => 'Через що ти сьогодні стресував?';

  @override
  String get prompt_30 => 'Що ти зробив, хоча дуже лінувався?';
}
