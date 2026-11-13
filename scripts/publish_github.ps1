<#
.SYNOPSIS
  Публикация лабораторной работы № 4 на GitHub: репозиторий, Pages, Wiki.
.EXAMPLE
  powershell -ExecutionPolicy Bypass -File scripts\publish_github.ps1 -Owner my-login -Repo knigamag-lab4
#>
param(
  [Parameter(Mandatory=$true)][string]$Owner,
  [Parameter(Mandatory=$true)][string]$Repo,
  [ValidateSet('public','private')][string]$Visibility = 'public',
  [switch]$NoCommit
)

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
Set-Location $root

Write-Host "==> 1/6  Подстановка $Owner/$Repo в ссылки" -ForegroundColor Cyan
$files = Get-ChildItem -Recurse -File -Include *.md,*.yml,*.yaml,*.ps1 |
         Where-Object {
           $_.FullName -notmatch '\.git' -and
           $_.FullName -notmatch '\.github[\\/]workflows[\\/]ci\.yml' -and
           $_.Name -ne 'PUBLISHING.md' -and
           $_.Name -ne 'publish_github.ps1'
         }
foreach ($f in $files) {
  $t = [IO.File]::ReadAllText($f.FullName, [Text.Encoding]::UTF8)
  $n = $t.Replace('__OWNER__', $Owner).Replace('__REPO__', $Repo)
  if ($n -ne $t) { [IO.File]::WriteAllText($f.FullName, $n, (New-Object Text.UTF8Encoding($false))) }
}

Write-Host "==> 2/6  Git: инициализация и коммит" -ForegroundColor Cyan
if (-not (Test-Path '.git')) { git init -b main }
git add -A
if (-not $NoCommit) { git commit -m "Lab 4: requirements, DB model, OpenAPI 3.0, mock server, wiki, Pages" }
$branch = (git rev-parse --abbrev-ref HEAD).Trim()

Write-Host "==> 3/6  Проверка GitHub CLI и авторизации" -ForegroundColor Cyan
if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
  throw "GitHub CLI не найден. Установите: winget install --id GitHub.cli  (затем перезапустите терминал)"
}
& gh auth status 2>&1 | Out-Null
if ($LASTEXITCODE -ne 0) { & gh auth login --web --git-protocol https }
if ($LASTEXITCODE -ne 0) { throw "Авторизация GitHub не выполнена" }

Write-Host "==> 4/6  Создание репозитория и отправка кода" -ForegroundColor Cyan
& gh repo view "$Owner/$Repo" 2>&1 | Out-Null
$exists = ($LASTEXITCODE -eq 0)
if (-not $exists) {
  & gh repo create "$Owner/$Repo" --$Visibility --source=. --remote=origin --push
} else {
  & git remote get-url origin 2>&1 | Out-Null
  if ($LASTEXITCODE -ne 0) { & git remote add origin "https://github.com/$Owner/$Repo.git" }
  & git push -u origin $branch
}
if ($LASTEXITCODE -ne 0) { throw "Не удалось отправить код" }

Write-Host "==> 5/6  Включение GitHub Pages (branch $branch, /docs)" -ForegroundColor Cyan
& gh api -X POST "repos/$Owner/$Repo/pages" `
  -f "source[branch]=$branch" -f "source[path]=/docs" 2>&1 | Out-Null
if ($LASTEXITCODE -ne 0) {
  & gh api -X PUT "repos/$Owner/$Repo/pages" `
    -f "source[branch]=$branch" -f "source[path]=/docs" 2>&1 | Out-Null
}
if ($LASTEXITCODE -ne 0) {
  Write-Host "    Не удалось включить Pages через API — сделайте это вручную:" -ForegroundColor Yellow
  Write-Host "    Settings -> Pages -> Deploy from a branch -> $branch /docs" -ForegroundColor Yellow
}

Write-Host "==> 6/6  Публикация Wiki (7 страниц)" -ForegroundColor Cyan
$wikiUrl = "https://github.com/$Owner/$Repo.wiki.git"
$tmp = Join-Path $env:TEMP ("knigamag-wiki-" + [guid]::NewGuid().ToString('N').Substring(0,8))
& git clone $wikiUrl $tmp 2>&1 | Out-Null
if ($LASTEXITCODE -ne 0) {
  Write-Host "    Wiki ещё не инициализирована." -ForegroundColor Yellow
  Write-Host "    Откройте https://github.com/$Owner/$Repo/wiki, создайте страницу Home," -ForegroundColor Yellow
  Write-Host "    затем повторите: powershell -File scripts\publish_github.ps1 -Owner $Owner -Repo $Repo" -ForegroundColor Yellow
} else {
  Get-ChildItem (Join-Path $root 'wiki') -Filter *.md |
    Copy-Item -Destination $tmp -Force
  Set-Location $tmp
  & git add -A
  & git diff --cached --quiet 2>&1 | Out-Null
  if ($LASTEXITCODE -eq 0) {
    Write-Host "    Wiki уже актуальна" -ForegroundColor Gray
  } else {
    & git commit -m "Lab 4: 7 wiki pages"
    $wikiBranch = (& git rev-parse --abbrev-ref HEAD).Trim()
    & git push origin $wikiBranch
    if ($LASTEXITCODE -ne 0) { & git push origin master }
  }
  Set-Location $root
  Remove-Item -Recurse -Force $tmp
}

Write-Host ""
Write-Host "Готово. Ссылки:" -ForegroundColor Green
Write-Host "  Репозиторий : https://github.com/$Owner/$Repo"
Write-Host "  GitHub Pages: https://$Owner.github.io/$Repo/"
Write-Host "  Wiki        : https://github.com/$Owner/$Repo/wiki"
Write-Host "  OpenAPI     : https://github.com/$Owner/$Repo/blob/main/api/openapi.yaml"
Write-Host ""
Write-Host "Pages собирается 1-2 минуты; проверьте вкладку Actions и Settings -> Pages." -ForegroundColor Gray
