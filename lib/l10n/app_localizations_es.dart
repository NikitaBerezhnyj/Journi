// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String days_in_row(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'días seguidos',
      one: 'día seguido',
    );
    return '$_temp0';
  }

  @override
  String get settingsTitle => 'Configuración';

  @override
  String get languageLabel => 'Idioma';

  @override
  String get themeLabel => 'Apariencia';

  @override
  String get systemThemeLabel => 'Sistema';

  @override
  String get lightThemeLabel => 'Claro';

  @override
  String get darkThemeLabel => 'Oscuro';

  @override
  String get monday => 'Lunes';

  @override
  String get mondayShort => 'Lun';

  @override
  String get tuesday => 'Martes';

  @override
  String get tuesdayShort => 'Mar';

  @override
  String get wednesday => 'Miércoles';

  @override
  String get wednesdayShort => 'Mié';

  @override
  String get thursday => 'Jueves';

  @override
  String get thursdayShort => 'Jue';

  @override
  String get friday => 'Viernes';

  @override
  String get fridayShort => 'Vie';

  @override
  String get saturday => 'Sábado';

  @override
  String get saturdayShort => 'Sáb';

  @override
  String get sunday => 'Domingo';

  @override
  String get sundayShort => 'Dom';

  @override
  String get saving => 'Guardando...';

  @override
  String get saved => '¡Guardado!';

  @override
  String get freezeTitle => 'Congelación de racha';

  @override
  String get freezeIntroTitle => 'Protege tu racha';

  @override
  String get freezeIntroDescription => 'A veces surgen imprevistos. Tienes 2 congelaciones para proteger tu racha si fallas un día.';

  @override
  String get freezeAutoRule => 'Si no puedes escribir, la congelación se activará sola.';

  @override
  String get freezeRestoreRule => 'Escribe 3 días seguidos para recuperar una congelación.';

  @override
  String get freezeAvailable => 'Protecciones listas';

  @override
  String get freezeOutOf => 'de 2';

  @override
  String get freezeGotIt => 'Entendido';

  @override
  String get freezeRestoreNextLabel => 'La siguiente se restaura en';

  @override
  String freezeDays(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count días',
      one: '$count día',
    );
    return '$_temp0';
  }

  @override
  String get freezeExplanation => 'Si te saltas un día, una congelación protege tu progreso.';

  @override
  String freezeRestoreExplanation(num days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'días',
      one: 'día',
    );
    return 'Escribe durante $days $_temp0 seguidos para recuperar una congelación.';
  }

  @override
  String get freezeBreakWarning => 'Si te quedas sin protecciones y fallas, tu racha se reiniciará.';

  @override
  String get prompt_1 => '¿Cómo te fue hoy?';

  @override
  String get prompt_2 => '¿Qué te sacó una sonrisa?';

  @override
  String get prompt_3 => '¿Qué fue lo más duro de hoy?';

  @override
  String get prompt_4 => '¿Qué pequeño descubrimiento hiciste?';

  @override
  String get prompt_5 => '¿De qué estás agradecido hoy?';

  @override
  String get prompt_6 => '¿Qué momento vale la pena recordar?';

  @override
  String get prompt_7 => '¿En qué lo has clavado hoy?';

  @override
  String get prompt_8 => '¿Qué cambiarías de este día?';

  @override
  String get prompt_9 => 'Describe tu humor en pocas palabras.';

  @override
  String get prompt_10 => '¿Qué te pilló por sorpresa hoy?';

  @override
  String get prompt_11 => '¿De qué estás orgulloso hoy?';

  @override
  String get prompt_12 => '¿Qué te agotó la batería hoy?';

  @override
  String get prompt_13 => '¿Qué te dio un subidón de energía?';

  @override
  String get prompt_14 => '¿Qué pasito hacia adelante diste hoy?';

  @override
  String get prompt_15 => '¿Qué estuviste posponiendo hoy?';

  @override
  String get prompt_16 => '¿Qué fue lo más valioso hoy?';

  @override
  String get prompt_17 => '¿Con quién fue agradable hablar?';

  @override
  String get prompt_18 => '¿Qué emoción te acompañó más?';

  @override
  String get prompt_19 => '¿Qué hizo especial a este día?';

  @override
  String get prompt_20 => '¿Qué pensamiento te rondó la cabeza?';

  @override
  String get prompt_21 => '¿Qué detalle bonito hiciste por ti?';

  @override
  String get prompt_22 => '¿Qué estás listo para dejar ir?';

  @override
  String get prompt_23 => '¿Qué lección importante te dejó hoy?';

  @override
  String get prompt_24 => '¿Qué te ha dado un momento de paz?';

  @override
  String get prompt_25 => '¿Qué te motivó a seguir adelante?';

  @override
  String get prompt_26 => '¿Qué has descubierto sobre ti hoy?';

  @override
  String get prompt_27 => '¿Cuál fue el minuto más agradable?';

  @override
  String get prompt_28 => '¿Qué recordarás de hoy en un año?';

  @override
  String get prompt_29 => '¿Qué te causó más estrés hoy?';

  @override
  String get prompt_30 => '¿Qué lograste hacer a pesar de la pereza?';
}
