class NotificationStrings {
  static const _translations = {
    'channelName': {
      'en': 'Reminders from Journi',
      'uk': 'Нагадування від Journi',
      'es': 'Recordatorios de Journi',
    },
    'channelDescription': {
      'en': 'Daily reminders to write down your thoughts in Journi',
      'uk': 'Щоденні нагадування про записи у твоєму щоденнику Journi',
      'es': 'Recordatorios diarios para escribir tus pensamientos en Journi',
    },

    'reminder24hTitle': {
      'en': 'What happened today?',
      'uk': 'Що сьогодні відбулося?',
      'es': '¿Qué pasó hoy?',
    },
    'reminder24hBody': {
      'en': 'Write down a thought before it slips your mind',
      'uk': 'Запиши хоча б одну думку, поки вона не забулася',
      'es': 'Anota un pensamiento antes de que se te olvide',
    },

    'reminderEveningTitle': {
      'en': 'Day is almost over',
      'uk': 'День уже добігає кінця',
      'es': 'El día ya termina',
    },
    'reminderEveningBody': {
      'en': 'Take a moment to leave a note',
      'uk': 'Знайди час, щоб залишити запис',
      'es': 'Tómate un momento para dejar una nota',
    },

    'reminderFreezeWarningTitle': {
      'en': 'Protect your streak',
      'uk': 'Захисти свою серію',
      'es': 'Protege tu racha',
    },
    'reminderFreezeWarningBody': {
      'en': 'Write something today before your freeze runs out',
      'uk': 'Зроби запис сьогодні, поки діє заморозка',
      'es': 'Escribe algo hoy antes de que termine tu congelación',
    },

    'reminderStreakLostTitle': {
      'en': 'Time to start fresh',
      'uk': 'Час почати з чистого аркуша',
      'es': 'Hora de empezar de cero',
    },
    'reminderStreakLostBody': {
      'en': 'Your streak reset, but today is the perfect day for a new one',
      'uk': 'Серія обнулилася, але сьогодні ідеальний день щоб почати нову',
      'es': 'Tu racha se reinició, pero hoy es el día ideal para una nueva',
    },
  };

  static String get(String key, String locale) {
    return _translations[key]?[locale] ?? _translations[key]!['en']!;
  }
}
