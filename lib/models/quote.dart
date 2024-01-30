class Quote {
  final int id;
  final String quote;
  final DateTime addedDate;
  final String addedBy;

  Quote({
    required this.id,
    required this.quote,
    required this.addedDate,
    required this.addedBy,
  });

  // Convert a Quote object into a Map for database operations
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'quote': quote,
      'addedDate':
          addedDate.toUtc().toIso8601String(), // Store as UTC in the database
      'addedBy': addedBy,
    };
  }

  // Create a Quote object from a Map
  factory Quote.fromMap(Map<String, dynamic> map) {
    return Quote(
      id: map['id'],
      quote: map['quote'],
      addedDate: DateTime.parse(map['addedDate'])
          .toLocal(), // Convert stored UTC to local time
      addedBy: map['addedBy'],
    );
  }
}
