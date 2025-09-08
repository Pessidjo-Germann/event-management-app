/// Backend Ticket model for API communication
/// 
/// This model represents the ticket structure as expected by the Django backend.
/// It's used for API serialization/deserialization.
class Ticket {
  final int id;
  final int evenement;
  final String typeBillet;
  final double prix;
  final int quantiteDisponible;
  final int quantiteVendue;
  final String? description;
  final DateTime? dateCreation;
  final DateTime? dateModification;

  Ticket({
    required this.id,
    required this.evenement,
    required this.typeBillet,
    required this.prix,
    required this.quantiteDisponible,
    required this.quantiteVendue,
    this.description,
    this.dateCreation,
    this.dateModification,
  });

  /// Calculate remaining tickets
  int get quantiteRestante => quantiteDisponible - quantiteVendue;
  
  /// Check if tickets are available
  bool get isAvailable => quantiteRestante > 0;

  /// Format price for display
  String get formatPrix => '${prix.toStringAsFixed(2)} FCFA';

  /// Create from JSON (from API response)
  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'] as int,
      evenement: json['evenement'] as int,
      typeBillet: json['type_billet'] as String,
      prix: (json['prix'] as num).toDouble(),
      quantiteDisponible: json['quantite_disponible'] as int,
      quantiteVendue: json['quantite_vendue'] as int,
      description: json['description'] as String?,
      dateCreation: json['date_creation'] != null 
          ? DateTime.parse(json['date_creation'] as String)
          : null,
      dateModification: json['date_modification'] != null
          ? DateTime.parse(json['date_modification'] as String)
          : null,
    );
  }

  /// Convert to JSON (for API requests)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'evenement': evenement,
      'type_billet': typeBillet,
      'prix': prix,
      'quantite_disponible': quantiteDisponible,
      'quantite_vendue': quantiteVendue,
      if (description != null) 'description': description,
      if (dateCreation != null) 'date_creation': dateCreation!.toIso8601String(),
      if (dateModification != null) 'date_modification': dateModification!.toIso8601String(),
    };
  }

  /// Create a copy with modified fields
  Ticket copyWith({
    int? id,
    int? evenement,
    String? typeBillet,
    double? prix,
    int? quantiteDisponible,
    int? quantiteVendue,
    String? description,
    DateTime? dateCreation,
    DateTime? dateModification,
  }) {
    return Ticket(
      id: id ?? this.id,
      evenement: evenement ?? this.evenement,
      typeBillet: typeBillet ?? this.typeBillet,
      prix: prix ?? this.prix,
      quantiteDisponible: quantiteDisponible ?? this.quantiteDisponible,
      quantiteVendue: quantiteVendue ?? this.quantiteVendue,
      description: description ?? this.description,
      dateCreation: dateCreation ?? this.dateCreation,
      dateModification: dateModification ?? this.dateModification,
    );
  }

  @override
  String toString() {
    return 'Ticket{id: $id, evenement: $evenement, typeBillet: $typeBillet, prix: $prix, quantiteDisponible: $quantiteDisponible, quantiteVendue: $quantiteVendue, description: $description}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Ticket &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          evenement == other.evenement &&
          typeBillet == other.typeBillet &&
          prix == other.prix &&
          quantiteDisponible == other.quantiteDisponible &&
          quantiteVendue == other.quantiteVendue &&
          description == other.description;

  @override
  int get hashCode =>
      id.hashCode ^
      evenement.hashCode ^
      typeBillet.hashCode ^
      prix.hashCode ^
      quantiteDisponible.hashCode ^
      quantiteVendue.hashCode ^
      description.hashCode;
}