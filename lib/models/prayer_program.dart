class PrayerProgram {
  final int? id;
  final String theme;
  final String content;
  final String createdAt;

  PrayerProgram({
    this.id,
    required this.theme,
    required this.content,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'theme': theme,
    'content': content,
    'created_at': createdAt,
  };

  factory PrayerProgram.fromMap(Map<String, dynamic> map) => PrayerProgram(
    id: map['id'] as int?,
    theme: map['theme'] as String,
    content: map['content'] as String,
    createdAt: map['created_at'] as String,
  );

  PrayerProgram copyWith({
    int? id,
    String? theme,
    String? content,
    String? createdAt,
  }) => PrayerProgram(
    id: id ?? this.id,
    theme: theme ?? this.theme,
    content: content ?? this.content,
    createdAt: createdAt ?? this.createdAt,
  );
}
