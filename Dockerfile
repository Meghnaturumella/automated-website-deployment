# Dockerfile - Instructions to package our static website into a container.
#
# How it works:
#   1. We start from a tiny Linux image that already has Nginx (a web server).
#   2. We copy our website files into the folder Nginx serves by default.
#   3. When the container runs, Nginx automatically serves our site on port 80.

# Step 1: Use the official Nginx image based on Alpine Linux (very small ~40 MB).
FROM nginx:alpine

# Step 2: Copy everything inside the "site" folder on our machine
#         into the default Nginx web-root inside the container.
COPY site/ /usr/share/nginx/html/

# That's it! Nginx starts automatically when the container runs.
# No CMD needed — the base image already has one.
