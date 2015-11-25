# Validate Schema
# XSD generated using http://xmlgrid.net/xml2xsd.html / http://www.freeformatter.com/xsd-generator.html
#
# .\ValidateSchema.ps1 .\Servers.xml
#
# Description
# -----------
# Validates an XML file against its inline provided schema reference
#
# Command line arguments
# ----------------------
# xmlFileName: Filename of the XML file to validate
param([string]$xmlFileName)

# Check if the provided file exists
if((Test-Path -Path $xmlFileName) -eq $false)
{
	Write-Host "XML validation not possible since no XML file found at '$xmlFileName'" -ForegroundColor Red
	exit 2
    
}

# Get the file
$XmlFile = Get-Item($xmlFileName)

# Keep count of how many errors there are in the XML file
$script:errorCount = 0

# Perform the XSD Validation
$readerSettings = New-Object -TypeName System.Xml.XmlReaderSettings
$readerSettings.ValidationType = [System.Xml.ValidationType]::Schema
$readerSettings.ValidationFlags = [System.Xml.Schema.XmlSchemaValidationFlags]::ProcessInlineSchema -bor [System.Xml.Schema.XmlSchemaValidationFlags]::ProcessSchemaLocation
$readerSettings.add_ValidationEventHandler(
{
	# Triggered each time an error is found in the XML file
	Write-Host $("`nError found in XML: " + $_.Message + "`n") -ForegroundColor Red
    $script:errorCount++
});
$reader = [System.Xml.XmlReader]::Create($XmlFile.FullName, $readerSettings)
while ($reader.Read()) { }
$reader.Close()

# Verify the results of the XSD validation
if($script:errorCount -gt 0)
{
	# XML is NOT valid
    Write-Host "Xml is not valid" -ForegroundColor DarkRed
	exit 1
}
else
{
	# XML is valid
	exit 0
    Write-Host "Xml is valid" -ForegroundColor Green
}