import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/models/event_request.dart';
import 'package:frontend/models/ticket_type.dart';
import 'package:frontend/models/ticket.dart';

void main() {
  group('Unified Models Tests', () {
    group('CreateEventRequest', () {
      test('should create CreateEventRequest with all fields', () {
        final date = DateTime(2024, 12, 25, 20, 30);
        final request = CreateEventRequest(
          titre: 'Concert de Noël',
          description: 'Un magnifique concert de Noël',
          date: date,
          lieu: 'Palais des Sports',
          capacite: 500,
          estPublie: true,
          image: 'https://example.com/image.jpg',
        );

        expect(request.titre, equals('Concert de Noël'));
        expect(request.description, equals('Un magnifique concert de Noël'));
        expect(request.date, equals(date));
        expect(request.lieu, equals('Palais des Sports'));
        expect(request.capacite, equals(500));
        expect(request.estPublie, equals(true));
        expect(request.image, equals('https://example.com/image.jpg'));
      });

      test('should convert to JSON correctly', () {
        final date = DateTime(2024, 12, 25, 20, 30);
        final request = CreateEventRequest(
          titre: 'Concert de Noël',
          description: 'Un magnifique concert de Noël',
          date: date,
          lieu: 'Palais des Sports',
          capacite: 500,
          estPublie: true,
          image: 'https://example.com/image.jpg',
        );

        final json = request.toJson();

        expect(json['titre'], equals('Concert de Noël'));
        expect(json['description'], equals('Un magnifique concert de Noël'));
        expect(json['date_evenement'], equals(date.toIso8601String()));
        expect(json['lieu'], equals('Palais des Sports'));
        expect(json['capacite'], equals(500));
        expect(json['est_publie'], equals(true));
        expect(json['image'], equals('https://example.com/image.jpg'));
      });

      test('should create from JSON correctly', () {
        final json = {
          'titre': 'Concert de Noël',
          'description': 'Un magnifique concert de Noël',
          'date_evenement': '2024-12-25T20:30:00.000Z',
          'lieu': 'Palais des Sports',
          'capacite': 500,
          'est_publie': true,
          'image': 'https://example.com/image.jpg',
        };

        final request = CreateEventRequest.fromJson(json);

        expect(request.titre, equals('Concert de Noël'));
        expect(request.description, equals('Un magnifique concert de Noël'));
        expect(request.lieu, equals('Palais des Sports'));
        expect(request.capacite, equals(500));
        expect(request.estPublie, equals(true));
        expect(request.image, equals('https://example.com/image.jpg'));
      });

      test('should handle optional fields correctly', () {
        final date = DateTime.now();
        final request = CreateEventRequest(
          titre: 'Test Event',
          description: 'Test Description',
          date: date,
          lieu: 'Test Location',
          capacite: 100,
        );

        expect(request.estPublie, isNull);
        expect(request.image, isNull);

        final json = request.toJson();
        expect(json['est_publie'], equals(false)); // Default value
        expect(json.containsKey('image'), isFalse);
      });
    });

    group('TicketType', () {
      test('should create TicketType with all fields', () {
        final ticketType = TicketType(
          id: 1,
          nom: 'VIP',
          prix: 50000.0,
          quantiteDisponible: 100,
          description: 'Billet VIP avec accès privilégié',
          quantiteVendue: 25,
        );

        expect(ticketType.id, equals(1));
        expect(ticketType.nom, equals('VIP'));
        expect(ticketType.prix, equals(50000.0));
        expect(ticketType.quantiteDisponible, equals(100));
        expect(ticketType.description, equals('Billet VIP avec accès privilégié'));
        expect(ticketType.quantiteVendue, equals(25));
        expect(ticketType.isNew, equals(false));
      });

      test('should calculate remaining quantity correctly', () {
        final ticketType = TicketType(
          nom: 'Standard',
          prix: 25000.0,
          quantiteDisponible: 200,
          quantiteVendue: 50,
        );

        expect(ticketType.quantiteRestante, equals(150));
        expect(ticketType.isAvailable, equals(true));
      });

      test('should format price correctly', () {
        final ticketType = TicketType(
          nom: 'Standard',
          prix: 25000.0,
          quantiteDisponible: 200,
        );

        expect(ticketType.formatPrix, equals('25000.00 FCFA'));
      });

      test('should validate purchase quantity', () {
        final ticketType = TicketType(
          nom: 'Standard',
          prix: 25000.0,
          quantiteDisponible: 200,
          quantiteVendue: 150,
        );

        expect(ticketType.canPurchase(50), equals(true));
        expect(ticketType.canPurchase(51), equals(false));
      });

      test('should calculate total value correctly', () {
        final ticketType = TicketType(
          nom: 'Standard',
          prix: 25000.0,
          quantiteDisponible: 200,
        );

        expect(ticketType.getTotalValue(3), equals(75000.0));
      });

      test('should convert to/from JSON correctly', () {
        final ticketType = TicketType(
          id: 1,
          nom: 'VIP',
          prix: 50000.0,
          quantiteDisponible: 100,
          description: 'Billet VIP',
          quantiteVendue: 25,
        );

        final json = ticketType.toJson();
        final restored = TicketType.fromJson(json);

        expect(restored.id, equals(ticketType.id));
        expect(restored.nom, equals(ticketType.nom));
        expect(restored.prix, equals(ticketType.prix));
        expect(restored.quantiteDisponible, equals(ticketType.quantiteDisponible));
        expect(restored.description, equals(ticketType.description));
        expect(restored.quantiteVendue, equals(ticketType.quantiteVendue));
      });

      test('should convert to backend Ticket format correctly', () {
        final ticketType = TicketType(
          id: 1,
          nom: 'VIP',
          prix: 50000.0,
          quantiteDisponible: 100,
          description: 'Billet VIP',
          quantiteVendue: 25,
        );

        final ticketJson = ticketType.toTicketJson(42);

        expect(ticketJson['id'], equals(1));
        expect(ticketJson['evenement'], equals(42));
        expect(ticketJson['type_billet'], equals('VIP'));
        expect(ticketJson['prix'], equals(50000.0));
        expect(ticketJson['quantite_disponible'], equals(100));
        expect(ticketJson['quantite_vendue'], equals(25));
        expect(ticketJson['description'], equals('Billet VIP'));
      });

      test('should create from backend Ticket format correctly', () {
        final ticketJson = {
          'id': 1,
          'evenement': 42,
          'type_billet': 'VIP',
          'prix': 50000.0,
          'quantite_disponible': 100,
          'quantite_vendue': 25,
          'description': 'Billet VIP',
        };

        final ticketType = TicketType.fromTicket(ticketJson);

        expect(ticketType.id, equals(1));
        expect(ticketType.nom, equals('VIP'));
        expect(ticketType.prix, equals(50000.0));
        expect(ticketType.quantiteDisponible, equals(100));
        expect(ticketType.quantiteVendue, equals(25));
        expect(ticketType.description, equals('Billet VIP'));
        expect(ticketType.isNew, equals(false));
      });

      test('should handle state changes correctly', () {
        final ticketType = TicketType(
          nom: 'Standard',
          prix: 25000.0,
          quantiteDisponible: 200,
          isNew: true,
        );

        expect(ticketType.isNew, equals(true));

        final existing = ticketType.asExisting();
        expect(existing.isNew, equals(false));

        final newAgain = existing.asNew();
        expect(newAgain.isNew, equals(true));
        expect(newAgain.id, isNull);
      });
    });

    group('Ticket (Backend Model)', () {
      test('should create Ticket with all fields', () {
        final ticket = Ticket(
          id: 1,
          evenement: 42,
          typeBillet: 'VIP',
          prix: 50000.0,
          quantiteDisponible: 100,
          quantiteVendue: 25,
          description: 'Billet VIP',
        );

        expect(ticket.id, equals(1));
        expect(ticket.evenement, equals(42));
        expect(ticket.typeBillet, equals('VIP'));
        expect(ticket.prix, equals(50000.0));
        expect(ticket.quantiteDisponible, equals(100));
        expect(ticket.quantiteVendue, equals(25));
        expect(ticket.description, equals('Billet VIP'));
      });

      test('should calculate properties correctly', () {
        final ticket = Ticket(
          id: 1,
          evenement: 42,
          typeBillet: 'Standard',
          prix: 25000.0,
          quantiteDisponible: 200,
          quantiteVendue: 50,
        );

        expect(ticket.quantiteRestante, equals(150));
        expect(ticket.isAvailable, equals(true));
        expect(ticket.formatPrix, equals('25000.00 FCFA'));
      });

      test('should convert to/from JSON correctly', () {
        final ticket = Ticket(
          id: 1,
          evenement: 42,
          typeBillet: 'VIP',
          prix: 50000.0,
          quantiteDisponible: 100,
          quantiteVendue: 25,
          description: 'Billet VIP',
        );

        final json = ticket.toJson();
        final restored = Ticket.fromJson(json);

        expect(restored.id, equals(ticket.id));
        expect(restored.evenement, equals(ticket.evenement));
        expect(restored.typeBillet, equals(ticket.typeBillet));
        expect(restored.prix, equals(ticket.prix));
        expect(restored.quantiteDisponible, equals(ticket.quantiteDisponible));
        expect(restored.quantiteVendue, equals(ticket.quantiteVendue));
        expect(restored.description, equals(ticket.description));
      });
    });
  });
}