import 'package:flutter/material.dart';
import '../models/event_request.dart';
import '../models/ticket_type.dart';
import '../services/event_service.dart';

/// Provider for managing event state and operations
/// 
/// This provider uses the unified models and services to manage
/// event-related state and operations in the application.
class EventProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _events = [];
  Map<String, dynamic>? _currentEvent;
  List<TicketType> _currentTicketTypes = [];
  bool _isLoading = false;
  String? _error;
  String? _authToken;

  // Getters
  List<Map<String, dynamic>> get events => _events;
  Map<String, dynamic>? get currentEvent => _currentEvent;
  List<TicketType> get currentTicketTypes => _currentTicketTypes;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Set authentication token
  void setAuthToken(String? token) {
    _authToken = token;
    notifyListeners();
  }

  /// Clear error message
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Set error message
  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  /// Load all events
  Future<void> loadEvents() async {
    _setLoading(true);
    _setError(null);

    try {
      final events = await EventService.getEvents(token: _authToken);
      _events = events;
    } catch (e) {
      _setError('Erreur lors du chargement des événements: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Load event with tickets by ID
  Future<void> loadEventWithTickets(int eventId) async {
    _setLoading(true);
    _setError(null);

    try {
      final result = await EventService.getEventWithTickets(eventId, token: _authToken);
      if (result != null) {
        _currentEvent = result['event'] as Map<String, dynamic>;
        _currentTicketTypes = result['ticketTypes'] as List<TicketType>;
      } else {
        _setError('Événement non trouvé');
      }
    } catch (e) {
      _setError('Erreur lors du chargement de l\'événement: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Create new event with ticket types
  Future<bool> createEvent(CreateEventRequest eventRequest, List<TicketType> ticketTypes) async {
    _setLoading(true);
    _setError(null);

    try {
      final result = await EventService.createEvent(
        eventRequest, 
        ticketTypes, 
        token: _authToken,
      );
      
      if (result != null) {
        // Reload events to get the updated list
        await loadEvents();
        return true;
      } else {
        _setError('Erreur lors de la création de l\'événement');
        return false;
      }
    } catch (e) {
      _setError('Erreur lors de la création de l\'événement: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Update existing event with ticket types
  Future<bool> updateEvent(int eventId, CreateEventRequest eventRequest, List<TicketType> ticketTypes) async {
    _setLoading(true);
    _setError(null);

    try {
      final result = await EventService.updateEvent(
        eventId, 
        eventRequest, 
        ticketTypes, 
        token: _authToken,
      );
      
      if (result != null) {
        // Update current event if it's the one being edited
        if (_currentEvent != null && _currentEvent!['id'] == eventId) {
          _currentEvent = result['event'] as Map<String, dynamic>;
        }
        
        // Reload events to get the updated list
        await loadEvents();
        return true;
      } else {
        _setError('Erreur lors de la mise à jour de l\'événement');
        return false;
      }
    } catch (e) {
      _setError('Erreur lors de la mise à jour de l\'événement: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Delete event
  Future<bool> deleteEvent(int eventId) async {
    _setLoading(true);
    _setError(null);

    try {
      final success = await EventService.deleteEvent(eventId, token: _authToken);
      
      if (success) {
        // Remove from local list
        _events.removeWhere((event) => event['id'] == eventId);
        
        // Clear current event if it's the one being deleted
        if (_currentEvent != null && _currentEvent!['id'] == eventId) {
          _currentEvent = null;
          _currentTicketTypes.clear();
        }
        
        notifyListeners();
        return true;
      } else {
        _setError('Erreur lors de la suppression de l\'événement');
        return false;
      }
    } catch (e) {
      _setError('Erreur lors de la suppression de l\'événement: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Add ticket type to current list (for editing)
  void addTicketType(TicketType ticketType) {
    _currentTicketTypes.add(ticketType);
    notifyListeners();
  }

  /// Update ticket type in current list
  void updateTicketType(int index, TicketType ticketType) {
    if (index >= 0 && index < _currentTicketTypes.length) {
      _currentTicketTypes[index] = ticketType;
      notifyListeners();
    }
  }

  /// Remove ticket type from current list
  void removeTicketType(int index) {
    if (index >= 0 && index < _currentTicketTypes.length) {
      _currentTicketTypes.removeAt(index);
      notifyListeners();
    }
  }

  /// Clear current event and ticket types
  void clearCurrentEvent() {
    _currentEvent = null;
    _currentTicketTypes.clear();
    notifyListeners();
  }

  /// Reset all state
  void reset() {
    _events.clear();
    _currentEvent = null;
    _currentTicketTypes.clear();
    _isLoading = false;
    _error = null;
    _authToken = null;
    notifyListeners();
  }
}