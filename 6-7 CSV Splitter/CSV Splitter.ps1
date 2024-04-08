Add-Type -AssemblyName PresentationFramework 

$XamlFile = "C:\Users\cmsmith5\PowerShell\MainWindowCSV.xaml"
$inputXAML = Get-Content -Path $XamlFile -Raw
$inputXAML = $inputXAML -replace 'mc:Ignorable="d"','' -replace "x:N","N" -replace '^<Win.*','<Window'
[XML]$XAML=$inputXAML

$reader = New-Object System.Xml.XmlNodeReader $XAML
try{
    $psform = [Windows.Markup.XamlReader]::Load($reader)
}catch{
    Write-Host $_.Exception
    throw
}

$xaml.SelectNodes("//*[@Name]") | ForEach-Object {
    try{
        Set-Variable -Name var_"$($_.Name)" -value $psform.FindName($_.Name) -ErrorAction Stop
    }catch{
        throw
    }
}

Get-Variable var_*

$var_btnInputFile.Add_Click({
    $inputFilePick = New-Object System.Windows.Forms.OpenFileDialog
    $inputFilePick.ShowDialog()
    $var_txtInputFilePath.Text = $inputFilePick.FileName
})

$var_btnValidate.Add_Click({
    try{
        $sourceCSV = $var_txtInputFilePath.Text
        $CSVData = Import-Csv -Path $sourceCSV -Delimiter $var_txtDelimiter.Text
        $var_lblValid.Content = "Valid : $($CSVData.Count) Lines"
        $Headers = (Get-Content -Path $sourceCSV)[0].split("$($var_txtDelimiter.Text)")

        $HeaderPreview = ""
        $i = 1
        foreach($header in $Headers){
            $HeaderPreview += "Column $1 : $header "
            $1 += 1
        }
        $var_lblHeaders.Content=$HeaderPreview

    }catch{
        $var_lblValid.Content = "Not Valid!"
    }
})


$var_btnOutputFile.Add_Click({
    $OutputFolder = New-Object System.Windows.Forms.FolderBrowserDialog
    $OutputFolder.ShowDialog()
    $var_txtOutputFilePath.Text = $OutputFolder.SelectedPath
})

$var_btnSplit.Add_Click({
    try{
        $var_lstFiles
        $sourceCSV = $var_txtInputFilePath.Text
        $CSVData = Import-Csv -Path $sourceCSV -Delimiter $var_txtDelimiter.Text
        $RowPerFile = $($csvdata.count)/$var_txtNumFiles.Text
        $StartRow=0
        $Counter=1

        While($StartRow -lt $CSVData.count){
            Import-Csv -Path $sourceCSV | select -Skip $StartRow -First $RowPerFile | Export-Csv -Path "$($var_txtOutputFilePath.Text)\ouput-$($Counter).csv" -NoTypeInformation
            $var_lstFiles.Items.Add("$($var_txtOutputFilePath.Text)\ouput-$($Counter).csv was created!")
            $StartRow += $RowPerFile
            $Counter += 1
            $Counter
            }
    }catch{
        $var_lstFiles.Items.Add("Error!")
    }
})


$psform.ShowDialog()
