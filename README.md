
# Setup

## Checkout source

    git clone https://github.com/yukihane/update-scoop-on-azure-functions.git
    cd update-scoop-on-azure-functions/ScoopUpdateFunction/bin/scoop/
    git submodule update -i

## Edit information

Edit `ScoopUpdateFunction/run.ps1`

    Set-Item env:GIT_COMMITTER_NAME "auto-updater"
    Set-Item env:GIT_AUTHOR_NAME "auto-updater"
    Set-Item env:EMAIL "yukihane.feather@gmail.com"
    
    $bucket = "scoop-bucket-yukihane-games"
    $bucketurl = "git@github.com:yukihane/$bucket.git"

## Put ssh private key

Put git-authorized private key as `ScoopUpdateFunction/private/ssh/id_rsa`.

## Archive

    zip -r ../deployment.zip ScoopUpdateFunction host.json

## Deploy

    az functionapp deployment source config-zip -n <app_name> -g <group_name> --src ../deployment.zip
