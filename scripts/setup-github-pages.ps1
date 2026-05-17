# Publishes Dhyan to GitHub and enables Pages for docs/ (privacy policy).
# Prerequisites: git, GitHub CLI (gh), logged in via: gh auth login

$ErrorActionPreference = "Stop"
$RepoName = "Dhyan"
Set-Location (Resolve-Path (Join-Path $PSScriptRoot ".."))

if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
    Write-Host "Install GitHub CLI: winget install GitHub.cli"
    exit 1
}

gh auth status 2>&1 | Out-Null
if ($LASTEXITCODE -ne 0) {
    Write-Host "Run: gh auth login"
    exit 1
}

$owner = (gh api user -q .login)
Write-Host "GitHub user: $owner"

$remote = git remote get-url origin 2>$null
if (-not $remote) {
    gh repo create $RepoName --public --source=. --remote=origin --push
} else {
    Write-Host "Remote already set: $remote"
    git push -u origin main
}

gh api -X POST "repos/$owner/$RepoName/pages" `
    -f "build_type=workflow" 2>$null

Write-Host ""
Write-Host "Enable Pages (one-time in browser if workflow deploy fails):"
Write-Host "  https://github.com/$owner/$RepoName/settings/pages"
Write-Host "  Source: GitHub Actions"
Write-Host ""
$baseUrl = "https://$owner.github.io/$RepoName/"
Write-Host "Privacy policy URLs (after Pages deploys, ~1-2 min):"
Write-Host "  $baseUrl"
Write-Host "  ${baseUrl}privacy-policy.html"
Write-Host ""
Write-Host "Paste into Play Console and lib/core/legal/app_legal.dart -> privacyPolicyUrl"
