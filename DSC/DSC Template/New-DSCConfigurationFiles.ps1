#Region MachineConfigurationData
# Reads all the psd1 files in the Configuration\Servers folder and constructs the ConfigData Object
$ConfigFiles = Get-ChildItem .\Configuration\Servers -Filter *.psd1 -Recurse
$ConfigData = @{ AllNodes = @() }
foreach ($ConfigFile in $ConfigFiles)
{
    $ConfigData.AllNodes += (Get-Content $ConfigFile.FullName | Out-String | Invoke-Expression)
}
#EndRegion

Configuration ParentConfiguration
{
#Import-DscResource -Module xNetworking
Node $AllNodes.Where({ $_.Role -contains 'ServerTypeA' }).NodeName
    {
        Log LogServerTypeA {
            Message = "Executing for ServerTypeA"
        }
    }
Node $AllNodes.Where({ $_.Role -contains 'ServerTypeB' }).NodeName
    {
        Log LogServerTypeB {
            Message = "Executing for ServerTypeB"
        }
    }
Node $AllNodes.NodeName
    {
        Log LogAllServerTypes {
            Message = "Executing for AllServerTypes"
        }
    }

}
ParentConfiguration -ConfigurationData $ConfigData 