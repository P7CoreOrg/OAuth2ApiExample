Param
(
$version
)
Write-Host $version


Write-Host "Script:" $PSCommandPath
Write-Host "Path:" $PSScriptRoot

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
docker build --no-cache --pull -t $BaseBuildImageName -f $PSScriptRoot/$Dockerfile --build-arg Version=$version .
PrintElapsedTime
Check "docker build (application)"

docker build -f ./SecuredApiApp3/Dockerfile -t oauth2apiexample/secured-api-app3 .
docker build -f ./SecuredApiApp22/Dockerfile -t oauth2apiexample/secured-api-app22 .
