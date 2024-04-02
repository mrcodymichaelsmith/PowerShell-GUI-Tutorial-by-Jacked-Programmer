Add-Type -AssemblyName System.Windows.Forms

$FormObject = [System.Windows.Forms.Form]
$LabelObject = [System.Windows.Forms.Label]
$ButtonObject = [System.Windows.Forms.Button]

$HelloWorldForm = New-Object $FormObject
$HelloWorldForm.ClientSize='500,300'
$HelloWorldForm.Text='Hello World - Tutorial'
$HelloWorldForm.BackColor="#ffffff"


$lbltitle = New-Object $LabelObject
$lbltitle.Text = 'Hello World!'
$lbltitle.AutoSize = $true
$lbltitle.Font = 'Verdana,24,style=Bold'
$lbltitle.Location = New-Object System.Drawing.Point(120,110)

$btnHello = New-Object $ButtonObject
$btnHello.Text = 'Say hello!'
$btnHello.AutoSize = $true
$btnHello.Font = 'Verdana,14'
$btnHello.Location = New-Object System.Drawing.Point(175,180)

$HelloWorldForm.Controls.AddRange(@($lbltitle,$btnHello))

##Logic Section/Function

function SayHello{
    if($lbltitle.Text -eq ''){
        $lbltitle.Text="Hello World!"
    }else{
    $lbltitle.Text=''
    }
}
##Add the Functions to the form
$btnHello.Add_Click({SayHello})

#Displays the form
$HelloWorldForm.ShowDialog()

##Cleans up the form
$HelloWorldForm.Dispose()
