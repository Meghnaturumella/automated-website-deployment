# Self-Healing Web Application on Kubernetes with Automated CI/CD

A simple, complete DevOps project demonstrating automated container builds and Kubernetes self-healing architecture.

---

## 🏗️ Architecture

```
User / Browser
      │
      ▼ (HTTP :8080)
┌─────────────────────────────────────────────────────────────┐
│ kind Kubernetes Cluster ("kind")                            │
│                                                             │
│   NodePort Service (web-service) :30080 -> :5000            │
│                              │                              │
│              ┌───────────────┼───────────────┐              │
│              ▼               ▼               ▼              │
│       ┌─────────────┐ ┌─────────────┐ ┌─────────────┐       │
│       │   Pod 1     │ │   Pod 2     │ │   Pod 3     │       │
│       │ (Flask app) │ │ (Flask app) │ │ (Flask app) │       │
│       └─────────────┘ └─────────────┘ └─────────────┘       │
│              ▲               ▲               ▲              │
│              └───────────────┴───────────────┘              │
│                 Managed by Deployment: web-app              │
│             (Reconciliation loop: Desired = 3)              │
└─────────────────────────────────────────────────────────────┘
```

---

## 🚀 Quick Start (PowerShell Commands)

Run the following commands in order from the repository root (`C:\Users\Meghna\Documents\chaos-lab`):

### 1. Create the kind cluster
```powershell
# Remove old cluster if present, then create the cluster
kind delete cluster --name kind
kind create cluster --config kind-config.yaml
```

### 2. Build and load the Docker image
```powershell
docker build -t chaos-web:v1 .
kind load docker-image chaos-web:v1 --name kind
```

### 3. Deploy application to Kubernetes
```powershell
kubectl apply -f k8s/
```

### 4. Verify pods are Running
```powershell
kubectl get pods -l app=web-app
```

### 5. Test the application endpoint
```powershell
curl.exe http://localhost:8080
curl.exe http://localhost:8080/health
```

### 6. Run the Self-Healing demonstration
```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\demo.ps1
```

---

## 📂 Project Structure

```
chaos-lab/
├── .github/
│   └── workflows/
│       └── ci.yml             # GitHub Actions CI workflow (builds image on push)
├── app/
│   ├── app.py                 # Flask web app displaying pod hostname
│   └── requirements.txt       # Python dependencies (flask)
├── docs/
│   └── demo-output.txt        # Captured output from the self-healing demo
├── k8s/
│   ├── deployment.yaml        # Deployment with 3 replicas and health probes
│   └── service.yaml           # NodePort service exposing the app on port 30080
├── scripts/
│   └── demo.ps1               # Automated self-healing demo script
├── .gitignore                 # Python and editor ignore rules
├── Dockerfile                 # Container definition for the Flask app
├── EXAM_NOTES.md              # Plain-English guide for exam explanations
├── kind-config.yaml           # Local kind cluster configuration with port mapping
└── README.md                  # This file
```
