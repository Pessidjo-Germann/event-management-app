import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/event_request.dart';
import '../models/ticket_type.dart';
import '../models/ticket.dart';
import 'api_service.dart';

/// Service for handling event-related operations
/// 
/// This service provides high-level methods for event management,
/// using the unified models and ApiService for backend communication.
class EventService {
  /// Create a new event with ticket types
  static Future<Map<String, dynamic>?> createEvent(
    CreateEventRequest eventRequest,
    List<TicketType> ticketTypes, {
    String? token,
  }) async {
    try {
      // First create the event
      final eventResponse = await ApiService.createEvent(eventRequest, token: token);
      
      if (eventResponse.statusCode == 201) {
        final eventData = json.decode(eventResponse.body) as Map<String, dynamic>;
        final eventId = eventData['id'] as int;
        
        // Then create the ticket types
        final List<Map<String, dynamic>> createdTickets = [];
        
        for (final ticketType in ticketTypes) {
          final ticketResponse = await ApiService.createTicketType(
            eventId, 
            ticketType, 
            token: token,
          );
          
          if (ticketResponse.statusCode == 201) {
            final ticketData = json.decode(ticketResponse.body) as Map<String, dynamic>;
            createdTickets.add(ticketData);
          }
        }
        
        return {
          'event': eventData,
          'tickets': createdTickets,
        };
      }
      
      return null;
    } catch (e) {
      print('Error creating event: $e');
      return null;
    }
  }

  /// Get all events
  static Future<List<Map<String, dynamic>>> getEvents({String? token}) async {
    try {
      final response = await ApiService.getEvents(token: token);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List) {
          return data.cast<Map<String, dynamic>>();
        } else if (data is Map && data['results'] is List) {
          // Handle paginated response
          return (data['results'] as List).cast<Map<String, dynamic>>();
        }
      }
      
      return [];
    } catch (e) {
      print('Error getting events: $e');
      return [];
    }
  }

  /// Get event by ID with ticket types
  static Future<Map<String, dynamic>?> getEventWithTickets(int eventId, {String? token}) async {
    try {
      final eventResponse = await ApiService.getEvent(eventId, token: token);
      final ticketsResponse = await ApiService.getTickets(eventId, token: token);
      
      if (eventResponse.statusCode == 200) {
        final eventData = json.decode(eventResponse.body) as Map<String, dynamic>;
        
        List<TicketType> ticketTypes = [];
        if (ticketsResponse.statusCode == 200) {
          final ticketsData = json.decode(ticketsResponse.body);
          if (ticketsData is List) {
            ticketTypes = ticketsData
                .cast<Map<String, dynamic>>()
                .map((json) => TicketType.fromTicket(json))
                .toList();
          }
        }
        
        return {
          'event': eventData,
          'ticketTypes': ticketTypes,
        };
      }
      
      return null;
    } catch (e) {
      print('Error getting event with tickets: $e');
      return null;
    }
  }

  /// Update event with ticket types
  static Future<Map<String, dynamic>?> updateEvent(
    int eventId,
    CreateEventRequest eventRequest,
    List<TicketType> ticketTypes, {
    String? token,
  }) async {
    try {
      // Update the event
      final eventResponse = await ApiService.updateEvent(eventId, eventRequest, token: token);
      
      if (eventResponse.statusCode == 200) {
        final eventData = json.decode(eventResponse.body) as Map<String, dynamic>;
        
        // Handle ticket types updates
        final List<Map<String, dynamic>> updatedTickets = [];
        
        for (final ticketType in ticketTypes) {
          http.Response ticketResponse;
          
          if (ticketType.isNew || ticketType.id == null) {
            // Create new ticket type
            ticketResponse = await ApiService.createTicketType(
              eventId, 
              ticketType, 
              token: token,
            );
          } else {
            // Update existing ticket type
            ticketResponse = await ApiService.updateTicketType(
              eventId, 
              ticketType.id!, 
              ticketType, 
              token: token,
            );
          }
          
          if (ticketResponse.statusCode == 200 || ticketResponse.statusCode == 201) {
            final ticketData = json.decode(ticketResponse.body) as Map<String, dynamic>;
            updatedTickets.add(ticketData);
          }
        }
        
        return {
          'event': eventData,
          'tickets': updatedTickets,
        };
      }
      
      return null;
    } catch (e) {
      print('Error updating event: $e');
      return null;
    }
  }

  /// Delete event
  static Future<bool> deleteEvent(int eventId, {String? token}) async {
    try {
      final response = await ApiService.deleteEvent(eventId, token: token);
      return response.statusCode == 204;
    } catch (e) {
      print('Error deleting event: $e');
      return false;
    }
  }

  /// Convert API response to CreateEventRequest
  static CreateEventRequest eventFromJson(Map<String, dynamic> json) {
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
}