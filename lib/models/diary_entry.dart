class DiaryEntry {
  final int? id;
  final DateTime date;
  final String text;
  final DateTime updatedAt;

  const DiaryEntry({
    this.id,
    required this.date,
    required this.text,
    required this.updatedAt,
  });

  DiaryEntry copyWith({
    int? id,
    DateTime? date,
    String? text,
    DateTime? updatedAt,
  }) => DiaryEntry(
    id: id ?? this.id,
    date: date ?? this.date,
    text: text ?? this.text,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  Map<String, dynamic> toMap() => {
    if (id != null) 'id': id,
    'date': date.toIso8601String().substring(0, 10),
    'text': text,
    'updated_at': updatedAt.toIso8601String(),
  };

  factory DiaryEntry.fromMap(Map<String, dynamic> map) => DiaryEntry(
    id: map['id'] as int,
    date: DateTime.parse(map['date'] as String),
    text: map['text'] as String,
    updatedAt: DateTime.parse(map['updated_at'] as String),
  );
}