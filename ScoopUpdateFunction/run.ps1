$approot="${env:HOME}/site/wwwroot/ScoopUpdateFunction"

Write-Output "${env:Home}"
Write-Output "PowerShell Timer trigger function executed at:$(get-date)";

iex "$approot/bin/git/cmd/git.exe --version"
