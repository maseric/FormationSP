# CSOM
# But du TP : lister les éléments d'une liste dont le nom commence par f
# on reference les dll Sharepoint
Add-Type -Path "C:\SP\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\SP\Microsoft.SharePoint.Client.Runtime.dll"

$context=New-Object Microsoft.Sharepoint.Client.ClientContext("http://srv2016")
#$context.Credentials=New-Object System.net.NetworkCredentials("DM", "Adminstrateur", "*Ckv43#")
$web=$context.Web
<#
$lists=$web.Lists
$context.Load($lists) 
$context.ExecuteQuery()

foreach($list in $lists)
{
    Write-Host "$($list.Title) : $($list.ItemCount) items"

}

#>

# utilisation d'une caml query pour retourner le nb d'élements
<#
$items=$web.Lists.GetByTitle("DOCS").GetItems([Microsoft.sharepoint.client.camlQuery]::CreateAllItemsQuery());
$context.Load($items)
$context.ExecuteQuery()
echo red "nb d'items :  $($items.Count)"

#>

$caml=New-Object Microsoft.sharepoint.client.camlQuery

$caml.ViewXml= "<View>
<Query>
   <Where>
      <BeginsWith>
         <FieldRef Name='FileLeafRef' />
         <Value Type='Text'>f</Value>
      </BeginsWith>
   </Where>
</Query>
</View>"

$items=$web.Lists.GetByTitle("DOCS").GetItems($caml)
$context.Load($items)
$context.ExecuteQuery()

$items.Count


foreach($item in $items)
{
    #$context.Load($items)
    #$context.ExecuteQuery()

    $item.DisplayName

    
}

