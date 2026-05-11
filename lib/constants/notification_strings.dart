class NotificationStrings {
  static const _translations = {
    'channelName': {
      'en': 'Journal reminders',
      'uk': 'Нагадування про щоденник',
      'es': 'Recordatorios del diario',
    },
    'channelDescription': {
      'en': 'Daily reminders to write in your journal',
      'uk': 'Щоденні нагадування про запис у щоденник',
      'es': 'Recordatorios diarios para escribir en tu diario',
    },

    'reminder24hTitle': {
      'en': 'How was your day?',
      'uk': 'Як пройшов твій день?',
      'es': '¿Cómo fue tu día?',
    },
    'reminder24hBody': {
      'en': 'A good time to write a few lines',
      'uk': 'Гарний момент, щоб записати кілька рядків',
      'es': 'Un buen momento para escribir unas líneas',
    },

    'reminderEveningTitle': {
      'en': 'Today still has no entry',
      'uk': 'Сьогодні ще немає запису',
      'es': 'Hoy todavía no hay entrada',
    },
    'reminderEveningBody': {
      'en': 'Even a short note counts',
      'uk': 'Навіть коротка нотатка — це запис',
      'es': 'Incluso una nota corta cuenta',
    },

    'reminderStreakTitle': {
      'en': 'It\'s been a while',
      'uk': 'Давно не заходив',
      'es': 'Ha pasado un tiempo',
    },
    'reminderStreakBody': {
      'en': 'Start fresh today — every streak begins with one entry',
      'uk': 'Почни знову сьогодні — кожен streak починається з одного запису',
      'es': 'Empieza de nuevo hoy — toda racha comienza con una entrada',
    },
  };

  static String get(String key, String locale) {
    return _translations[key]?[locale] ?? _translations[key]!['en']!;
  }
}