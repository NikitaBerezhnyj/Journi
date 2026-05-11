import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';

String getWeekday(DateTime date, AppLocalizations t) {
  switch (date.weekday) {
    case 1: return t.mondayShort;
    case 2: return t.tuesdayShort;
    case 3: return t.wednesdayShort;
    case 4: return t.thursdayShort;
    case 5: return t.fridayShort;
    case 6: return t.saturdayShort;
    case 7: return t.sundayShort;
    default: return '';
  }
}

String formatMonth(DateTime date, AppLocalizations t) {
  final m = DateFormat.yMMMM(t.localeName).format(date);
  return m[0].toUpperCase() + m.substring(1);
}

String formatFullDate(DateTime date, AppLocalizations t) {
  final formatted = DateFormat('d MMM yyyy', t.localeName).format(date);
  return formatted[0].toUpperCase() + formatted.substring(1);
}
