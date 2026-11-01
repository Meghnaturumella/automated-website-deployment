# 🎓 EXAM NOTES: Self-Healing Web Application on Kubernetes with CI/CD

> **Course / Project Title:** Self-Healing Web Application on Kubernetes with Automated CI/CD  
> **Written for:** Student viva / oral exam presentation (simple plain English)

---

## 1. The Problem
In traditional server deployments:
- If a server or application crashes at 3:00 AM, the website goes down completely.
- A human engineer has to wake up, log in, restart the process, or replace the server.
- Updates require manual copying of files, leading to human mistakes and downtime.

---

## 2. The Solution
We built a cloud-native, self-healing system:
1. **Containerization:** The application and its dependencies are packaged into a standard, lightweight Docker container that runs identically everywhere.
2. **Kubernetes Orchestration:** Kubernetes continuously monitors the application. If a container crashes or is deleted, Kubernetes notices immediately and creates a brand-new container to replace it in seconds without human intervention.
3. **Automated CI/CD:** Every time new code is pushed to GitHub, GitHub Actions tests and builds the container image automatically.

---

## 3. What Each Tool Is and Why We Used It

| Tool | What it is | Why we used it |
| :--- | :--- | :--- |
| **Docker** | Container platform | Packages the Python code and Flask into an isolated, portable image (`chaos-web:v1`). |
| **Kubernetes (k8s)** | Container orchestrator | Manages containers at scale, handles load balancing, health monitoring, and self-healing. |
| **kind** | Kubernetes in Docker | Runs a real Kubernetes cluster locally on our laptop inside Docker containers without needing cloud costs. |
| **Deployment** | Kubernetes controller object | Declares the *desired state* (we want 3 replicas) and keeps pods running. |
| **Service (NodePort)** | Kubernetes networking object | Acts as a stable internal load balancer and provides an entry point (`:30080` mapped to `localhost:8080`). |
| **Probes (Liveness & Readiness)** | Health check mechanisms | Liveness probe restarts frozen containers; Readiness probe ensures traffic is sent only to healthy containers. |
| **GitHub Actions** | Automated CI/CD tool | Automatically runs in the cloud on git push to build and verify our Docker image. |

---

## 4. What Each File Does (2-Line Summary for Viva)

1. **`app/app.py`**  
   Tiny Flask web server with two routes (`/` returns pod hostname, `/health` returns "ok"). Listens on port 5000.
2. **`app/requirements.txt`**  
   Lists external Python libraries required by our application; here, only `flask`.
3. **`Dockerfile`**  
   Recipe to build our container image from `python:3.12-slim`, installing dependencies and running `app.py`.
4. **`k8s/deployment.yaml`**  
   Specifies that exactly 3 pod replicas running `chaos-web:v1` must always be active with health probes.
5. **`k8s/service.yaml`**  
   A NodePort service routing external requests on port 80/30080 across all 3 backend pods on port 5000.
6. **`kind-config.yaml`**  
   Configures the local kind cluster and forwards Windows `localhost:8080` to the Kubernetes NodePort `30080`.
7. **`.github/workflows/ci.yml`**  
   CI workflow triggered on push to `main` that checks out code and builds the Docker image to prevent broken commits.
8. **`scripts/demo.ps1`**  
   PowerShell demonstration script that inspects pods, kills one, watches Kubernetes recreate it, and tests connectivity.
9. **`docs/demo-output.txt`**  
   Stored terminal log proving that the self-healing demonstration completed successfully.
10. **`README.md`**  
    Project overview, architectural diagram, and exact PowerShell commands to run and test the project.
11. **`.gitignore`**  
    Tells Git to ignore temporary Python bytecode (`__pycache__`) and local editor files.

---

## 5. The Concept of "Desired State vs. Actual State" (Key Exam Concept!)

Kubernetes is built on a **declarative reconciliation loop**:

```
[ Desired State: 3 Pods ]  <====== Compare ======>  [ Actual State: 2 Pods ]
                                                              │
                                                        Difference found!
                                                              │
                                                              ▼
                                                   Kubelet starts 1 new Pod
                                                              │
                                                              ▼
                                                   [ Actual State: 3 Pods ] ✅
```

- In our `deployment.yaml`, we declare: `replicas: 3` (**Desired State**).
- When we delete a pod using `kubectl delete pod`, the active count drops to 2 (**Actual State**).
- The Kubernetes Deployment Controller constantly checks: `Does Actual State == Desired State?`
- Detecting a mismatch (2 != 3), Kubernetes immediately schedules and starts a replacement pod.
- This is the definition of **Self-Healing Infrastructure**.

---

## 6. The Steps We Followed
1. **Wrote the Code:** Built the Flask app and `Dockerfile`.
2. **Created the Cluster:** Configured `kind-config.yaml` with port mapping and launched a kind cluster.
3. **Built & Loaded the Image:** Built `chaos-web:v1` locally and injected it into kind using `kind load`.
4. **Applied Manifests:** Applied Deployment and Service via `kubectl apply -f k8s/`.
5. **Verified Health:** Checked pods with `kubectl get pods` and fetched the page with `curl.exe http://localhost:8080`.
6. **Executed Chaos / Failure Test:** Ran `scripts/demo.ps1` to delete a pod and witnessed immediate recreation without service downtime.
7. **Automated CI:** Configured GitHub Actions to build the container on every push.

---

## 7. The 5 C's of Modern DevOps (Memory Aid for Viva)

1. **Code:** The Python Flask application (`app/app.py`).
2. **Container:** Docker packaging application and runtime into an immutable image (`Dockerfile`).
3. **Cluster:** Kubernetes managing nodes and running pods (`kind`, `k8s/`).
4. **CI/CD:** GitHub Actions automatically building images upon code commit (`.github/workflows/ci.yml`).
5. **Chaos:** Intentionally simulating failures (deleting a pod) to prove system resilience (`scripts/demo.ps1`).

---

## 8. Future Enhancements
If extended to a full enterprise production environment, we would add:
- **Metrics & Observability:** Prometheus to scrape metrics and Grafana to visualize latency and CPU usage.
- **Autoscaling:** Horizontal Pod Autoscaler (HPA) to scale pod count based on incoming user traffic.
- **Chaos Testing:** Chaos Mesh to automate advanced chaos experiments like packet delay and memory stress.
- **Continuous Deployment (CD):** ArgoCD or Flux for GitOps automated cluster synchronization.
