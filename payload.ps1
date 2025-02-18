# Display a dialog box with the "You are hacked!" message
Add-Type -AssemblyName PresentationFramework
[System.Windows.MessageBox]::Show('You are hacked!', 'Warning', 'OK', 'Error')
