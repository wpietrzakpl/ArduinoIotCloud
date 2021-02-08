<#
.SYNOPSIS
    Get Arduino Iot Cloud Configuration File.
.DESCRIPTION
    This function getting data inside Arduino Iot Cloud config file, to use it with other functions
    and show stored values.
.EXAMPLE
    PS C:\Users\Wojtek> Get-ArduinoIotCloudCredentials
    Running script like that, shows you current config data.
.INPUTS
    None
.OUTPUTS
    Function creates PSCustomObject 
.NOTES
    Wojtek 02/2021
#>

function Get-ArduinoIotCloudCredentials {
    [CmdletBinding()]
    param (
        
    )
    
    begin {

        if ($IsLinux) {
            $ArduinoIotCloud = @()
            $ConfigFile = "Configuration.json"
            $ConfigPath = "$env:HOME/.config/ArduinoIotCloud\"
            $Config = Join-Path -Path $ConfigPath -ChildPath $ConfigFile
        } else {
            $ArduinoIotCloud = @()
            $ConfigFile = "Configuration.json"
            $ConfigPath = "$env:LOCALAPPDATA\ArduinoIotCloud\"
            $Config = Join-Path -Path $ConfigPath -ChildPath $ConfigFile 
        }

    }
    
    process {

        if (Test-Path -Path $Config) {
            $ConfigData = Get-Content $Config | ConvertFrom-Json
        
            $ClientIdSS = ConvertTo-SecureString $ConfigData.ClientId
            $ClientSecretSS = ConvertTo-SecureString $ConfigData.ClientSecret
        
            $ClientIdDecrypt = [System.Runtime.InteropServices.marshal]::PtrToStringAuto([System.Runtime.InteropServices.marshal]::SecureStringToBSTR($ClientIdSS))
            $ClientSecretDecrypt = [System.Runtime.InteropServices.marshal]::PtrToStringAuto([System.Runtime.InteropServices.marshal]::SecureStringToBSTR($ClientSecretSS))
            
            $ConfigHash = [ordered]@{
                'ClientId' = $ClientIdDecrypt
                'ClientSecret' = $ClientSecretDecrypt
            }

            $object = New-Object -TypeName PSCustomObject -Property $ConfigHash
            $ArduinoIotCloud += $object 
            
        }
        else {
            Write-Warning -Message "I cannot find Config File, check if you used Set-ArduinoIotCloudCredentials to generate Config"
        }

    }
    
    end {
        $ArduinoIotCloud
    }
}