If ($null -eq (Get-LocalUser -Name "lapsadmin")){
  New-LocalUser -AccountNeverExpires:$true -Password ( ConvertTo-SecureString -AsPlainText -Force 'TempPassword123!') -Name 'lapsadmin' | Add-LocalGroupMember -Group administrators
}
