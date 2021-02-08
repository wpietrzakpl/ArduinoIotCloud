<#
.SYNOPSIS
    Set Arduino Iot Cloud Configuration File.
.DESCRIPTION
    This function preparing config file for Arduino Iot Cloud API.
.PARAMETER ClientId
    Client Id, you can find Client Id in Integration Section at your Arduino Iot Client website.
.PARAMETER ClientSecret
    Client Secret, you can find client secret during creation of new API Key, or you saved previous one and remember. 
.EXAMPLE
    PS C:\Users\Wojtek> Set-ArduinoIotCloudCredentials -ClientId 'dsahu2uh2uh32gt43tf434t' -ClientSecret 'sdasg3123hg3t1ftf21t3'
    This example show how to set Arduino Iot Cloud config file
.INPUTS
    None
.OUTPUTS
    None
.NOTES
    Wojtek 02/2021
#>

function Set-ArduinoIotCloudCredentials {
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true)]
        [string]$ClientId,
        [parameter(Mandatory = $true)]
        [string]$ClientSecret
    )
    
    begin {

        if ($IsLinux) {
            $ConfigFile = "Configuration.json"
            $ConfigPath = "$env:HOME/.config/ArduinoIotCloud\"
            $Config = Join-Path -Path $ConfigPath -ChildPath $ConfigFile
        } else {
            $ConfigFile = "Configuration.json"
            $ConfigPath = "$env:LOCALAPPDATA\ArduinoIotCloud\"
            $Config = Join-Path -Path $ConfigPath -ChildPath $ConfigFile
        }

        if (!(Test-Path $ConfigPath)) {
            New-Item -Path $ConfigPath -ItemType Directory | Out-Null
        } else {
            try {
                Remove-Item -Path $Config -ErrorAction Stop    
            } catch {
                
            }
        }
    }

    process {
        $ClientIdSS = ConvertTo-SecureString -String $ClientId -AsPlainText -Force 
        $ClientSecretSS = ConvertTo-SecureString -String $ClientSecret -AsPlainText -Force 
        
        $ClientIdEncrypt = ConvertFrom-SecureString -SecureString $ClientIdSS
        $ClientSecretEncrypt = ConvertFrom-SecureString -SecureString $ClientSecretSS
    }
    
    end {
        $ConfigHash = [ordered]@{
            'ClientId'   = $ClientIdEncrypt
            'ClientSecret'  = $ClientSecretEncrypt
        }
        $ConfigHash | ConvertTo-Json | Out-File -FilePath $Config
    }
}