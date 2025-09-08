#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Script pour créer un utilisateur de test
"""

import os
import sys
import django

# Configuration Django
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'backend.settings')
django.setup()

from events.models import CustomUser

def create_test_user():
    print("Création d'un utilisateur de test...")
    
    # Créer un utilisateur participant
    user, created = CustomUser.objects.get_or_create(
        username='testuser',
        defaults={
            'email': 'test@example.com',
            'role': 'participant',
            'first_name': 'Test',
            'last_name': 'User'
        }
    )
    
    if created:
        user.set_password('password123')
        user.save()
        print(f"✓ Utilisateur créé: {user.username}")
    else:
        print(f"✓ Utilisateur existant: {user.username}")
    
    print(f"👤 Nom d'utilisateur: {user.username}")
    print(f"📧 Email: {user.email}")
    print(f"🔑 Mot de passe: password123")
    print(f"👥 Rôle: {user.role}")

if __name__ == "__main__":
    create_test_user()