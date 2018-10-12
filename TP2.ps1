# COM client object model
# But du TP : uploader les fichiers d'un répertoire windows dans une liste
# Ajout contexte Sharepoint
Add-PSSnapin "Microsoft.Sharepoint.Powershell"
Write-Host -ForegroundColor DarkYellow "... DEBUT"
Write-Host -ForegroundColor DarkYellow "... Snapin Sharepoint chargé"

<#
$web=Get-SPWeb -Identity http://srv2016
$list=$web.GetFolder("TP2")
$list.add
$remoteFiles=$list.Files
$remoteFiles.Add()

foreach($file in Get-ChildItem -Path "c:\repTravail")
{
    $file|select Name, PSIsContainer

    if(!$file.PSIsContainer)
    {
        Write-Host -ForegroundColor DarkYellow "    ... Fichier $($file.Name)"  
        $fStream=$file.OpenRead()
    }
    else
    {
        Write-Host -ForegroundColor DarkYellow "    ... Dossier $($file.Name) : skipping"  
    }
}
#>

function uploadChmuche($WebName, $ListName, $Path)
{
    Write-Host -ForegroundColor DarkYellow "  ... Sélection site Intranet $WebName"
    $web=Get-SPWeb -Identity $WebName
    #--------------------------------
    Write-Host -ForegroundColor DarkYellow "    ... Sélection liste $ListName"    
    $list=$web.Lists[$ListName]
    $folder=$web.GetFolder($ListName)
    $remoteFiles=$folder.Files

    #--------------------------------
    
    foreach($file in Get-ChildItem -Path $Path -Recurse)
    {
        #$file|select Name, PSIsContainer

        if(!$file.PSIsContainer)
        {
            Write-Host -ForegroundColor DarkYellow "    ... Traitement Fichier $($file.Name)" 
            try
            {
                $remoteFiles.Add("$ListName/$($file.Name)", $file.OpenRead(), $true)

            }
            catch [System.Exception]
            {
                $_.ErroMessage
            }
          
        }
        else
        {
            try
            {
            Write-Host -ForegroundColor DarkYellow "    ... Dossier $($file.Name) : skipping"  
            
            #$list.AddItem("", [Microsoft.SharePoint.SPFileSystemObjectType]::Folder, $file.Name)
            #$list.Update()
            }
            catch [System.Exception]
            {
               Write-Host -f Red $_.ErroMessage
            }
            
        }
    }
    #--------------------------------
    <#
    Write-Host -ForegroundColor DarkYellow "    ... Commit"  
    $field.Update()
    #--------------------------------
    #verif
    Write-Host -ForegroundColor DarkYellow "    ... Vérification : le champ `"$FieldName`".ReadOnlyField : ${$field.ReadOnlyField}"  
    
    #--------------------------------
    #>
}




uploadChmuche -WebName "http://Srv2016" -ListName "TP2" -Path "c:\repTravail"



