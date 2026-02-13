# 🔐 GitHub Secrets Reference

## Complete List of Secrets Needed

### For Kubernetes Deployment (Base64 Encoded)

Add these to your `secret.yaml` file (must be base64 encoded):

#### 🗄️ MongoDB Secrets
```bash
# MongoDB username (default: mongouser)
echo -n 'mongouser' | base64
# Output: bW9uZ291c2Vy

# MongoDB password (default: mongpass - CHANGE THIS!)
echo -n 'YOUR_STRONG_MONGO_PASSWORD' | base64
```

#### 🔧 Backend Secrets
```bash
# Admin password for admin endpoints
echo -n 'YOUR_STRONG_ADMIN_PASSWORD' | base64

# JWT secret for token signing (min 32 chars recommended)
echo -n 'YOUR_SUPER_SECRET_JWT_KEY_MIN_32_CHARACTERS_LONG' | base64

# GitHub Personal Access Token (for GitHub stats API)
# Create at: https://github.com/settings/tokens
# Required scopes: repo (read), user (read)
echo -n 'github_pat_YOUR_ACTUAL_TOKEN_HERE' | base64

# MongoDB connection URI
echo -n 'mongodb://mongouser:mongpass@mongodb:27017/personalwebsite?authSource=admin' | base64
```

#### 📧 Frontend Secrets
```bash
# Resend API key (for contact form emails)
# Get from: https://resend.com/api-keys
echo -n 're_YOUR_ACTUAL_RESEND_API_KEY' | base64
```

---

## 📋 GitHub Secrets Setup (for CI/CD)

If you're using GitHub Actions for CI/CD, add these secrets to your repository:

### Go to: Repository → Settings → Secrets and variables → Actions → New repository secret

Add these **7 secrets** (NOT base64 encoded for GitHub):

| Secret Name | Description | Example Value |
|-------------|-------------|---------------|
| `MONGO_USERNAME` | MongoDB username | `mongouser` |
| `MONGO_PASSWORD` | MongoDB password | `MySecurePass123!` |
| `MONGODB_URI` | Full MongoDB connection string | `mongodb://mongouser:mongpass@mongodb:27017/personalwebsite?authSource=admin` |
| `ADMIN_PASS` | Backend admin password | `AdminSecure456!` |
| `JWT_SECRET` | JWT signing secret (32+ chars) | `super-secret-jwt-key-change-me-production` |
| `GITHUB_TOKEN` | GitHub Personal Access Token | `github_pat_11ABC...XYZ` |
| `RESEND_API_KEY` | Resend email API key | `re_abc123...xyz` |

---

## ✅ Verification Checklist

### Backend (9 environment variables)
- ✅ `MONGODB_URI` - MongoDB connection string (SECRET)
- ✅ `DB_NAME` - Database name (Config: `personalwebsite`)
- ✅ `ADMIN_PASS` - Admin authentication (SECRET)
- ✅ `JWT_SECRET` - JWT token secret (SECRET)
- ✅ `GITHUB_TOKEN` - GitHub API token (SECRET)
- ✅ `PORT` - Server port (Config: `5000`)
- ✅ `ENVIRONMENT` - Runtime env (Config: `production`)
- ✅ `LOG_LEVEL` - Logging level (Config: `info`)
- ✅ `CORS_ALLOW_ORIGINS` - CORS origins (Config)

### Frontend (4 environment variables)
- ✅ `NEXT_PUBLIC_BASE_URL` - Frontend URL (Config: `http://app.local`)
- ✅ `NEXT_PUBLIC_BACKEND_URL` - Backend API URL (Config: `http://backend...`)
- ✅ `RESEND_API_KEY` - Email service key (SECRET)
- ✅ `NODE_ENV` - Node environment (Config: `production`)

### MongoDB (2 environment variables)
- ✅ `MONGO_INITDB_ROOT_USERNAME` - MongoDB init user (SECRET)
- ✅ `MONGO_INITDB_ROOT_PASSWORD` - MongoDB init password (SECRET)

**Total: 15 environment variables configured**
**Secrets: 7 sensitive values**

---

## 🛠️ How to Apply Secrets

### Method 1: Update secret.yaml directly
```bash
# Edit the file with your base64 encoded values
nano secret.yaml

# Apply the updated secret
kubectl apply -f secret.yaml
```

### Method 2: Create from command line
```bash
kubectl create secret generic app-secrets \
  --namespace=personal-website \
  --from-literal=MONGODB_URI='mongodb://mongouser:mongpass@mongodb:27017/personalwebsite?authSource=admin' \
  --from-literal=ADMIN_PASS='your-admin-password' \
  --from-literal=JWT_SECRET='your-jwt-secret-min-32-chars' \
  --from-literal=GITHUB_TOKEN='github_pat_xxxxx' \
  --from-literal=RESEND_API_KEY='re_xxxxx' \
  --from-literal=MONGO_INITDB_ROOT_USERNAME='mongouser' \
  --from-literal=MONGO_INITDB_ROOT_PASSWORD='mongpass' \
  --dry-run=client -o yaml | kubectl apply -f -
```

### Method 3: Using .env file (for GitHub Actions)
Create a `.env.production` file (DO NOT commit this):
```env
MONGODB_URI=mongodb://mongouser:mongpass@mongodb:27017/personalwebsite?authSource=admin
DB_NAME=personalwebsite
ADMIN_PASS=your-admin-password
JWT_SECRET=your-jwt-secret-min-32-chars
GITHUB_TOKEN=github_pat_xxxxx
PORT=5000
ENVIRONMENT=production
LOG_LEVEL=info
CORS_ALLOW_ORIGINS=*

# Frontend
NEXT_PUBLIC_BASE_URL=http://app.local
NEXT_PUBLIC_BACKEND_URL=http://backend.personal-website.svc.cluster.local:5000
RESEND_API_KEY=re_xxxxx
NODE_ENV=production
```

---

## 🔒 Security Best Practices

1. **Never commit secrets to Git**
   - Add `.env*` to `.gitignore`
   - Use `.env.example` with dummy values for documentation

2. **Use strong passwords**
   - Admin password: 16+ characters
   - JWT secret: 32+ characters
   - MongoDB password: 16+ characters

3. **Rotate secrets regularly**
   - Change JWT_SECRET every 90 days
   - Rotate API keys every 6 months

4. **Limit token scopes**
   - GitHub token: Only grant necessary permissions
   - Resend API: Restrict to specific domains

5. **Use GitHub Secrets for CI/CD**
   - Never use secrets in workflow files directly
   - Use `${{ secrets.SECRET_NAME }}` syntax

---

## 🎯 Quick Setup Commands

```bash
# 1. Generate strong secrets
openssl rand -base64 32  # For JWT_SECRET
openssl rand -base64 24  # For passwords

# 2. Encode for Kubernetes
echo -n 'your-secret-value' | base64

# 3. Update secret.yaml with encoded values

# 4. Apply to cluster
kubectl apply -f secret.yaml

# 5. Restart deployments to pick up new secrets
kubectl rollout restart deployment/backend -n personal-website
kubectl rollout restart deployment/frontend -n personal-website
```

---

## ⚠️ Current Placeholder Values (MUST CHANGE!)

In `secret.yaml`, these are currently set to placeholders:

- `ADMIN_PASS`: `adminpass123` ❌ **CHANGE THIS!**
- `JWT_SECRET`: `jwt-secret-key-change-me-to-something-secure` ❌ **CHANGE THIS!**
- `GITHUB_TOKEN`: `github_pat_xxxxxxxxxxxxxxxxxxxx` ❌ **ADD YOUR TOKEN!**
- `RESEND_API_KEY`: `re_sxxxxxxxxxxxxxxxxxxxxx` ❌ **ADD YOUR KEY!**

---

## 📚 Getting API Keys

### GitHub Token
1. Go to https://github.com/settings/tokens
2. Click "Generate new token (classic)"
3. Select scopes: `repo` (read), `user` (read)
4. Copy the token (starts with `github_pat_` or `ghp_`)

### Resend API Key
1. Go to https://resend.com/
2. Sign up / Login
3. Navigate to API Keys section
4. Create new API key
5. Copy the key (starts with `re_`)

---

**All secrets are accounted for! ✅**
