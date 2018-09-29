Set-Item env:GIT_COMMITTER_NAME "auto-updater"
Set-Item env:GIT_AUTHOR_NAME "auto-updater"
Set-Item env:EMAIL "yukihane.feather@gmail.com"

$bucket = "scoop-bucket-yukihane-games"
$bucketurl = "git@github.com:yukihane/$bucket.git"

# $approot="${env:HOME}/site/wwwroot/ScoopUpdateFunction"
$approot = $EXECUTION_CONTEXT_FUNCTIONDIRECTORY
$tempdir = "${env:TEMP}"

# cacheディレクトリ決定のために必要
Set-Item env:SCOOP "$tempdir/tmp_scoop"
# scoop本体があるディレクトリ
$scooproot = "$approot/bin/scoop"

Set-Item env:PATH "$env:PATH;$approot/bin/git/cmd;$approot/bin/git/usr/bin"
$id_rsa = "$approot/private/ssh/id_rsa" -replace "\\", "/"
$ssh_config = "$approot/config/ssh_config" -replace "\\", "/"
Set-Item env:GIT_SSH_COMMAND "ssh -i $id_rsa -F $ssh_config"

Set-Location "$tempdir"
if (Test-Path $bucket) {
    Remove-Item $bucket -Force -Recurse
}
Invoke-Expression "git clone $bucketurl"
$bucketdir = "$tempdir/$bucket"
Set-Location "$bucketdir"



. "$scooproot/lib/manifest.ps1"

$checkver = "$scooproot/bin/checkver.ps1"

$dir = "."

Get-ChildItem $dir -Filter "*.json"  | ForEach-Object {

    $app = $_.BaseName
    Invoke-Expression "$checkver -app $app -dir $dir -update true"

    $file = "$_"
    $json = parse_json $file
    $version = $json.version

    Invoke-Expression "git commit $file -m `"${app}: Update to version $version`""
}

Invoke-Expression "git push"
