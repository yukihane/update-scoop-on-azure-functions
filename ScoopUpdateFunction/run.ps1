# $approot="${env:HOME}/site/wwwroot/ScoopUpdateFunction"
$approot = $EXECUTION_CONTEXT_FUNCTIONDIRECTORY
$tempdir = "${env:TEMP}"

$bucket = "scoop-bucket-yukihane-games"
$bucketurl = "git@github.com:yukihane/$bucket.git"

# cacheディレクトリ決定のために必要
Set-Item env:SCOOP "$tempdir/tmp_scoop"
# scoop本体があるディレクトリ
$scooproot = "$approot/bin/scoop"

$git = "$approot/bin/git/cmd/git.exe"
$ssh = "$approot/bin/git/usr/bin/ssh.exe"

Set-Item env:GIT_SSH_COMMAND "$ssh -i $approot/private/ssh/id_rsa"
Set-Item env:GIT_CONFIG "$approot/private/gitconfig"

Set-Location "$tempdir"
Invoke-Expression $git clone $bucketurl
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

    Invoke-Expression $git commit $file -m "${app}: Update to version $version"
}

Invoke-Expression $git push
