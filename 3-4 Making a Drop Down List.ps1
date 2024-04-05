Add-Type -AssemblyName System.Windows.Forms

$FormObject = [System.Windows.Forms.Form]
$LabelObject = [System.Windows.Forms.Label]
$ComboBoxObject = [System.Windows.Forms.ComboBox]
 
$DefaultFont='Verdana,12'


 ##Set up base form
$AppForm = New-Object $FormObject
$AppForm.ClientSize='800,300'
$AppForm.Text='JackedProgrammer - Service Inspector'
$AppForm.BackColor="#ffffff"
$AppForm.Font = $DefaultFont

#Building the form
$lblService = New-Object $LabelObject
$lblService.Text = 'Services :'
$lblService.AutoSize = $true
$lblService.Location = New-Object System.Drawing.Point(20,20)

$ddlService = New-Object $ComboBoxObject
$ddlService.Width = '300'
$ddlService.Location = New-Object System.Drawing.Point(125,20)

#Load the drop down list for services
Get-Service | ForEach-Object {$ddlService.Items.Add($_.Name)}
<# another way to do the code above
$Services = Get-Service
foreach($service in $Services){
    $ddlService.Items.Add($service.name)
}
#>

$ddlService.text = 'Pick a service'

$lblForName = New-Object $LabelObject
$lblForName.Text = 'Service Friendly Name :'
$lblForName.AutoSize = $true
$lblForName.Location = New-Object System.Drawing.Point(20,80)

$lblName = New-Object $LabelObject
$lblName.Text = ''
$lblName.AutoSize = $true
$lblName.Location = New-Object System.Drawing.Point(240,80)

$lblForStatus = New-Object $LabelObject
$lblForStatus.Text = 'Status :'
$lblForStatus.AutoSize = $true
$lblForStatus.Location = New-Object System.Drawing.Point(20,120)

$lblStatus = New-Object $LabelObject
$lblStatus.Text = ''
$lblStatus.AutoSize = $true
$lblStatus.Location = New-Object System.Drawing.Point(240,120)

$AppForm.Controls.AddRange(@($lblService,$ddlService,$lblForName,$lblName,$lblForStatus,$lblStatus))

##Logic Section/Function

Get-Service | ForEach-Object {$ddlService.Items.Add($_.Name)}

function GetServiceDetails{
    $ServiceName = $ddlService.SelectedItem
    $details = Get-Service -Name $ServiceName | select displayname,status
    $lblName.Text = $details.displayname
    $lblStatus.Text = $details.status

    if ($lblStatus.Text -eq 'Running'){
        $lblStatus.ForeColor='green'
        }else{
            $lblStatus.ForeColor='red'
        }
}
##Add the Functions to the form

$ddlService.Add_SelectedIndexChanged({GetServiceDetails})

#Displays the form
$AppForm.ShowDialog()

##Cleans up the form
$AppForm.Dispose()


