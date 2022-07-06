Add-Type -assembly System.Windows.Forms
$main_form = New-Object System.Windows.Forms.Form
$main_form.Text ='V Rising Dedicated Server Installation'
$main_form.Width = 600
$main_form.Height = 400
$main_form.AutoSize = $true

$Button = New-Object System.Windows.Forms.Button
$Button.Location = New-Object System.Drawing.Size(100,10)
$Button.Size = New-Object System.Drawing.Size(320,23)
$Button.Text = "Select Installation Directory"
$main_form.Controls.Add($Button)
$Button.Add_Click(
    {
        $shell = New-Object -ComObject Shell.Application
        $selectedfolder = $shell.BrowseForFolder( 0, 'Select a folder to proceed', 16, $shell.NameSpace( 17 ).Self.Path ).Self.Path
        return $selectedfolder
    }
)

$Label2 = New-Object System.Windows.Forms.Label
$Label2.Text = $selectedfolder
$Label2.Location  = New-Object System.Drawing.Point(0,40)
$Label2.AutoSize = $true
$main_form.Controls.Add($Label2)

# This needs to be last
$main_form.ShowDialog()