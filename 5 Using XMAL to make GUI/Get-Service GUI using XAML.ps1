Add-Type -AssemblyName PresentationFramework 

$XamlFile = "C:\Users\cmsmith5\PowerShell\MainWindow.xaml"

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

Get-Service  | ForEach-Object {$var_ddlServices.Items.Add($_.Name)}

function GetServiceDetails{
    $ServiceName = $var_ddlServices.SelectedItem
    $details = Get-Service -Name $ServiceName | select displayname,status
    $var_lblName.Content = $details.displayname
    $var_lblStatus.Content = $details.status

    if ($var_lblStatus.Content -eq 'Running'){
        $var_lblStatus.Foreground='green'
        }else{
            $var_lblStatus.Foreground='red'
        }
}

$var_ddlServices.Add_SelectionChanged({GetServiceDetails})

$psform.ShowDialog()



