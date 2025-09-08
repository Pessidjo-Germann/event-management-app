# 🎉 Event Management App

Une application complète de gestion d'événements avec un backend Django REST API et un frontend Flutter.

## 📋 Table des Matières

- [🌟 Fonctionnalités](#-fonctionnalités)
- [🏗️ Architecture](#️-architecture) 
- [🚀 Installation](#-installation)
- [📱 Captures d'écran](#-captures-décran)
- [🔧 Configuration](#-configuration)
- [📖 API Documentation](#-api-documentation)
- [🧪 Tests](#-tests)
- [🛣️ Roadmap](#️-roadmap)
- [🤝 Contribution](#-contribution)

## 🌟 Fonctionnalités

### ✅ **Authentification & Utilisateurs**
- 🔐 Connexion/Inscription avec JWT
- 👤 Gestion des profils utilisateur  
- 🔄 Rafraîchissement automatique des tokens
- 👨‍💼 Rôles : Participant, Organisateur, Artiste, Admin

### ✅ **Gestion des Événements**
- 📋 Liste d'événements avec pagination
- 🔍 Recherche et filtres avancés
- 📝 Détails complets des événements
- ⭐ Système de favoris
- 🖼️ Upload d'images multiples

### ✅ **Système de Réservation**
- 🎫 Types de billets multiples
- 🛒 Processus de réservation simple
- 📊 Gestion des stocks en temps réel
- 📧 Confirmations automatiques

### ✅ **Dashboard Organisateur**
- 📈 Statistiques des événements
- 👥 Gestion des participants
- 💰 Suivi des revenus
- ✏️ Création/édition d'événements

### 💳 **Paiement Simulé**
- 💸 Système de paiement de test
- 📄 Génération de reçus
- ⏱️ Simulation de délais de traitement
- 🔔 Notifications de statut

## 🏗️ Architecture

```
┌─────────────────┐    ┌─────────────────┐
│  Flutter Web    │    │  Flutter Mobile │
│     Frontend    │    │    (Android)    │
└─────────┬───────┘    └─────────┬───────┘
          │                      │
          └──────────┬───────────┘
                     │ REST API
                     ▼
          ┌─────────────────┐
          │  Django REST    │
          │    Backend      │
          └─────────┬───────┘
                    │
                    ▼
          ┌─────────────────┐
          │    SQLite       │
          │   Database      │
          └─────────────────┘
```

### **Stack Technologique**

**Backend:**
- 🐍 Django 4.2 + Django REST Framework
- 🔑 JWT Authentication (SimpleJWT)
- 🗃️ SQLite (dev) / PostgreSQL (prod)
- 🌐 CORS Headers pour Flutter Web

**Frontend:**
- 🦋 Flutter 3.24+ avec Dart 3.5+
- 🏪 Provider pour la gestion d'état
- 🌐 HTTP Client pour les appels API
- 💾 SharedPreferences pour la persistance

## 🚀 Installation

### **Prérequis**
- Python 3.8+
- Flutter 3.24+
- Git

### **1. Clonage du Projet**
```bash
git clone https://github.com/Pessidjo-Germann/event-management-app.git
cd event-management-app
```

### **2. Configuration Backend Django**

```bash
# Créer un environnement virtuel
python -m venv venv_backend
source venv_backend/bin/activate  # Linux/Mac
# ou
venv_backend\Scripts\activate     # Windows

# Installer les dépendances
pip install -r requirements.txt

# Migrations de base de données
python manage.py makemigrations
python manage.py migrate

# Créer un superutilisateur
python manage.py createsuperuser

# Charger les données de test
python create_test_user.py
python create_test_events.py

# Lancer le serveur
python manage.py runserver
```

Le backend sera accessible sur `http://localhost:8000`

### **3. Configuration Frontend Flutter**

```bash
cd frontend

# Installer les dépendances
flutter pub get

# Générer les modèles JSON
flutter packages pub run build_runner build

# Pour émulateur Android
flutter run

# Pour développement web
flutter run -d chrome --web-port 3001
```

L'app sera accessible sur `http://localhost:3001`

### **4. Configuration pour Émulateur Android**

Si vous utilisez l'émulateur Android, modifiez l'URL de base dans `frontend/lib/services/api_service.dart` :

```dart
// Remplacer cette ligne :
static const String baseUrl = 'http://127.0.0.1:8000/api';

// Par :
static const String baseUrl = 'http://10.0.2.2:8000/api';
```

## 🔧 Configuration

### **Variables d'Environnement**

Créez un fichier `.env` à la racine du projet :

```env
DEBUG=True
SECRET_KEY=your-secret-key-here
DATABASE_URL=sqlite:///db.sqlite3
ALLOWED_HOSTS=localhost,127.0.0.1,10.0.2.2
CORS_ALLOWED_ORIGINS=http://localhost:3001,http://127.0.0.1:3001
```

### **Comptes de Test**

L'application inclut des comptes de test :

| Utilisateur | Mot de passe | Rôle |
|-------------|--------------|------|
| `testuser` | `password123` | Participant |
| `organizer_test` | `password123` | Organisateur |
| `admin` | `password123` | Administrateur |

## 📖 API Documentation

### **Endpoints Principaux**

| Endpoint | Méthode | Description | Auth |
|----------|---------|-------------|------|
| `/api/register/` | POST | Inscription utilisateur | ❌ |
| `/api/login/` | POST | Connexion utilisateur | ❌ |
| `/api/evenements/` | GET | Liste des événements | ❌ |
| `/api/evenements/` | POST | Créer un événement | ✅ |
| `/api/evenements/{id}/` | GET | Détail événement | ❌ |
| `/api/billets/` | GET | Liste des billets | ❌ |
| `/api/reservations/` | GET/POST | Gestion réservations | ✅ |
| `/api/favoris/` | GET/POST | Gestion favoris | ✅ |

### **Authentification**

L'API utilise JWT. Incluez le token dans l'en-tête :
```
Authorization: Bearer YOUR_JWT_TOKEN
```

### **Format des Réponses**

```json
{
  "success": true,
  "data": { ... },
  "message": "Success message"
}
```

En cas d'erreur :
```json
{
  "success": false,
  "error": "Error message",
  "details": { ... }
}
```

## 🧪 Tests

### **Backend Tests**
```bash
python manage.py test
```

### **Frontend Tests**
```bash
cd frontend
flutter test
```

### **Tests d'Intégration**
```bash
cd frontend
flutter test integration_test/
```

## 🛣️ Roadmap

Consultez notre [ROADMAP.md](ROADMAP.md) pour les fonctionnalités à venir :

- 🎯 **Phase 2** : Amélioration des réservations
- 💳 **Phase 3** : Intégration paiement réel (Stripe)
- 🤖 **Phase 4** : Recommandations IA
- 📊 **Phase 5** : Analytics avancés
- 🚀 **Phase 6** : Déploiement production

## 🐛 Problèmes Connus

### **Émulateur Android**
- Utilisez `10.0.2.2` au lieu de `127.0.0.1` pour l'API
- Activez les données mobiles dans l'émulateur

### **Flutter Web**
- Les images peuvent être lentes à charger en dev
- Utilisez Chrome pour de meilleures performances

## 🤝 Contribution

1. 🍴 Fork le projet
2. 🌿 Créez une branche feature (`git checkout -b feature/AmazingFeature`)
3. ✅ Commit vos changements (`git commit -m 'Add some AmazingFeature'`)
4. 📤 Push vers la branche (`git push origin feature/AmazingFeature`)
5. 🔄 Ouvrez une Pull Request

### **Guidelines de Contribution**

- 📝 Suivez les conventions de nommage
- ✅ Ajoutez des tests pour les nouvelles fonctionnalités
- 📚 Mettez à jour la documentation
- 🎨 Respectez le style de code existant

## 📄 Licence

Ce projet est sous licence MIT. Voir le fichier [LICENSE](LICENSE) pour plus de détails.

## 👥 Équipe

- **Développeur Principal** : [Pessidjo-Germann](https://github.com/Pessidjo-Germann)

## 📞 Support

- 🐛 **Issues** : [GitHub Issues](https://github.com/Pessidjo-Germann/event-management-app/issues)
- 💬 **Discussions** : [GitHub Discussions](https://github.com/Pessidjo-Germann/event-management-app/discussions)

---

⭐ **N'hésitez pas à mettre une étoile si ce projet vous aide !**

---

*Développé avec ❤️ en Django et Flutter*