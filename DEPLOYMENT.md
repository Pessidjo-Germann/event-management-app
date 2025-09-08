# 🚀 Instructions de Déploiement

## 🐳 Avec Docker

### Backend Django
```dockerfile
FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY . .

EXPOSE 8000

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
```

### Frontend Flutter Web
```dockerfile
FROM node:16-alpine as build

WORKDIR /app

COPY frontend/ .
RUN flutter build web

FROM nginx:alpine
COPY --from=build /app/build/web /usr/share/nginx/html
EXPOSE 80
```

## ☁️ Production (Heroku/Railway)

### 1. Variables d'Environnement
```env
DJANGO_SECRET_KEY=your-production-secret
DJANGO_DEBUG=False
DATABASE_URL=postgres://...
ALLOWED_HOSTS=yourdomain.com
```

### 2. Commandes de Déploiement
```bash
# Installer les dépendances
pip install -r requirements.txt

# Migrations
python manage.py migrate

# Collecter les fichiers statiques
python manage.py collectstatic --noinput

# Lancer le serveur
gunicorn backend.wsgi:application
```

## 📱 App Mobile (Google Play/App Store)

### Android
```bash
flutter build apk --release
# ou
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```