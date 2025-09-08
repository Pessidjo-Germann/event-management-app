#!/usr/bin/env python3
"""
Script pour créer des événements de test pour l'application
"""

import os
import sys
import django
from datetime import datetime, timedelta
from decimal import Decimal

# Configuration Django
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'backend.settings')
django.setup()

from events.models import CustomUser, Evenement, Billet

def create_test_data():
    print("Création des données de test...")
    
    # Créer un organisateur
    organizer, created = CustomUser.objects.get_or_create(
        username='organizer_test',
        defaults={
            'email': 'organizer@test.com',
            'role': 'organizer',
            'first_name': 'Jean',
            'last_name': 'Organisateur'
        }
    )
    
    if created:
        organizer.set_password('password123')
        organizer.save()
        print(f"✓ Organisateur créé: {organizer.username}")
    else:
        print(f"✓ Organisateur existant: {organizer.username}")
    
    # Événements de test
    events_data = [
        {
            'titre': 'Festival de Musique d\'Été',
            'description': 'Un festival de musique incroyable avec des artistes internationaux. Venez profiter d\'une soirée magique sous les étoiles avec de la musique live, de la nourriture délicieuse et une ambiance festive.',
            'date_evenement': datetime.now() + timedelta(days=7),
            'lieu': 'Parc Central, Paris',
            'capacite': 5000,
            'est_publie': True,
        },
        {
            'titre': 'Conférence Tech 2025',
            'description': 'La plus grande conférence technologique de l\'année. Découvrez les dernières innovations en IA, blockchain et développement web avec des experts du monde entier.',
            'date_evenement': datetime.now() + timedelta(days=14),
            'lieu': 'Centre de Congrès, Lyon',
            'capacite': 1000,
            'est_publie': True,
        },
        {
            'titre': 'Spectacle de Danse Contemporaine',
            'description': 'Une performance artistique époustouflante qui mélange danse contemporaine et arts visuels. Un spectacle unique qui vous transportera dans un monde de beauté et d\'émotion.',
            'date_evenement': datetime.now() + timedelta(days=3),
            'lieu': 'Théâtre Municipal, Marseille',
            'capacite': 500,
            'est_publie': True,
        },
        {
            'titre': 'Match de Football Amical',
            'description': 'Un match amical entre deux équipes locales. Venez soutenir votre équipe favorite dans une ambiance conviviale et sportive.',
            'date_evenement': datetime.now() + timedelta(days=1),
            'lieu': 'Stade Municipal, Toulouse',
            'capacite': 2000,
            'est_publie': True,
        },
        {
            'titre': 'Exposition d\'Art Moderne',
            'description': 'Une exposition exceptionnelle présentant les œuvres d\'artistes contemporains. Découvrez des créations uniques qui repoussent les limites de l\'art moderne.',
            'date_evenement': datetime.now() + timedelta(days=21),
            'lieu': 'Galerie d\'Art Moderne, Nice',
            'capacite': 300,
            'est_publie': True,
        },
        {
            'titre': 'Workshop Photographie',
            'description': 'Apprenez les techniques de photographie professionnelle avec des experts. Un atelier pratique pour améliorer vos compétences et développer votre style artistique.',
            'date_evenement': datetime.now() + timedelta(days=10),
            'lieu': 'Studio Photo, Bordeaux',
            'capacite': 50,
            'est_publie': True,
        }
    ]
    
    # Créer les événements
    created_events = []
    for event_data in events_data:
        event, created = Evenement.objects.get_or_create(
            titre=event_data['titre'],
            defaults={
                **event_data,
                'organisateur': organizer
            }
        )
        
        if created:
            created_events.append(event)
            print(f"✓ Événement créé: {event.titre}")
            
            # Créer des billets pour chaque événement
            tickets_data = []
            
            if 'Festival' in event.titre or 'Match' in event.titre:
                tickets_data = [
                    {'type_billet': 'Standard', 'prix': Decimal('25.00'), 'quantite_disponible': event.capacite // 2},
                    {'type_billet': 'VIP', 'prix': Decimal('50.00'), 'quantite_disponible': event.capacite // 4},
                    {'type_billet': 'Premium', 'prix': Decimal('75.00'), 'quantite_disponible': event.capacite // 4},
                ]
            elif 'Conférence' in event.titre:
                tickets_data = [
                    {'type_billet': 'Étudiant', 'prix': Decimal('15.00'), 'quantite_disponible': event.capacite // 3},
                    {'type_billet': 'Professionnel', 'prix': Decimal('45.00'), 'quantite_disponible': event.capacite // 2},
                    {'type_billet': 'Premium', 'prix': Decimal('80.00'), 'quantite_disponible': event.capacite // 6},
                ]
            elif 'Workshop' in event.titre:
                tickets_data = [
                    {'type_billet': 'Débutant', 'prix': Decimal('30.00'), 'quantite_disponible': event.capacite // 2},
                    {'type_billet': 'Avancé', 'prix': Decimal('50.00'), 'quantite_disponible': event.capacite // 2},
                ]
            else:
                tickets_data = [
                    {'type_billet': 'Standard', 'prix': Decimal('20.00'), 'quantite_disponible': event.capacite // 2},
                    {'type_billet': 'Premium', 'prix': Decimal('35.00'), 'quantite_disponible': event.capacite // 2},
                ]
            
            # Créer les billets
            for ticket_data in tickets_data:
                billet, ticket_created = Billet.objects.get_or_create(
                    evenement=event,
                    type_billet=ticket_data['type_billet'],
                    defaults=ticket_data
                )
                
                if ticket_created:
                    print(f"  ✓ Billet créé: {billet.type_billet} - {billet.prix} FCFA")
        else:
            print(f"✓ Événement existant: {event.titre}")
    
    print(f"\n🎉 Données de test créées avec succès!")
    print(f"📊 {len(created_events)} nouveaux événements ajoutés")
    print(f"👤 Organisateur: {organizer.username}")
    print(f"🔑 Mot de passe: password123")

if __name__ == "__main__":
    create_test_data()