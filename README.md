# 🚀 Automated Website Deployment using Docker & GitHub Actions

A beginner-friendly DevOps project that **automatically builds, tests, and
deploys** a static website every time you push code to GitHub.

---

## 📌 What This Project Does

| Step | What Happens |
|------|--------------|
| **Write** | You edit the HTML/CSS inside the `site/` folder on your machine. |
| **Pack** | Docker packages the site into a lightweight Nginx container. |
| **Publish** | GitHub Actions deploys the site to GitHub Pages on every push. |
| **Watch** | A scheduled health-check pings the live site every hour. |

```
 ┌─────────┐     ┌──────────┐     ┌───────────┐     ┌─────────────┐
 │  WRITE  │ ──► │   PACK   │ ──► │  PUBLISH  │ ──► │    WATCH    │
 │ (HTML)  │     │ (Docker) │     │ (Actions) │     │ (Cron Job)  │
 └─────────┘     └──────────┘     └───────────┘     └─────────────┘
```

---

## 📂 Project Structure

```
chaos-lab/
├── site/
│   ├── index.html          ← The web page (Club Notice Board)
│   └── style.css           ← Styling for the page
├── Dockerfile              ← Instructions to build the Docker image
├── .github/workflows/
│   ├── deploy.yml          ← CI/CD pipeline (check → build → deploy)
│   └── health-check.yml    ← Scheduled site uptime check
├── .gitignore              ← Files Git should ignore
├── README.md               ← This file
└── EXAM_NOTES.md           ← Plain-English exam preparation notes
```

---

## 🛠️ Run It Locally (PowerShell)

Make sure **Docker Desktop** is running, then open PowerShell in this folder:

```powershell
# 1. Build the Docker image
docker build -t club-site:v1 .

# 2. Run the container (maps port 8080 on your PC to port 80 in the container)
docker run -d -p 8080:80 --name club-site club-site:v1

# 3. Open the site in your browser
Start-Process "http://localhost:8080"

# 4. (When done) Stop and remove the container
docker stop club-site
docker rm club-site
```

---

## 🌐 Deploy to GitHub Pages (Manual Steps)

1. **Create a GitHub repository** (public) and push this code:
   ```powershell
   git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git
   git push -u origin main
   ```
2. **Enable GitHub Pages**:
   - Go to **Settings → Pages**.
   - Under *Source*, select **GitHub Actions**.
3. **Add the `SITE_URL` variable** for the health-check:
   - Go to **Settings → Secrets and variables → Actions → Variables**.
   - Create a variable named `SITE_URL` with value:
     `https://YOUR_USERNAME.github.io/YOUR_REPO/`
4. Push any change (or re-run the workflow) — the site will be live! 🎉

---

## 📜 License

This project is for educational purposes. Use it freely.
