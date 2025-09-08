import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/event_request.dart';
import '../models/ticket_type.dart';
import '../providers/event_provider.dart';

/// Screen for creating new events with ticket types
/// 
/// This screen uses the unified TicketType model instead of the previous
/// TicketTypeData class, resolving the standardization issue.
class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titreController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _lieuController = TextEditingController();
  final _capaciteController = TextEditingController();
  
  DateTime? _selectedDate;
  bool _estPublie = false;
  String? _imageUrl;
  
  final List<TicketType> _ticketTypes = [];

  @override
  void dispose() {
    _titreController.dispose();
    _descriptionController.dispose();
    _lieuController.dispose();
    _capaciteController.dispose();
    super.dispose();
  }

  /// Add a new ticket type
  void _addTicketType() {
    setState(() {
      _ticketTypes.add(TicketType(
        nom: '',
        prix: 0.0,
        quantiteDisponible: 0,
        isNew: true,
      ));
    });
  }

  /// Remove ticket type at index
  void _removeTicketType(int index) {
    setState(() {
      _ticketTypes.removeAt(index);
    });
  }

  /// Update ticket type at index
  void _updateTicketType(int index, TicketType ticketType) {
    setState(() {
      _ticketTypes[index] = ticketType;
    });
  }

  /// Submit the form to create event
  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez sélectionner une date')),
      );
      return;
    }
    if (_ticketTypes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez ajouter au moins un type de billet')),
      );
      return;
    }

    final eventRequest = CreateEventRequest(
      titre: _titreController.text,
      description: _descriptionController.text,
      date: _selectedDate!,
      lieu: _lieuController.text,
      capacite: int.parse(_capaciteController.text),
      estPublie: _estPublie,
      image: _imageUrl,
    );

    final eventProvider = context.read<EventProvider>();
    final success = await eventProvider.createEvent(eventRequest, _ticketTypes);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Événement créé avec succès')),
      );
      Navigator.of(context).pop();
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(eventProvider.error ?? 'Erreur lors de la création')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Créer un événement'),
        actions: [
          Consumer<EventProvider>(
            builder: (context, provider, child) {
              return provider.isLoading
                  ? const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : IconButton(
                      icon: const Icon(Icons.save),
                      onPressed: _submitForm,
                    );
            },
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event basic information
              _buildBasicInfoSection(),
              const SizedBox(height: 24),
              
              // Ticket types section
              _buildTicketTypesSection(),
              
              const SizedBox(height: 32),
              
              // Submit button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Créer l\'événement'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Informations de base',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        
        TextFormField(
          controller: _titreController,
          decoration: const InputDecoration(
            labelText: 'Titre de l\'événement',
            border: OutlineInputBorder(),
          ),
          validator: (value) => value?.isEmpty == true ? 'Titre requis' : null,
        ),
        const SizedBox(height: 16),
        
        TextFormField(
          controller: _descriptionController,
          decoration: const InputDecoration(
            labelText: 'Description',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
          validator: (value) => value?.isEmpty == true ? 'Description requise' : null,
        ),
        const SizedBox(height: 16),
        
        TextFormField(
          controller: _lieuController,
          decoration: const InputDecoration(
            labelText: 'Lieu',
            border: OutlineInputBorder(),
          ),
          validator: (value) => value?.isEmpty == true ? 'Lieu requis' : null,
        ),
        const SizedBox(height: 16),
        
        TextFormField(
          controller: _capaciteController,
          decoration: const InputDecoration(
            labelText: 'Capacité maximale',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value?.isEmpty == true) return 'Capacité requise';
            if (int.tryParse(value!) == null) return 'Capacité invalide';
            return null;
          },
        ),
        const SizedBox(height: 16),
        
        // Date picker
        InkWell(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (date != null) {
              final time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (time != null) {
                setState(() {
                  _selectedDate = DateTime(
                    date.year,
                    date.month,
                    date.day,
                    time.hour,
                    time.minute,
                  );
                });
              }
            }
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today),
                const SizedBox(width: 16),
                Text(
                  _selectedDate != null
                      ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year} à ${_selectedDate!.hour}:${_selectedDate!.minute.toString().padLeft(2, '0')}'
                      : 'Sélectionner la date et l\'heure',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        SwitchListTile(
          title: const Text('Publier immédiatement'),
          value: _estPublie,
          onChanged: (value) => setState(() => _estPublie = value),
        ),
      ],
    );
  }

  Widget _buildTicketTypesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Types de billets',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            ElevatedButton.icon(
              onPressed: _addTicketType,
              icon: const Icon(Icons.add),
              label: const Text('Ajouter'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        if (_ticketTypes.isEmpty)
          const Center(
            child: Text('Aucun type de billet ajouté'),
          )
        else
          ...List.generate(_ticketTypes.length, (index) {
            return _buildTicketTypeCard(index);
          }),
      ],
    );
  }

  Widget _buildTicketTypeCard(int index) {
    final ticketType = _ticketTypes[index];
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Type de billet ${index + 1}'),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _removeTicketType(index),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            TextFormField(
              initialValue: ticketType.nom,
              decoration: const InputDecoration(
                labelText: 'Nom du type de billet',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _updateTicketType(index, ticketType.copyWith(nom: value));
              },
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: ticketType.prix.toString(),
                    decoration: const InputDecoration(
                      labelText: 'Prix (FCFA)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      final prix = double.tryParse(value) ?? 0.0;
                      _updateTicketType(index, ticketType.copyWith(prix: prix));
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    initialValue: ticketType.quantiteDisponible.toString(),
                    decoration: const InputDecoration(
                      labelText: 'Quantité',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      final quantite = int.tryParse(value) ?? 0;
                      _updateTicketType(index, ticketType.copyWith(quantiteDisponible: quantite));
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            TextFormField(
              initialValue: ticketType.description,
              decoration: const InputDecoration(
                labelText: 'Description (optionnelle)',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
              onChanged: (value) {
                _updateTicketType(index, ticketType.copyWith(description: value.isEmpty ? null : value));
              },
            ),
          ],
        ),
      ),
    );
  }
}