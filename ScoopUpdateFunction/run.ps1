# $approot="${env:HOME}/site/wwwroot/ScoopUpdateFunction"
$approot = $EXECUTION_CONTEXT_FUNCTIONDIRECTORY
$tempdir = "${env:TEMP}"

$bucket = "scoop-bucket-yukihane-games"
$bucketurl = "git@github.com:yukihane/$bucket.git"

# cacheディレクトリ決定のために必要
Set-Item env:SCOOP "$tempdir/tmp_scoop"
# scoop本体があるディレクトリ
$scooproot = "$approot/bin/scoop"

Set-Item env:PATH "$env:PATH;$approot/bin/git/cmd;$approot/bin/git/usr/bin"
$id_rsa = "$approot/private/ssh/id_rsa" -replace "\\", "/"
$ssh_config = "$approot/private/ssh/ssh_config" -replace "\\", "/"
Set-Item env:GIT_SSH_COMMAND "ssh -i $id_rsa -F $ssh_config"
$gitconfig = "$approot/private/gitconfig" -replace "\\", "/"
Set-Item env:GIT_CONFIG $gitconfig

Set-Location "$tempdir"
Invoke-Expression "git clone $bucketurl"
$bucketdir = "$tempdir/$bucket"
Set-Location "$bucketdir"



. "$scooproot/lib/manifest.ps1"

$checkver = "$scooproot/bin/checkver.ps1"

$dir = "."


Get-ChildItem $dir -Filter "*.json"  | ForEach-Object {

    $app = $_.BaseName
    Invoke-Expression -Command "$checkver -app $app -dir $dir -update true"

    $file = "$_.FullName"
    $json = parse_json $file
    $version = $json.version

    Invoke-Expression git commit $file -m "${app}: Update to version $version"
}

Invoke-Expression git push
