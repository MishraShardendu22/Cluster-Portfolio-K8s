# Docker Build Instructions

## Build Backend Image

```bash
cd MishraShardendu22-Backend-PersonalWebsite
docker build -t ms22-backend:latest .
```

## Build Frontend Image

```bash
cd MS22
docker build -t ms22-frontend:latest .
```

## Tag for Registry (Optional)

```bash
# Replace 'yourusername' with your Docker Hub username or registry URL
docker tag ms22-backend:latest yourusername/ms22-backend:latest
docker tag ms22-frontend:latest yourusername/ms22-frontend:latest
```

## Push to Registry (Optional)

```bash
docker push yourusername/ms22-backend:latest
docker push yourusername/ms22-frontend:latest
```

## Test Locally

```bash
# Backend
docker run -d -p 8080:8080 \
  -e MONGO_URI="your-mongo-uri" \
  -e JWT_SECRET="your-secret" \
  -e JWT_REFRESH_SECRET="your-refresh-secret" \
  -e ADMIN_USERNAME="admin" \
  -e ADMIN_PASSWORD="password" \
  ms22-backend:latest

# Frontend
docker run -d -p 3000:3000 \
  -e RESEND_API_KEY="your-resend-key" \
  -e NEXT_PUBLIC_API_URL="http://localhost:8080" \
  -e NEXT_PUBLIC_SITE_URL="http://localhost:3000" \
  ms22-frontend:latest
```

## Notes

- **Backend**: All environment variables must be provided at runtime (Kubernetes ConfigMaps/Secrets)
- **Frontend**: RESEND_API_KEY gets a placeholder during build, pass real key at runtime
- Both images are production-ready and optimized for Kubernetes deployment
