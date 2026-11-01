# 📝 EXAM NOTES — Automated Website Deployment

> Written in simple English so you can explain every part in your exam.

---

## 1. Problem Statement

Manually copying website files to a server every time we make a change is
slow, error-prone, and hard to scale. We need an **automated** way to test,
package, and deploy a website whenever the code is updated.

---

## 2. Solution (One Line)

We use **Docker** to package the website and **GitHub Actions** to
automatically deploy it to **GitHub Pages** on every push, with a scheduled
health-check to monitor uptime.

---

## 3. Technologies Used (and Why)

### Docker
- **What:** A tool that packages an application and its dependencies into a
  lightweight, portable unit called a *container*.
- **Why:** So our website runs the same way on every machine — my laptop,
  your laptop, or a cloud server — without "it works on my machine" problems.

### Nginx
- **What:** A fast, open-source web server used to serve static files
  (HTML, CSS, images).
- **Why:** It is tiny, fast, and the official `nginx:alpine` Docker image is
  only ~40 MB, perfect for serving a simple static site.

### GitHub Actions
- **What:** GitHub's built-in CI/CD (Continuous Integration / Continuous
  Deployment) service. It runs automated workflows defined in YAML files
  inside `.github/workflows/`.
- **Why:** It is free for public repos, tightly integrated with GitHub, and
  needs zero extra setup — no separate Jenkins or CircleCI server.

### GitHub Pages
- **What:** A free static-site hosting service by GitHub. It serves HTML/CSS
  directly from your repository.
- **Why:** Perfect for our project — free, automatic HTTPS, and can be
  deployed straight from a GitHub Actions workflow.

---

## 4. What Each File Does (2 Lines)

| File | Purpose |
|------|---------|
| `site/index.html` | The main web page — a College Club Notice Board with 3 notices. Served by Nginx inside the container. |
| `site/style.css` | Stylesheet that makes the page look clean with cards, colours, and spacing. Linked from index.html. |
| `Dockerfile` | Tells Docker to use nginx:alpine and copy the site files into the web server's root. That's the whole image. |
| `deploy.yml` | CI/CD pipeline triggered on push: checks the HTML exists → builds the Docker image → deploys to GitHub Pages. |
| `health-check.yml` | Scheduled cron workflow (every hour) that curls the live URL and fails if the site is down. |
| `.gitignore` | Lists files Git should not track, like OS junk files and editor settings. |
| `README.md` | Project overview, text diagram, local run commands, and steps to deploy on GitHub. |
| `EXAM_NOTES.md` | This file — plain-English explanation of every concept for exam preparation. |

---

## 5. Steps I Followed

1. **Created the website** — wrote `index.html` and `style.css` inside a
   `site/` folder.
2. **Wrote the Dockerfile** — used `nginx:alpine` as the base image and
   copied the `site/` folder into Nginx's default directory.
3. **Built and tested locally** —
   - `docker build -t club-site:v1 .`  (build the image)
   - `docker run -d -p 8080:80 --name club-site club-site:v1`  (run it)
   - Opened `http://localhost:8080` to confirm the page loads.
4. **Created the deploy workflow** (`deploy.yml`) with three jobs:
   - *check* — verifies `index.html` exists and is not empty.
   - *build-image* — builds the Docker image (validates the Dockerfile).
   - *deploy* — publishes the `site/` folder to GitHub Pages.
5. **Created the health-check workflow** (`health-check.yml`) —
   runs every hour via cron; uses `curl --fail` to ping the live URL.
6. **Initialised Git** — `git init`, renamed branch to `main`, committed
   all files.
7. **Pushed to GitHub** — created a remote repo, pushed, enabled Pages,
   and set the `SITE_URL` variable.

---

## 6. Result

- The website is **live** on GitHub Pages at a public URL.
- Every push triggers the pipeline: check → build → deploy.
- Every hour, the health-check confirms the site is reachable.
- If anything fails, GitHub sends a notification.

---

## 7. Key DevOps Concepts Demonstrated

| Concept | How It Appears |
|---------|---------------|
| **Containerisation** | Docker packages the site + Nginx into one image. |
| **CI (Continuous Integration)** | The "check" and "build-image" jobs validate every push. |
| **CD (Continuous Deployment)** | The "deploy" job pushes the site live automatically. |
| **Infrastructure as Code** | The Dockerfile and YAML workflows define everything as code. |
| **Monitoring** | The health-check cron job watches the live site. |

---

## 8. Future Work / Improvements

- Add **HTML validation** (e.g., `html5validator`) to the check job.
- Send a **Slack or email alert** if the health-check fails.
- Add a **staging environment** and require approval before deploying to
  production.
- Use **Docker Hub** to push and version the image for production use.
- Add **Lighthouse CI** to test page performance, accessibility, and SEO.

---

*Good luck with your exam! 🎓*
