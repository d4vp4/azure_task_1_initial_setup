# Read the artifacts file
$artifactsPath = "artifacts.json"

if (-not (Test-Path $artifactsPath)) {
    Write-Error "artifacts.json not found!"
    exit 1
}

$artifacts = Get-Content $artifactsPath | ConvertFrom-Json

# Check if resourcesTemplate exists
if (-not $artifacts.resourcesTemplate) {
    Write-Error "resourcesTemplate key is missing in artifacts.json"
    exit 1
}

# Validate the URL
try {
    $request = Invoke-WebRequest -Method Head -Uri $artifacts.resourcesTemplate -ErrorAction Stop
    if ($request.StatusCode -eq 200) {
        Write-Output "Validation successful: Template URL is reachable."
    } else {
        Write-Error "Validation failed: URL returned status code $($request.StatusCode)"
        exit 1
    }
}
catch {
    Write-Error "Validation failed: Could not reach the template URL. Error: $_"
    exit 1
}