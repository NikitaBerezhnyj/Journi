import '../l10n/app_localizations.dart';

class DiaryPromptGenerator {
  static final List<String Function(AppLocalizations)> _prompts = [
    (t) => t.prompt_1,
    (t) => t.prompt_2,
    (t) => t.prompt_3,
    (t) => t.prompt_4,
    (t) => t.prompt_5,
    (t) => t.prompt_6,
    (t) => t.prompt_7,
    (t) => t.prompt_8,
    (t) => t.prompt_9,
    (t) => t.prompt_10,
    (t) => t.prompt_11,
    (t) => t.prompt_12,
    (t) => t.prompt_13,
    (t) => t.prompt_14,
    (t) => t.prompt_15,
    (t) => t.prompt_16,
    (t) => t.prompt_17,
    (t) => t.prompt_18,
    (t) => t.prompt_19,
    (t) => t.prompt_20,
    (t) => t.prompt_21,
    (t) => t.prompt_22,
    (t) => t.prompt_23,
    (t) => t.prompt_24,
    (t) => t.prompt_25,
    (t) => t.prompt_26,
    (t) => t.prompt_27,
    (t) => t.prompt_28,
    (t) => t.prompt_29,
    (t) => t.prompt_30,
  ];

  static String getRandom(AppLocalizations t) {
    final list = List.of(_prompts)..shuffle();
    return list.first(t);
  }
}