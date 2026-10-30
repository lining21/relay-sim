$ErrorActionPreference = 'Stop'

$env:PROTECT_PASSWORD = Read-Host 'Enter the site access password'
node scripts/encrypt-pages.mjs
Remove-Item Env:\PROTECT_PASSWORD
