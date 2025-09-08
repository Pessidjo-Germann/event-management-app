# Event Management App - GitHub Copilot Instructions

**ALWAYS follow these instructions first. Only search for additional information if these instructions are incomplete or found to be in error.**

## Critical Repository Status

**⚠️ REPOSITORY INCOMPLETE WARNING**: This repository is currently in an incomplete state. The Django backend configuration exists but the actual `events` Django app code is missing. The Flutter frontend only has dependency definitions but no source code.

## Working Environment Setup

### Python Backend Setup
Run these commands to set up the Python environment - **VALIDATED TO WORK:**

```bash
# Check Python version (requires 3.8+)
python --version

# Create virtual environment - takes 3 seconds
python -m venv venv_backend

# Activate virtual environment
source venv_backend/bin/activate  # Linux/Mac
# venv_backend\Scripts\activate     # Windows

# Install dependencies - takes 30 seconds, NEVER CANCEL
pip install -r requirements.txt
# NOTE: If this fails with timeout errors, network connectivity may be limited.
# When network is available, this command installs successfully.
```

**Dependencies successfully install (when network available):** Django 5.2.6, DRF, JWT authentication, CORS headers, Pillow, psycopg2-binary.

### Django Setup Status
**⚠️ DJANGO CANNOT RUN** - The following commands will FAIL:
```bash
# These commands FAIL due to missing events app:
python manage.py migrate          # FAILS - No module named 'events'
python manage.py runserver       # FAILS - No module named 'events'
python create_test_user.py       # FAILS - No module named 'events'
python create_test_events.py     # FAILS - No module named 'events'
```

**Root Cause:** 
- `backend/settings.py` references `'events.apps.EventsConfig'` in INSTALLED_APPS
- `AUTH_USER_MODEL = 'events.CustomUser'` in settings
- The `events/` directory and all its code (models.py, views.py, apps.py, etc.) are missing

### Flutter Frontend Setup
**⚠️ FLUTTER INCOMPLETE** - Only `pubspec.yaml` exists, all source code is missing.

To set up Flutter environment:
```bash
# Install Flutter SDK first (method depends on system)
# Download from: https://docs.flutter.dev/get-started/install

# Navigate to frontend directory
cd frontend

# Install dependencies - requires Flutter SDK installed first
flutter pub get

# Generate code - requires source files that don't exist
flutter packages pub run build_runner build  # WILL FAIL - no source code

# Run app - requires source files that don't exist  
flutter run  # WILL FAIL - no lib/main.dart
```

## Repository Structure

```
event-management-app/
├── backend/                    # Django config (EXISTS)
│   ├── settings.py            # Complete Django settings
│   ├── urls.py               # URL configuration
│   └── __init__.py
├── frontend/                   # Flutter app (INCOMPLETE)
│   └── pubspec.yaml          # Dependencies only - no source code
├── manage.py                  # Django management (EXISTS)
├── requirements.txt           # Python deps (COMPLETE)
├── create_test_user.py       # Test data script (EXISTS but won't run)
├── create_test_events.py     # Test data script (EXISTS but won't run)
├── README.md                 # Documentation (EXISTS)
├── DEPLOYMENT.md             # Deploy guide (EXISTS)
└── ROADMAP.md               # Feature roadmap (EXISTS)

MISSING CRITICAL COMPONENTS:
├── events/                    # Django app - COMPLETELY MISSING
│   ├── models.py             # CustomUser, Evenement, Billet models
│   ├── views.py              # API views
│   ├── apps.py               # App configuration
│   ├── admin.py              # Admin interface
│   └── migrations/           # Database migrations
└── frontend/lib/             # Flutter source code - MISSING
    ├── main.dart             # App entry point
    ├── models/               # Data models
    ├── services/             # API services
    └── screens/              # UI screens
```

## What You CAN Do
1. **Set up Python environment** - Works perfectly
2. **Install Python dependencies** - Takes 30 seconds, validated
3. **Read configuration files** - All Django settings are properly configured
4. **Understand project architecture** - Well documented in README
5. **Review planned features** - See ROADMAP.md for complete feature list

## What You CANNOT Do (Missing Code)
1. **Run Django server** - Missing events app
2. **Run Django migrations** - Missing models
3. **Create test data** - Scripts exist but depend on missing models
4. **Build/run Flutter app** - Missing all source code
5. **Run any tests** - No test files exist
6. **Follow README setup instructions** - They assume complete codebase

## Expected Django App Structure (Currently Missing)

The `events/` app should contain:
```python
# events/models.py - Referenced by test scripts
class CustomUser(AbstractUser):
    role = models.CharField(max_length=20)  # participant, organizer, artist, admin

class Evenement:
    titre = models.CharField(max_length=200)
    description = models.TextField()
    date_evenement = models.DateTimeField()
    lieu = models.CharField(max_length=200)
    capacite = models.IntegerField()
    organisateur = models.ForeignKey(CustomUser)

class Billet:
    evenement = models.ForeignKey(Evenement)
    type_billet = models.CharField(max_length=50)
    prix = models.DecimalField()
    quantite_disponible = models.IntegerField()
```

## Expected Flutter Structure (Currently Missing)

The Flutter app should have:
```
frontend/lib/
├── main.dart                 # App entry point
├── models/                   # JSON serializable models
│   ├── user.dart            # User model
│   ├── event.dart           # Event model
│   └── ticket.dart          # Ticket model
├── services/
│   └── api_service.dart     # HTTP client for Django API
├── screens/                 # UI screens
│   ├── login_screen.dart
│   ├── home_screen.dart
│   └── event_detail_screen.dart
└── providers/               # State management
    └── auth_provider.dart
```

## Technology Stack (Verified in Configuration)
- **Backend:** Django 5.2.6 + Django REST Framework + JWT authentication
- **Database:** SQLite (development), PostgreSQL (production via DATABASE_URL)
- **Frontend:** Flutter 3.24+ with Provider state management
- **Authentication:** JWT tokens with SimpleJWT
- **CORS:** Configured for Flutter web on localhost:3001

## Environment Variables

Create `.env` file (based on `.env.example`):
```env
DEBUG=True
SECRET_KEY=your-secret-key-here
DATABASE_URL=sqlite:///db.sqlite3
ALLOWED_HOSTS=localhost,127.0.0.1,10.0.2.2
CORS_ALLOWED_ORIGINS=http://localhost:3001,http://127.0.0.1:3001
```

## Common Development Tasks

### Adding the Missing Events App
```bash
# After activating virtual environment
python manage.py startapp events

# Then create the models referenced in test scripts:
# - CustomUser (extends AbstractUser)
# - Evenement (Event model)
# - Billet (Ticket model)
# - Reservation (Reservation model)
# - Favori (Favorites model)
```

### Creating Flutter Source Code
```bash
# After installing Flutter SDK
cd frontend
flutter create . --project-name frontend
# Then implement the screens and models based on API structure
```

## Validation Checklist

Before making changes, ensure:
- [ ] Python virtual environment is activated
- [ ] All dependencies in requirements.txt are installed
- [ ] Django events app exists with proper models
- [ ] Flutter source code exists in frontend/lib/
- [ ] Environment variables are configured

## Time Estimates (Measured)
- **Python environment setup:** 3 seconds
- **Pip install requirements:** 30 seconds (when network available) - NEVER CANCEL
- **Django app creation:** 5 seconds (when events app exists)
- **Flutter pub get:** 30-60 seconds (when Flutter SDK installed)
- **Flutter build runner:** 60-120 seconds (when source code exists)

## API Endpoints (Configured but Not Implemented)

Expected endpoints based on configuration:
- `POST /api/register/` - User registration
- `POST /api/login/` - User authentication  
- `GET /api/evenements/` - List events
- `POST /api/evenements/` - Create event
- `GET /api/evenements/{id}/` - Event details
- `POST /api/reservations/` - Create reservation
- `GET /api/favoris/` - User favorites

**Note:** URLs are configured in Django but views don't exist yet.

## Testing

**⚠️ NO TESTS EXIST** - You will need to create:
- Django unit tests for models and API views
- Flutter widget tests for UI components  
- Integration tests for full user workflows

## Key Files for Development

**Always check these files when making changes:**
- `backend/settings.py` - Django configuration
- `backend/urls.py` - URL routing
- `requirements.txt` - Python dependencies
- `frontend/pubspec.yaml` - Flutter dependencies
- `README.md` - High-level documentation
- `.env.example` - Environment variable template

## Limitations Summary

This repository provides excellent documentation and configuration but is **incomplete for actual development**. Use these instructions to understand the intended architecture and set up your development environment, but be aware that significant implementation work is required before the application can run.