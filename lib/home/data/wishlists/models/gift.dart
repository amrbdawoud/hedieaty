enum GiftState {
  available,
  pledged,
  purchased,
}

class Gift {
  final String id;  // Unique identifier for each gift
  final String name;
  final String? imageBase64;
  final String description;
  final int price;
  final String category;
  String? pledgedUserId;  // New field for the pledged user ID
  String? eventId;        // New field for the event ID
  GiftState state;        // Enum for gift state: available, pledged, purchased

  Gift({
    required this.id,
    required this.name,
    this.imageBase64,
    required this.description,
    required this.price,
    required this.category,
    this.pledgedUserId,
    this.eventId,
    this.state = GiftState.available, // Default state is "available"
  });

  // Convert Gift object to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageBase64': imageBase64,
      'description': description,
      'price': price,
      'category': category,
      'pledgedUserId': pledgedUserId,
      'eventId': eventId,
      'state': state.name, // Convert enum to string
    };
  }

  // Create a Gift object from a Map (subdocument in Wishlist)
  factory Gift.fromMap(Map<String, dynamic> data) {
    return Gift(
      id: data['id'],
      name: data['name'],
      imageBase64: data['imageBase64'],
      description: data['description'],
      price: data['price'],
      category: data['category'],
      pledgedUserId: data['pledgedUserId'],
      eventId: data['eventId'],
      state: GiftState.values.byName(data['state'] ?? 'available'), // Convert string back to enum
    );
  }

  // Helper method to copy the Gift with new values for pledgedUserId, eventId, and state
  Gift copyWith({
    String? pledgedUserId,
    String? eventId,
    GiftState? state,
  }) {
    return Gift(
      id: this.id,
      name: this.name,
      imageBase64: this.imageBase64,
      description: this.description,
      price: this.price,
      category: this.category,
      pledgedUserId: pledgedUserId ?? this.pledgedUserId,
      eventId: eventId ?? this.eventId,
      state: state ?? this.state,
    );
  }
}