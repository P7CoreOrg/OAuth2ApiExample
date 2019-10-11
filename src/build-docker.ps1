Param
(
    [string] $version,
    [string] $acrName        = 'p7coredockerhub',
    [string] $acrLoginServer = "p7coredockerhub.azurecr.io"
)

Write-Host $version


Write-Host "Script:" $PSCommandPath
Write-Host "Path:" $PSScriptRoot

Set-Location -Path  $PSScriptRoot

function Run-Script
{
	param([string]$script)
	$ScriptPath = "$PSScriptRoot\$script.ps1"
	& $ScriptPath
}

$Time = [System.Diagnostics.Stopwatch]::StartNew()

function PrintElapsedTime {
    Log $([string]::Format("Elapsed time: {0}.{1}", $Time.Elapsed.Seconds, $Time.Elapsed.Milliseconds))
}

function Log {
    Param ([string] $s)
    Write-Output "###### $s"
}

function Check {
    Param ([string] $s)
    if ($LASTEXITCODE -ne 0) { 
        Log "Failed: $s"
        throw "Error case -- see failed step"
    }
}


$DockerOS = docker version -f "{{ .Server.Os }}"
write-host DockerOs:$DockerOS 
$BaseBuildImageName = "oauth2apiexample/base-build"
$Dockerfile = "Dockerfile"

PrintElapsedTime

Log "Build application image"
# docker build --no-cache --pull -t $BaseBuildImageName -f $PSScriptRoot/$Dockerfile --build-arg Version=$version .
PrintElapsedTime
Check "docker build (application)"

function DockerBuild {
    Param 
    (
        [string] $dockerFile,
        [string] $localRepo,
        [string] $imageName,
        [string] $version,
        [string] $acrLoginServer
    )

    $latestDockerImage = "$($localRepo)/$($imageName):latest"
    docker build -f $dockerFile  -t $latestDockerImage .
    $versionDockerImage = "$($localRepo)/$($imageName):$($version)"
    docker tag $dockerImage $versionDockerImage

    $acrLoginServerLatestDockerImage  = "$($acrLoginServer)/$($imageName):latest"
    $acrLoginServerVersionDockerImage = "$($acrLoginServer)/$($imageName):$($version)"
    
    docker tag $latestDockerImage $acrLoginServerLatestDockerImage
    docker tag $latestDockerImage $acrLoginServerVersionDockerImage

    docker push $acrLoginServerLatestDockerImage
    docker push $acrLoginServerVersionDockerImage
}

az acr login --name $acrName
DockerBuild -dockerFile "./SecuredApiApp22/Dockerfile" -localRepo "oauth2apiexample" -imageName "secured-api-app22" -version $version -acrLoginServer $acrLoginServer
DockerBuild -dockerFile "./SecuredApiApp3/Dockerfile"  -localRepo "oauth2apiexample" -imageName  "secured-api-app3" -version $version -acrLoginServer $acrLoginServer

docker images  oauth2apiexample/*

