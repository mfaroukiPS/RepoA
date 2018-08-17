function Write-Log {
     [CmdletBinding()]
     param(
         [Parameter()]
         [ValidateNotNullOrEmpty()]
         [string]$Message,
 
         [Parameter()]
         [ValidateNotNullOrEmpty()]
         [ValidateSet('Information','Warning','Error')]
         [string]$Severity = 'Information'
     )
 
     [pscustomobject]@{
         Time = (Get-Date -f g)
         Message = $Message
         Severity = $Severity
     } | Export-Csv -Path ".\LogFile.csv" -Append -NoTypeInformation
 }
  
 Export-ModuleMember Write-Log
 
 #Write-Log -Message 'Foo was $true' -Severity Information
 #Write-Log -Message 'Foo was $true' -Severity Information