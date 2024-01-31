class QuoteRating {
  final int id;
  final int quoteId;
  final DateTime addedDate;
  final int rating;
  final String addedBy;

  QuoteRating(
      {required this.id,
      required this.quoteId,
      required this.addedDate,
      required this.rating,
      required this.addedBy});

  // Convert a Quote object into a Map for database operations
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'quoteId': quoteId,
      'addedDate': addedDate.toUtc().toIso8601String(),
      'rating': rating,
      'addedBy': addedBy,
    };
  }

  // Create a Quote object from a Map
  factory QuoteRating.fromMap(Map<String, dynamic> map) {
    return QuoteRating(
      id: map['id'],
      quoteId: map['quoteId'],
      addedDate: DateTime.parse(map['addedDate']).toLocal(),
      rating: map['rating'],
      addedBy: map['addedBy'], // Convert stored UTC to local time
    );
  }
}
