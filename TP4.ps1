#CSOM creation d'un element
# But du TP : ajout d'un élément dans une liste
$context=New-Object Microsoft.Sharepoint.Client.ClientContext("http://srv2016")
#$context.Credentials=New-Object System.net.NetworkCredentials("DM", "Adminstrateur", "*Ckv43#")
$web=$context.Web

$list=$web.Lists.GetByTitle("TP1")


$ListItemCreationInformation = New-Object Microsoft.SharePoint.Client.ListItemCreationInformation
$NewItem=$list.AddItem($ListItemCreationInformation)
$NewItem['Title']='tutu'
$NewItem["Y_x0020_A_x0020_DES_x0020_ESPACE"]="cui cui"


$NewItem.Update()

$context.ExecuteQuery()