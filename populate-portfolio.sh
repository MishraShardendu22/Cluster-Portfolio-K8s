#!/bin/bash

# Portfolio Data Population Script
# This script helps you populate your portfolio using the admin API

BACKEND_URL="http://localhost:5001"
ADMIN_PASS="adminpass123"

# Cleanup function
cleanup() {
  echo ""
  echo "Cleaning up port-forward..."
  kill $PORT_FORWARD_PID 2>/dev/null
}

# Set trap to cleanup on exit
trap cleanup EXIT INT TERM

# Start port-forward in background
echo "Setting up port-forward to backend..."
kubectl port-forward -n personal-website svc/backend 5001:5000 > /dev/null 2>&1 &
PORT_FORWARD_PID=$!

# Wait for port-forward to be ready
sleep 2

echo "==========================================
Portfolio Data Population Script
=========================================="

# Step 1: Login to get JWT token
echo ""
echo "Step 1: Getting admin JWT token..."
LOGIN_RESPONSE=$(curl -s -X POST "$BACKEND_URL/api/admin/auth" \
  -H "Content-Type: application/json" \
  -d "{
    \"admin_pass\": \"$ADMIN_PASS\",
    \"email\": \"admin@portfolio.com\",
    \"password\": \"MySecurePassword123\"
  }")

TOKEN=$(echo $LOGIN_RESPONSE | grep -o '"token":"[^"]*' | cut -d'"' -f4)

if [ -z "$TOKEN" ]; then
  echo "❌ Failed to login! Check your ADMIN_PASS"
  echo "Response: $LOGIN_RESPONSE"
  exit 1
fi

echo "✅ Logged in successfully!"
echo "Token: ${TOKEN:0:20}..."

# Step 2: Add a project
echo ""
echo "Step 2: Adding a sample project..."
PROJECT_RESPONSE=$(curl -s -X POST "$BACKEND_URL/api/projects" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "project_name": "Personal Portfolio",
    "small_description": "A modern portfolio website",
    "description": "A modern portfolio website built with Next.js and Go backend, deployed on Kubernetes with MongoDB for data persistence.",
    "skills": ["React", "TypeScript", "Go", "Docker", "K8s"],
    "project_repository": "https://github.com/yourusername/portfolio",
    "project_live_link": "http://app.local",
    "order": 1
  }')

echo "Response: $PROJECT_RESPONSE"

# Step 3: Add an experience
echo ""
echo "Step 3: Adding a sample experience..."
EXP_RESPONSE=$(curl -s -X POST "$BACKEND_URL/api/experiences" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "company_name": "Tech Company",
    "description": "Developed amazing software solutions",
    "technologies": ["Python", "Go", "React"],
    "experience_time_line": [{
      "position": "Software Engineer",
      "start_date": "2023-01-01T00:00:00Z",
      "end_date": "2024-12-31T00:00:00Z"
    }]
  }')

echo "Response: $EXP_RESPONSE"

# Step 4: Add a certification
echo ""
echo "Step 4: Adding a sample certification..."
CERT_RESPONSE=$(curl -s -X POST "$BACKEND_URL/api/certifications" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "title": "Kubernetes Administrator",
    "description": "Certified Kubernetes Administrator - demonstrating expertise in K8s cluster management",
    "issuer": "Linux Foundation",
    "issue_date": "2024-06-01T00:00:00Z",
    "certificate_url": "https://www.cncf.io/certification/cka/"
  }')

echo "Response: $CERT_RESPONSE"

# Step 5: Add volunteer experience
echo ""
echo "Step 5: Adding a sample volunteer experience..."
VOLUNTEER_RESPONSE=$(curl -s -X POST "$BACKEND_URL/api/volunteer/experiences" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "organisation": "Open Source Community",
    "description": "Contributed to various open-source projects and mentored new contributors in the community.",
    "technologies": ["Go", "Python", "JavaScript", "Docker"],
    "volunteer_time_line": [{
      "position": "Community Mentor",
      "start_date": "2023-03-01T00:00:00Z",
      "end_date": "2024-12-31T00:00:00Z"
    }]
  }')

echo "Response: $VOLUNTEER_RESPONSE"

echo ""
echo "=========================================="
echo "✅ Sample data added successfully!"
echo "Visit http://app.local to see your portfolio"
echo "=========================================="
