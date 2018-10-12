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
