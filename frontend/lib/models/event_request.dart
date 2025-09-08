/// Unified CreateEventRequest model for event creation
/// 
/// This class serves as the single source of truth for creating events,
/// resolving the conflict between multiple definitions that could exist
/// in different parts of the application.
class CreateEventRequest {
  final String titre;
  final String description;
  final DateTime date;
  final String lieu;
  final int capacite;
  final bool? estPublie;
  final String? image;  // Optional image field

  CreateEventRequest({
    required this.titre,
    required this.description,
    required this.date,
    required this.lieu,
    required this.capacite,
    this.estPublie,
    this.image,
  });

  /// Convert to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      'titre': titre,
      'description': description,
      'date_evenement': date.toIso8601String(),
      'lieu': lieu,
      'capacite': capacite,
      'est_publie': estPublie ?? false,
      if (image != null) 'image': image,
    };
  }

  /// Create instance from JSON
  factory CreateEventRequest.fromJson(Map<String, dynamic> json) {
    return CreateEventRequest(
      titre: json['titre'] as String,
      description: json['description'] as String,
      date: DateTime.parse(json['date_evenement'] as String),
      lieu: json['lieu'] as String,
      capacite: json['capacite'] as int,
      estPublie: json['est_publie'] as bool?,
      image: json['image'] as String?,
    );
  }

  /// Create a copy with modified fields
  CreateEventRequest copyWith({
    String? titre,
    String? description,
    DateTime? date,
    String? lieu,
    int? capacite,
    bool? estPublie,
    String? image,
  }) {
    return CreateEventRequest(
      titre: titre ?? this.titre,
      description: description ?? this.description,
      date: date ?? this.date,
      lieu: lieu ?? this.lieu,
      capacite: capacite ?? this.capacite,
      estPublie: estPublie ?? this.estPublie,
      image: image ?? this.image,
    );
  }

  @override
  String toString() {
    return 'CreateEventRequest{titre: $titre, description: $description, date: $date, lieu: $lieu, capacite: $capacite, estPublie: $estPublie, image: $image}';
  }
}