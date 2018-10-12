#OM
# But du TP : passer un champ de liste en mode read-only
# Ajout contexte Sharepoint
Add-PSSnapin "Microsoft.Sharepoint.Powershell"
Write-Host -ForegroundColor DarkYellow "... DEBUT"
Write-Host -ForegroundColor DarkYellow "... Snapin Sharepoint chargé"

# on recupere un site
Write-Host -ForegroundColor DarkYellow "  ... Sélection site Intranet"
$web=Get-SPWeb -Identity http://srv2016
# on recuepre une liste
Write-Host -ForegroundColor DarkYellow "    ... Sélection liste TP1"
$List=$web.Lists["TP1"]


# intropspection des champs d'une liste
#$List.Fields | select StaticName, InternalName

Write-Host -ForegroundColor DarkYellow "      ... Ajout d'un item"
$NewItem=$List.AddItem()
$NewItem["Title"]="bonjour la France"
$NewItem["Y_x0020_A_x0020_DES_x0020_ESPACE"]="coin coin"
Write-Host -ForegroundColor DarkYellow "      ... Commit"
$NewItem.Update()
Write-Host -ForegroundColor DarkYellow "      ... Commit terminé"


Write-Host -ForegroundColor DarkYellow "... FIN"
Write-Host -ForegroundColor Blue "Merci, au revoir"



function SetROListField($WebName, $ListName, $FieldName)
{
    Write-Host -ForegroundColor DarkYellow "  ... Sélection site Intranet $WebName"
    $web=Get-SPWeb -Identity $WebName
    #--------------------------------
    Write-Host -ForegroundColor DarkYellow "    ... Sélection liste $ListName"    
    $List=$web.Lists[$ListName]
    #--------------------------------
    Write-Host -ForegroundColor DarkYellow "    ... Sélection Champ $FieldName"    
    $field=$List.Fields|select | ? {$_.InternalName -ceq  $FieldName}
    #--------------------------------
    Write-Host -ForegroundColor DarkYellow "    ... Passage Champ $FieldName en readonly"  
    $field.ReadOnlyField=$true
    #--------------------------------
    Write-Host -ForegroundColor DarkYellow "    ... Commit"  
    $field.Update()
    #--------------------------------
    #verif
    Write-Host -ForegroundColor DarkYellow "    ... Vérification : le champ `"$FieldName`".ReadOnlyField : ${$field.ReadOnlyField}"  
    
    #--------------------------------

}
