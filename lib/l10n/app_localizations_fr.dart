// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String days_in_row(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'jours de série',
      one: 'jour de série',
    );
    return '$_temp0';
  }

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get languageLabel => 'Langue';

  @override
  String get themeLabel => 'Apparence';

  @override
  String get systemThemeLabel => 'Système';

  @override
  String get lightThemeLabel => 'Clair';

  @override
  String get darkThemeLabel => 'Sombre';

  @override
  String get monday => 'Lundi';

  @override
  String get mondayShort => 'Lun.';

  @override
  String get tuesday => 'Mardi';

  @override
  String get tuesdayShort => 'Mar.';

  @override
  String get wednesday => 'Mercredi';

  @override
  String get wednesdayShort => 'Mer.';

  @override
  String get thursday => 'Jeudi';

  @override
  String get thursdayShort => 'Jeu.';

  @override
  String get friday => 'Vendredi';

  @override
  String get fridayShort => 'Ven.';

  @override
  String get saturday => 'Samedi';

  @override
  String get saturdayShort => 'Sam.';

  @override
  String get sunday => 'Dimanche';

  @override
  String get sundayShort => 'Dim.';

  @override
  String get saving => 'Enregistrement...';

  @override
  String get saved => 'Enregistré !';

  @override
  String get freezeTitle => 'Protection de série';

  @override
  String get freezeIntroTitle => 'Protégez votre série';

  @override
  String get freezeIntroDescription => 'La vie est faite d’imprévus. Vous avez 2 protections pour préserver votre série si vous manquez une journée.';

  @override
  String get freezeAutoRule => 'Si vous manquez une journée, une protection s’active automatiquement.';

  @override
  String get freezeRestoreRule => 'Écrivez pendant 3 jours consécutifs pour récupérer une protection.';

  @override
  String get freezeAvailable => 'Protections restantes';

  @override
  String get freezeOutOf => 'sur 2';

  @override
  String get freezeGotIt => 'Compris';

  @override
  String get freezeRestoreNextLabel => 'Prochaine protection dans';

  @override
  String freezeDays(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jours',
      one: '$count jour',
    );
    return '$_temp0';
  }

  @override
  String get freezeExplanation => 'Si vous manquez une journée, une protection préserve votre progression.';

  @override
  String freezeRestoreExplanation(num days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'jours',
      one: 'jour',
    );
    return 'Écrivez pendant $days $_temp0 consécutifs pour récupérer une protection.';
  }

  @override
  String get freezeBreakWarning => 'Si vous n’avez plus de protections et que vous manquez une journée, votre série est réinitialisée.';

  @override
  String get prompt_1 => 'Comment s’est passée votre journée ?';

  @override
  String get prompt_2 => 'Qu’est-ce qui vous a fait sourire ?';

  @override
  String get prompt_3 => 'Quelle a été la partie la plus difficile ?';

  @override
  String get prompt_4 => 'Quelle petite découverte avez-vous faite ?';

  @override
  String get prompt_5 => 'Pour quoi êtes-vous reconnaissant aujourd’hui ?';

  @override
  String get prompt_6 => 'Quel moment mérite d’être gardé en mémoire ?';

  @override
  String get prompt_7 => 'Qu’avez-vous bien fait aujourd’hui ?';

  @override
  String get prompt_8 => 'Qu’aimeriez-vous changer à votre journée ?';

  @override
  String get prompt_9 => 'Décrivez votre humeur en quelques mots.';

  @override
  String get prompt_10 => 'Qu’est-ce qui vous a pris au dépourvu aujourd’hui ?';

  @override
  String get prompt_11 => 'De quoi êtes-vous fier aujourd’hui ?';

  @override
  String get prompt_12 => 'Qu’est-ce qui vous a le plus épuisé ?';

  @override
  String get prompt_13 => 'Qu’est-ce qui vous a redonné de l’énergie ?';

  @override
  String get prompt_14 => 'Quel petit pas en avant avez-vous fait ?';

  @override
  String get prompt_15 => 'Qu’avez-vous continué à remettre à plus tard ?';

  @override
  String get prompt_16 => 'Quel a été le moment le plus précieux ?';

  @override
  String get prompt_17 => 'Avec qui avez-vous le plus aimé parler ?';

  @override
  String get prompt_18 => 'Quelle émotion vous a le plus animé ?';

  @override
  String get prompt_19 => 'Qu’est-ce qui a rendu cette journée spéciale ?';

  @override
  String get prompt_20 => 'Quelle pensée revenait sans cesse ?';

  @override
  String get prompt_21 => 'Quelle petite attention vous êtes-vous accordée ?';

  @override
  String get prompt_22 => 'De quoi êtes-vous prêt à vous détacher ?';

  @override
  String get prompt_23 => 'Quelle leçon cette journée vous a-t-elle laissée ?';

  @override
  String get prompt_24 => 'Qu’est-ce qui vous a apporté un moment de paix ?';

  @override
  String get prompt_25 => 'Qu’est-ce qui vous a poussé à continuer ?';

  @override
  String get prompt_26 => 'Qu’avez-vous compris sur vous-même ?';

  @override
  String get prompt_27 => 'Quel a été le moment le plus agréable ?';

  @override
  String get prompt_28 => 'De quoi vous souviendrez-vous dans un an ?';

  @override
  String get prompt_29 => 'Qu’est-ce qui vous a causé le plus de stress ?';

  @override
  String get prompt_30 => 'Qu’avez-vous fait malgré votre manque de motivation ?';
}
