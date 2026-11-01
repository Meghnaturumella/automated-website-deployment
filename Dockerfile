# Dockerfile - Builds a small, self-contained container image for the Flask app

# Step 1: Use an official lightweight Python runtime
FROM python:3.12-slim

# Step 2: Set the working directory inside the container
WORKDIR /app

# Step 3: Copy requirements and install them
COPY app/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Step 4: Copy the application code into the container
COPY app/app.py .

# Step 5: Inform Docker that the app listens on port 5000
EXPOSE 5000

# Step 6: Command to run the Flask web server when the container starts
CMD ["python", "app.py"]
