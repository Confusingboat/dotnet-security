param ([switch] $RebuildAll, [bool] $IsArm = $false, [bool] $CleanBeforeBuild = $true)

Push-Location "$PSScriptRoot/../src/go"

if($CleanBeforeBuild)
{
	Remove-Item -r -fo bin -ea SilentlyContinue
}

$lib_name = "ProtonSecurity"

$env:GOFLAGS = "-trimpath"
$env:CGO_ENABLED = "1"
$env:CGO_LDFLAGS = "-s -w"
$env:GOOS = "windows"

$env:GOARCH = if($IsArm) { "arm64" } else { "amd64" }
$pathArch = if($IsArm) { "win-arm64" } else { "win-x64" }

$outputPath = "bin/runtimes/$pathArch/native/$lib_name.dll"
write-host "Building to `"$(get-location)/$outputPath`""
$buildCommand = "go build -buildmode=c-shared -v -o `"$outputPath`""
if ($RebuildAll) {
	$buildCommand += " -a"
}

Invoke-Expression $buildCommand

Pop-Location