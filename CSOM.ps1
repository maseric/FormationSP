#CSOM
# premier TP CSOM
# on reference les dll Sharepoint
Add-Type -Path "C:\SP\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\SP\Microsoft.SharePoint.Client.Runtime.dll"

$context=New-Object Microsoft.Sharepoint.Client.ClientContext("http://srv2016")
#$context.Credentials=New-Object System.net.NetworkCredentials("DM", "Adminstrateur", "*Ckv43#")
$web=$context.Web
$list=$web.Lists.GetByTitle('DOCS')
 

# on demande a charger l'objet list
$context.Load($list)
# on effectue le chargement
$context.ExecuteQuery()

# on peut requeter le nb d'éléments dans la liste
$list.ItemCount
$web.Title

