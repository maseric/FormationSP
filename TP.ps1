# COM client object model
# But du TP : convertir en PDF toutes les versions des documents word d'une liste
# Ajout contexte Sharepoint
Add-PSSnapin "Microsoft.Sharepoint.Powershell"
Write-Host -ForegroundColor DarkYellow "... DEBUT"
Write-Host -ForegroundColor DarkYellow "... Snapin Sharepoint chargé"


$listName="DOCS"
$workdir="C:\Temp\workdir"



#-------------------------------------------------------------
# fonction conversion PDF
function ConvertWordToPdf([string]$WordFileName)
{    
    Try 
    { 
        $PdfWordFileName = [System.IO.Path]::GetDirectoryName($WordFileName) + "/" + [System.IO.Path]::GetFileNameWithoutExtension($WordFileName) + ".pdf"

        Add-type -AssemblyName Microsoft.Office.Interop.Word
		$wdApplication = New-Object -ComObject "Word.Application"

        $wdExportFormat = [Microsoft.Office.Interop.Word.WdExportFormat]::wdExportFormatPDF
        $OpenAfterExport = $false
        $wdExportOptimizeFor = [Microsoft.Office.Interop.Word.WdExportOptimizeFor]::wdExportOptimizeForOnScreen
        $wdExportItem = [Microsoft.Office.Interop.Word.WdExportItem]::wdExportDocumentContent
        $IncludeDocProps = $true
        $KeepIRM = $true
        $wdExportCreateBookmarks = [Microsoft.Office.Interop.Word.WdExportCreateBookmarks]::wdExportCreateWordBookmarks
        $DocStructureTags = $true
        $BitmapMissingFonts = $true
        $UseISO19005_1 = $false
        $wdExportRange = [Microsoft.Office.Interop.Word.WdExportRange]::wdExportAllDocument
        $wdStartPage = 0
		$wdEndPage = 0

        $wdDocument = $wdApplication.Documents.Open($WordFileName) 

        $wdDocument.ExportAsFixedFormat($PdfWordFileName,$wdExportFormat,$OpenAfterExport, $wdExportOptimizeFor,$wdExportRange,$wdStartPage,$wdEndPage,$wdExportItem,$IncludeDocProps, 
        $KeepIRM,$wdExportCreateBookmarks,$DocStructureTags,$BitmapMissingFonts,$UseISO19005_1) 
     
        Stop-Process -Name *WORD*
        [void][System.Runtime.InteropServices.Marshal]::ReleaseComObject($wdDocument) 
    } 
    Catch 
    { 
        $exception_message = $_.Exception.message

        Write-Host $exception_message
    }
}
#-------------------------------------------------------------

# on recupere un site
Write-Host -ForegroundColor DarkYellow "  ... Sélection site Intranet"
$web=Get-SPWeb -Identity http://srv2016
# on recuepre une liste
Write-Host -ForegroundColor DarkYellow "    ... Sélection liste DOCS"
$listName="DOCS"
$workdir="C:\Temp\workdir"


$list=$web.Lists[$listName]
$folder=$web.GetFolder($list.RootFolder.Url)

Write-Host -ForegroundColor DarkYellow "      ... Récupération fichiers"

$remoteFiles=$folder.Files

    #--------------------------------
    #/!\ WARNING : pas utiliser foreach car on ne peut pas modifier une collection pendant qu'on l'énumère    
    #--------------------------------
    for($i=0;$i -lt $remoteFiles.Count;$i++) # boucle sur fichiers
    {
        $file=$remoteFiles[$i]
        $extension=[System.IO.Path]::GetExtension($file).Tolower()
        $baseName=[System.IO.Path]::GetFileNameWithoutExtension($file)
        
        
        if($extension -eq ".docx")
        {
            # Write-Host -ForegroundColor DarkYellow "        ... Boucle sur fichier $($file.Name)"
            $versions=$file.Versions
            Write-Host -ForegroundColor DarkYellow "        ... Boucle sur fichier $($file.Name) : $($versions.Count +1 ) versions"
            
            for($j=0; $j -lt $versions.Count; $j++) # boucle sur versions            
            {
                $version=$versions[$j]
                #$version.VersionLabel
                #$file.Name+$version.VersionLabel
                $versionName=$baseName + "." + $version.VersionLabel + $extension
                $tempFileName=$workdir+"\"+$versionName
                $pdfFilePath=$workdir+"\"+$baseName + "." + $version.VersionLabel + ".pdf"
                $pdfFileName=$baseName + "." + $version.VersionLabel + ".pdf"

                Write-Host -ForegroundColor DarkYellow "          ... Download de la version $($versionName)"
           
               
                $bytes=$version.OpenBinary()
				#Write-Host -ForegroundColor DarkYellow "          ... Ecriture fichier $($workdir+"\"+$versionName)"
                [System.IO.File]::WriteAllBytes($tempFileName,$bytes)
                
                ConvertWordToPdf($workdir+"\"+$versionName)
                Write-Host -ForegroundColor DarkYellow "          ... Conversion en PDF"

                $pdfFile=Get-ChildItem -Path $pdfFilePath
                
                Write-Host -ForegroundColor DarkYellow "          ... Upload du PDF $pdfFileName"
                try{
                    $remoteFiles.Add($pdfFileName, $pdfFile.OpenRead(), $true)
                }
                catch [System.Exception]
                {
                   Write-Host -f Red $_.ErroMessage
                }
            
            
            } # boucle sur versions

            # gestion version contenue dans le fichier lui même
            #--------------------------------

            Write-Host -ForegroundColor DarkYellow "@@@       ... Gestion de la version actuelle"
            $version=$file
            
            $versionName=$baseName + "." + $version.UIVersionLabel + $extension
            $tempFileName=$workdir+"\"+$versionName
            $pdfFilePath=$workdir+"\"+$baseName + "." + $version.UIVersionLabel + ".pdf"
            $pdfFileName=$baseName + "." + $version.UIVersionLabel + ".pdf"
            
            Write-Host -ForegroundColor DarkYellow "          ... Download de la version $($versionName)"

            $bytes=$version.OpenBinary()
			#Write-Host -ForegroundColor DarkYellow "          ... Ecriture fichier $($workdir+"\"+$versionName)"
            [System.IO.File]::WriteAllBytes($tempFileName,$bytes)
                
            ConvertWordToPdf($workdir+"\"+$versionName)
            Write-Host -ForegroundColor DarkYellow "          ... Conversion en PDF"

            $pdfFile=Get-ChildItem -Path $pdfFilePath
                
            Write-Host -ForegroundColor DarkYellow "          ... Upload du PDF $pdfFileName"
            try{
                $remoteFiles.Add($pdfFileName, $pdfFile.OpenRead(), $true)
            }
            catch [System.Exception]
            {
                Write-Host -f Red $_.ErroMessage
            }

            #--------------------------------


        }
        


   
    } #FIN boucle sur fichiers
    #--------------------------------
