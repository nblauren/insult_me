class MyQuote {
  final int id;
  final int quoteId;
  final DateTime addedDate;

  MyQuote({required this.id, required this.quoteId, required this.addedDate});

  // Convert a Quote object into a Map for database operations
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'quoteId': quoteId,
      'addedDate': addedDate.toUtc().toIso8601String(), //
    };
  }

  // Create a Quote object from a Map
  factory MyQuote.fromMap(Map<String, dynamic> map) {
    return MyQuote(
      id: map['id'],
      quoteId: map['quoteId'],
      addedDate: DateTime.parse(map['addedDate'])
          .toLocal(), // Convert stored UTC to local time
    );
  }
}
