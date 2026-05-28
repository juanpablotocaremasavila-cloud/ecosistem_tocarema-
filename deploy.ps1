# Deploy.ps1 - Automate full project deployment
# Requirements: git, railway CLI, vercel CLI installed and logged in.

Write-Host "=== Starting deployment ===" -ForegroundColor Cyan

# 1. Ensure we are in project root
Set-Location -Path (Split-Path -Parent $MyInvocation.MyCommand.Path)

# 2. Git add, commit, push
Write-Host "-> Checking git status..." -ForegroundColor Yellow
$gitStatus = git status --porcelain
if ($gitStatus) {
    Write-Host "Changes detected. Staging and committing..." -ForegroundColor Green
    git add .
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    git commit -m "Deploy: $timestamp"
    Write-Host "Pushing to remote..." -ForegroundColor Green
    git push origin main
} else {
    Write-Host "No changes to commit." -ForegroundColor Gray
}

# 3. Deploy backend with Railway (assumes railway project is linked)
Write-Host "-> Deploying backend with Railway..." -ForegroundColor Yellow
# Railway will detect changes in the 'node' directory (backend)
# Ensure we are in the backend root for Railway if needed
Push-Location "node"
railway up
Pop-Location

# 4. Deploy frontend with Vercel (assumes Vercel project is linked)
Write-Host "-> Deploying frontend with Vercel..." -ForegroundColor Yellow
Push-Location "frontend"
vercel --prod
Pop-Location

Write-Host "=== Deployment finished ===" -ForegroundColor Cyan
