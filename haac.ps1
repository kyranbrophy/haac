########################################
#                                      #
#      Horizon Audio Auto Config       #
#                                      #
########################################

# Author:             Kyran Brophy
# Description:        On log in and reconnect, determine the display protocol and set the appropriate default audio drivers
# Release History:
# - 1.0: 24/03/2020: Initial release
# - 1.1: 25/03/2020: Add support for Mac* Client Type; a different device set is required for Mac's

# Start
Try {
    # Declarations
    $clientType=(Get-ChildItem Env:ViewClient_Type).Value
    $displayProtocol=(Get-ChildItem Env:ViewClient_Protocol).Value
    
    If ($clientType -like "Mac*") {
        # Client Type is Mac (any version), needs a mismatached Microphone default setting
        If ($displayProtocol -eq "PCOIP") {
            # Display protocol is PCoIP, set the audio input device to 'VMware Virtual Microphone' and output device to 'Teradici Virtual Audio Driver'
            Start-Process -FilePath "C:\Program Files\haac\nircmd.exe" -ArgumentList "setdefaultsounddevice `"Speakers (Teradici)`" 1"
            Start-Process -FilePath "C:\Program Files\haac\nircmd.exe" -ArgumentList "setdefaultsounddevice `"Speakers (Teradici)`" 2"
            Start-Process -FilePath "C:\Program Files\haac\nircmd.exe" -ArgumentList "setdefaultsounddevice `"Microphone Array`" 1"
            Start-Process -FilePath "C:\Program Files\haac\nircmd.exe" -ArgumentList "setdefaultsounddevice `"Microphone Array`" 2"
        } Else {
            # Display protocol is Blast, set the audio input device to 'VMware Virtual Microphone' and the output device to 'Teradici Virtual Audio Driver'
            Start-Process -FilePath "C:\Program Files\haac\nircmd.exe" -ArgumentList "setdefaultsounddevice `"Speakers`" 1"
            Start-Process -FilePath "C:\Program Files\haac\nircmd.exe" -ArgumentList "setdefaultsounddevice `"Speakers`" 2"
            Start-Process -FilePath "C:\Program Files\haac\nircmd.exe" -ArgumentList "setdefaultsounddevice `"Microphone Array`" 1"
            Start-Process -FilePath "C:\Program Files\haac\nircmd.exe" -ArgumentList "setdefaultsounddevice `"Microphone Array`" 2"
        }
    } Else {
        # Client Type is anything other than Mac, incl. Windows, TERA2, Wyse
        If ($displayProtocol -eq "PCOIP") {
        # Display protocol is PCoIP, set the audio input and output device to 'Teradici Virtual Audio Driver'
            Start-Process -FilePath "C:\Program Files\haac\nircmd.exe" -ArgumentList "setdefaultsounddevice `"Speakers (Teradici)`" 1"
            Start-Process -FilePath "C:\Program Files\haac\nircmd.exe" -ArgumentList "setdefaultsounddevice `"Speakers (Teradici)`" 2"
            Start-Process -FilePath "C:\Program Files\haac\nircmd.exe" -ArgumentList "setdefaultsounddevice `"Microphone`" 1"
            Start-Process -FilePath "C:\Program Files\haac\nircmd.exe" -ArgumentList "setdefaultsounddevice `"Microphone`" 2"
        } Else {
            # Display protocol is Blast, set the audio input device to 'VMware Virtual Microphone' and the output device to 'VMware Virtual Audio (DevTap)'
            Start-Process -FilePath "C:\Program Files\haac\nircmd.exe" -ArgumentList "setdefaultsounddevice `"Speakers`" 1"
            Start-Process -FilePath "C:\Program Files\haac\nircmd.exe" -ArgumentList "setdefaultsounddevice `"Speakers`" 2"
            Start-Process -FilePath "C:\Program Files\haac\nircmd.exe" -ArgumentList "setdefaultsounddevice `"Microphone Array`" 1"
            Start-Process -FilePath "C:\Program Files\haac\nircmd.exe" -ArgumentList "setdefaultsounddevice `"Microphone Array`" 2"
        }
    }
} Catch {
    # Something went wrong, write the error output to the Application Event Log as a Warning
    $errormessage=$error[0].ToString() + $error[0].InvocationInfo.Line
    Write-EventLog -LogName "Application" -Source "VMware View" -EventID 0 -EntryType Warning -Message $errormessage
} Finally {
    # All good, write the status to the Application Event Log as Information
    Write-EventLog -LogName "Application" -Source "VMware View" -EventID 0 -EntryType Information -Message "Display Protocol: $displayProtocol, Client Type: $clientType."
}