/// Unified TicketType model for ticket management
/// 
/// This class centralizes all ticket type functionality, replacing the previous
/// TicketTypeData, TicketTypeEditData, and other scattered classes.
/// It provides a single source of truth for ticket type information.
class TicketType {
  final int? id;
  final String nom;
  final double prix;
  final int quantiteDisponible;
  final String? description;
  final bool isNew;
  
  // Properties for tracking sales
  final int quantiteVendue;
  
  TicketType({
    this.id,
    required this.nom,
    required this.prix,
    required this.quantiteDisponible,
    this.description,
    this.isNew = false,
    this.quantiteVendue = 0,
  });
  
  /// Calculated properties for business logic
  int get quantiteRestante => quantiteDisponible - quantiteVendue;
  bool get isAvailable => quantiteRestante > 0;
  String get formatPrix => '${prix.toStringAsFixed(2)} FCFA';
  
  /// Check if this ticket type has sufficient quantity for purchase
  bool canPurchase(int quantity) => quantity <= quantiteRestante;
  
  /// Get the total value for a given quantity
  double getTotalValue(int quantity) => prix * quantity;
  
  /// Serialization methods
  factory TicketType.fromJson(Map<String, dynamic> json) {
    return TicketType(
      id: json['id'] as int?,
      nom: json['nom'] as String,
      prix: (json['prix'] as num).toDouble(),
      quantiteDisponible: json['quantite_disponible'] as int,
      description: json['description'] as String?,
      isNew: json['is_new'] as bool? ?? false,
      quantiteVendue: json['quantite_vendue'] as int? ?? 0,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'nom': nom,
      'prix': prix,
      'quantite_disponible': quantiteDisponible,
      if (description != null) 'description': description,
      'is_new': isNew,
      'quantite_vendue': quantiteVendue,
    };
  }
  
  /// Convert to backend Ticket model format
  Map<String, dynamic> toTicketJson(int evenementId) {
    return {
      if (id != null) 'id': id,
      'evenement': evenementId,
      'type_billet': nom,
      'prix': prix,
      'quantite_disponible': quantiteDisponible,
      'quantite_vendue': quantiteVendue,
      if (description != null) 'description': description,
    };
  }
  
  /// Create instance from backend Ticket model
  factory TicketType.fromTicket(Map<String, dynamic> ticketJson) {
    return TicketType(
      id: ticketJson['id'] as int?,
      nom: ticketJson['type_billet'] as String,
      prix: (ticketJson['prix'] as num).toDouble(),
      quantiteDisponible: ticketJson['quantite_disponible'] as int,
      quantiteVendue: ticketJson['quantite_vendue'] as int? ?? 0,
      description: ticketJson['description'] as String?,
      isNew: false,
    );
  }
  
  /// Create a copy with modified fields
  TicketType copyWith({
    int? id,
    String? nom,
    double? prix,
    int? quantiteDisponible,
    String? description,
    bool? isNew,
    int? quantiteVendue,
  }) {
    return TicketType(
      id: id ?? this.id,
      nom: nom ?? this.nom,
      prix: prix ?? this.prix,
      quantiteDisponible: quantiteDisponible ?? this.quantiteDisponible,
      description: description ?? this.description,
      isNew: isNew ?? this.isNew,
      quantiteVendue: quantiteVendue ?? this.quantiteVendue,
    );
  }
  
  /// Mark this ticket type as sold (update quantity sold)
  TicketType withSoldQuantity(int soldQuantity) {
    return copyWith(
      quantiteVendue: quantiteVendue + soldQuantity,
    );
  }
  
  /// Mark as not new (for editing scenarios)
  TicketType asExisting() {
    return copyWith(isNew: false);
  }
  
  /// Mark as new (for creation scenarios)
  TicketType asNew() {
    return copyWith(isNew: true, id: null);
  }

  @override
  String toString() {
    return 'TicketType{id: $id, nom: $nom, prix: $prix, quantiteDisponible: $quantiteDisponible, quantiteVendue: $quantiteVendue, description: $description, isNew: $isNew}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TicketType &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          nom == other.nom &&
          prix == other.prix &&
          quantiteDisponible == other.quantiteDisponible &&
          description == other.description &&
          isNew == other.isNew &&
          quantiteVendue == other.quantiteVendue;

  @override
  int get hashCode =>
      id.hashCode ^
      nom.hashCode ^
      prix.hashCode ^
      quantiteDisponible.hashCode ^
      description.hashCode ^
      isNew.hashCode ^
      quantiteVendue.hashCode;
}