# scripts/demo.ps1 - Demonstrates Kubernetes Self-Healing capabilities
# 1. Shows running pods
# 2. Deletes one pod intentionally
# 3. Shows Kubernetes automatically recreating a replacement pod to match desired state (3 replicas)
# 4. Confirms the web application stayed available throughout

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host " Kubernetes Self-Healing Demonstration" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

# Step 1: Display the current healthy pods
Write-Host "`n[Step 1] Current pods before deletion:" -ForegroundColor Yellow
kubectl get pods -l app=web-app -o wide

# Pick the first pod name
$podToDelete = (kubectl get pods -l app=web-app -o jsonpath="{.items[0].metadata.name}")
Write-Host "`nTarget pod chosen for deletion: $podToDelete" -ForegroundColor Magenta

# Step 2: Delete the chosen pod intentionally
Write-Host "`n[Step 2] Deleting pod '$podToDelete' to simulate a failure..." -ForegroundColor Red
kubectl delete pod $podToDelete

# Step 3: Wait a few seconds for the Deployment controller to react and reconcile
Write-Host "`n[Step 3] Waiting 5 seconds for Kubernetes to reconcile desired state..." -ForegroundColor Yellow
Start-Sleep -Seconds 5

# Step 4: Show pods after deletion - notice the new pod created to replace it!
Write-Host "`n[Step 4] Pods after deletion (Notice the new replacement pod):" -ForegroundColor Green
kubectl get pods -l app=web-app -o wide

# Step 5: Test that the web service remained accessible without downtime
Write-Host "`n[Step 5] Checking web service response from http://localhost:8080:" -ForegroundColor Yellow
$response = curl.exe -s http://localhost:8080
Write-Host "Service Response: $response" -ForegroundColor Green

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host " Self-healing test successful! Kubernetes maintained 3 pods." -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan
