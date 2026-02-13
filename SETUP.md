# 🚀 Kubernetes Deployment Setup Guide

## ⚠️ IMPORTANT: Update These Secrets Before Deploying!

### 1. Update `secret.yaml`

You **MUST** change these base64-encoded values in `secret.yaml`:

#### 🔐 Backend Secrets

```bash
# Generate new ADMIN_PASS (replace 'your-strong-password')
echo -n 'your-strong-password' | base64
# Copy output and replace ADMIN_PASS value in secret.yaml

# Generate new JWT_SECRET (use a long random string)
echo -n 'your-super-secret-jwt-key-min-32-chars' | base64
# Copy output and replace JWT_SECRET value in secret.yaml

# Add your GitHub Personal Access Token
echo -n 'github_pat_YOUR_ACTUAL_TOKEN' | base64
# Copy output and replace GITHUB_TOKEN value in secret.yaml
```

#### 📧 Frontend Secrets

```bash
# Add your Resend API Key (for contact form)
echo -n 're_YOUR_ACTUAL_RESEND_API_KEY' | base64
# Copy output and replace RESEND_API_KEY value in secret.yaml
```

### 2. Environment Variables Configured

#### Backend (Go):
- ✅ `MONGODB_URI` - MongoDB connection string
- ✅ `DB_NAME` - Database name (personalwebsite)
- ✅ `ADMIN_PASS` - Admin authentication password
- ✅ `JWT_SECRET` - JWT token secret key
- ✅ `GITHUB_TOKEN` - GitHub API token for stats
- ✅ `PORT` - Server port (5000)
- ✅ `ENVIRONMENT` - Runtime environment (production)
- ✅ `LOG_LEVEL` - Logging level (info)
- ✅ `CORS_ALLOW_ORIGINS` - Allowed CORS origins

#### Frontend (Next.js):
- ✅ `NEXT_PUBLIC_BASE_URL` - Frontend public URL
- ✅ `NEXT_PUBLIC_BACKEND_URL` - Backend API URL
- ✅ `RESEND_API_KEY` - Email service API key
- ✅ `NODE_ENV` - Node environment (production)

---

## 🏗️ Deployment Steps

### 1. Build Docker Images

```bash
# Build backend image
cd MishraShardendu22-Backend-PersonalWebsite
docker build -t ms22-backend:latest .

# Build frontend image (update this with your frontend Dockerfile)
cd ../MS22
docker build -t ms22-frontend:latest .

# Load images into Minikube
minikube image load ms22-backend:latest
minikube image load ms22-frontend:latest
```

### 2. Update Frontend Image Reference

Edit `frontend-deployment.yml` and change:
```yaml
image: your-dockerhub/frontend:latest
```
to:
```yaml
image: ms22-frontend:latest
imagePullPolicy: Never
```

### 3. Enable Ingress

```bash
minikube addons enable ingress
```

### 4. Deploy Everything

```bash
# Apply in order
kubectl apply -f namespace.yaml
kubectl apply -f secret.yaml
kubectl apply -f configmap.yml
kubectl apply -f mongo-db-pv.yaml
kubectl apply -f mongo-db-pvc.yaml
kubectl apply -f mongodb-deployment.yml
kubectl apply -f mongodb-service.yml
kubectl apply -f backend-deployment.yml
kubectl apply -f backend-service.yml
kubectl apply -f frontend-deployment.yml
kubectl apply -f frontend-service.yml
kubectl apply -f ingress.yml
```

### 5. Configure /etc/hosts

```bash
# Get Minikube IP
minikube ip

# Add to /etc/hosts (replace <MINIKUBE-IP> with actual IP)
echo "<MINIKUBE-IP> app.local" | sudo tee -a /etc/hosts
```

### 6. Verify Deployment

```bash
# Check all resources
kubectl get all -n personal-website

# Check pods are running
kubectl get pods -n personal-website

# Check logs if there are issues
kubectl logs -n personal-website deployment/backend
kubectl logs -n personal-website deployment/frontend
kubectl logs -n personal-website deployment/mongodb
```

### 7. Access Application

Open browser and navigate to:
```
http://app.local
```

---

## 🔍 Troubleshooting

### Pods Not Starting?

```bash
# Describe pod to see events
kubectl describe pod -n personal-website <pod-name>

# Check logs
kubectl logs -n personal-website <pod-name>
```

### MongoDB Connection Issues?

```bash
# Test MongoDB connection
kubectl exec -it -n personal-website deployment/mongodb -- mongosh -u mongouser -p mongpass --authenticationDatabase admin
```

### Backend Can't Connect to MongoDB?

Check the MONGODB_URI in secret.yaml. The current value is:
```
mongodb://mongouser:mongpass@mongodb:27017/personalwebsite?authSource=admin
```

### ImagePullBackOff Error?

Make sure images are loaded into Minikube:
```bash
minikube image ls | grep ms22
```

---

## 🧹 Cleanup

```bash
# Delete all resources
kubectl delete namespace personal-website

# Or delete individually
kubectl delete -f .
```

---

## 📝 Notes

1. **MongoDB Data Persistence**: Data is stored in `/data/mongodb` on the Minikube node
2. **Default Credentials**: 
   - MongoDB user: `mongouser`
   - MongoDB pass: `mongpass`
   - **CHANGE THESE IN PRODUCTION!**
3. **CORS**: Backend allows requests from `http://app.local`, `http://frontend`, and cluster-internal URLs
4. **Port**: Backend runs on port 5000, Frontend on port 3000 (served via port 80)

---

## 🔒 Security Checklist

- [ ] Changed ADMIN_PASS to a strong password
- [ ] Changed JWT_SECRET to a long random string
- [ ] Added real GITHUB_TOKEN
- [ ] Added real RESEND_API_KEY
- [ ] Changed MongoDB credentials (optional but recommended)
- [ ] Not exposing secrets in version control

---

## 📚 Additional Resources

- [Kubernetes Secrets](https://kubernetes.io/docs/concepts/configuration/secret/)
- [Minikube Documentation](https://minikube.sigs.k8s.io/docs/)
- [kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)
