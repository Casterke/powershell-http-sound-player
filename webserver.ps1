$http = [System.Net.HttpListener]::new()
# Hostname and port to listen on
$http.Prefixes.Add("http://localhost:8080/")
# Start the Http Server
$http.Start()

Add-Type -AssemblyName System.Web
# Log ready message to terminal
if ($http.IsListening) {
    write-host "HTTP Server Ready!  " -f 'black' -b 'gre'
    write-host "$($http.Prefixes)" -f 'y'
}

# INFINTE LOOP
# Used to listen for requests
while ($http.IsListening) {
    # Get Request Url
    # When a request is made in a web browser the GetContext() method will return a request object
    $context = $http.GetContext()

    if ($context.Request.HttpMethod -eq 'GET') {
		
		$URL = $context.Request.Url.LocalPath
				

		if($URL -eq "/drumm") {
			# Play a single file
			$Song = New-Object System.Media.SoundPlayer
			$Song.SoundLocation = "$PSScriptRoot\effects\drumm.wav"
			$Song.Play()
        } 
		
		if($URL -eq "/fusion") {
			# Play a single file
			$Song = New-Object System.Media.SoundPlayer
			$Song.SoundLocation = "$PSScriptRoot\effects\fusion.wav"
			$Song.Play()
        }

		
		<#
		# List sound files in the folder and loop trough play
		Get-ChildItem "$PSScriptRoot\effects\" -Filter *.wav | 
		Foreach-Object {

			if($URL.substring(1) -eq $_.BaseName) {
				write-host "Played"
				write-host $_.FullName
				# Play a single file
				$Song = New-Object System.Media.SoundPlayer
				$Song.SoundLocation = $_.FullName
				$Song.Play()
				
			}

		}
		#>

        # We can log the request to the terminal
        write-host "$($context.Request.UserHostAddress)  =>  $($context.Request.Url)" -f 'mag'

        $ContentStream = [System.IO.File]::OpenRead( "$PSScriptRoot\index.html" );
        $Context.Response.ContentType = [System.Web.MimeMapping]::GetMimeMapping("$PSScriptRoot\index.html")
        $ContentStream.CopyTo( $Context.Response.OutputStream );
        $Context.Response.Close()
    }
    # powershell will continue looping and listen for new requests...
}
