#region Function Module Members
# Dot source all .ps1-files 
if ($PSScriptRoot -eq $Null) {
    $ScriptRoot = (Resolve-Path $MyInvocation.MyCommand.Path).Path
} else {
    $ScriptRoot = $PSScriptRoot
}
Get-ChildItem -Path "$ScriptRoot\Functions" -Include *.ps1 -Recurse | Foreach-Object { 
    . $_.FullName 
}

Export-ModuleMember -Function @( Get-ChildItem "$ScriptRoot\Functions" -Include '*.ps1' -Recurse | ForEach-Object {
    $_.Name -replace ".ps1" } )

#endregion