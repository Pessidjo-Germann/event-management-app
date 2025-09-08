import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/event_request.dart';
import '../models/ticket_type.dart';
import '../models/ticket.dart';

/// Service for handling API communication with the Django backend
/// 
/// This service automatically detects the platform and uses the appropriate
/// base URL for API requests:
/// - Android emulator: http://10.0.2.2:8000/api
/// - Web: http://127.0.0.1:8000/api  
/// - iOS simulator: http://127.0.0.1:8000/api
/// - Other platforms: http://127.0.0.1:8000/api
class ApiService {
  /// Get the appropriate base URL based on the current platform
  static String get baseUrl {
    if (kIsWeb) {
      // Pour le web
      return 'http://127.0.0.1:8000/api';
    } else if (Platform.isAndroid) {
      // Pour l'émulateur Android - utilise 10.0.2.2 pour accéder au PC hôte
      return 'http://10.0.2.2:8000/api';
    } else if (Platform.isIOS) {
      // Pour le simulateur iOS
      return 'http://127.0.0.1:8000/api';
    } else {
      // Par défaut pour les autres plateformes
      return 'http://127.0.0.1:8000/api';
    }
  }

  /// Common headers for API requests
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  /// Make a POST request to the API
  static Future<http.Response> post(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl$endpoint');
    return await http.post(
      url,
      headers: headers,
      body: json.encode(data),
    );
  }

  /// Make a GET request to the API
  static Future<http.Response> get(String endpoint, {String? token}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final requestHeaders = Map<String, String>.from(headers);
    
    if (token != null) {
      requestHeaders['Authorization'] = 'Bearer $token';
    }
    
    return await http.get(url, headers: requestHeaders);
  }

  /// Make a PUT request to the API
  static Future<http.Response> put(String endpoint, Map<String, dynamic> data, {String? token}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final requestHeaders = Map<String, String>.from(headers);
    
    if (token != null) {
      requestHeaders['Authorization'] = 'Bearer $token';
    }
    
    return await http.put(
      url,
      headers: requestHeaders,
      body: json.encode(data),
    );
  }

  /// Make a DELETE request to the API
  static Future<http.Response> delete(String endpoint, {String? token}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final requestHeaders = Map<String, String>.from(headers);
    
    if (token != null) {
      requestHeaders['Authorization'] = 'Bearer $token';
    }
    
    return await http.delete(url, headers: requestHeaders);
  }

  /// User authentication - Login
  static Future<http.Response> login(String username, String password) async {
    return await post('/login/', {
      'username': username,
      'password': password,
    });
  }

  /// User authentication - Register
  static Future<http.Response> register(String username, String email, String password) async {
    return await post('/register/', {
      'username': username,
      'email': email,
      'password': password,
    });
  }

  /// Event management - Create event
  static Future<http.Response> createEvent(CreateEventRequest request, {String? token}) async {
    final requestHeaders = Map<String, String>.from(headers);
    if (token != null) {
      requestHeaders['Authorization'] = 'Bearer $token';
    }
    
    final url = Uri.parse('$baseUrl/events/');
    return await http.post(
      url,
      headers: requestHeaders,
      body: json.encode(request.toJson()),
    );
  }

  /// Event management - Get events
  static Future<http.Response> getEvents({String? token}) async {
    return await get('/events/', token: token);
  }

  /// Event management - Get event by ID
  static Future<http.Response> getEvent(int eventId, {String? token}) async {
    return await get('/events/$eventId/', token: token);
  }

  /// Event management - Update event
  static Future<http.Response> updateEvent(int eventId, CreateEventRequest request, {String? token}) async {
    return await put('/events/$eventId/', request.toJson(), token: token);
  }

  /// Event management - Delete event
  static Future<http.Response> deleteEvent(int eventId, {String? token}) async {
    return await delete('/events/$eventId/', token: token);
  }

  /// Ticket management - Get tickets for event
  static Future<http.Response> getTickets(int eventId, {String? token}) async {
    return await get('/events/$eventId/tickets/', token: token);
  }

  /// Ticket management - Create ticket type
  static Future<http.Response> createTicketType(int eventId, TicketType ticketType, {String? token}) async {
    final requestHeaders = Map<String, String>.from(headers);
    if (token != null) {
      requestHeaders['Authorization'] = 'Bearer $token';
    }
    
    final url = Uri.parse('$baseUrl/events/$eventId/tickets/');
    return await http.post(
      url,
      headers: requestHeaders,
      body: json.encode(ticketType.toTicketJson(eventId)),
    );
  }

  /// Ticket management - Update ticket type
  static Future<http.Response> updateTicketType(int eventId, int ticketId, TicketType ticketType, {String? token}) async {
    return await put('/events/$eventId/tickets/$ticketId/', ticketType.toTicketJson(eventId), token: token);
  }

  /// Ticket management - Delete ticket type
  static Future<http.Response> deleteTicketType(int eventId, int ticketId, {String? token}) async {
    return await delete('/events/$eventId/tickets/$ticketId/', token: token);
  }
}