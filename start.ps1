$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$app = Join-Path $root "app"
$port = 8765
$url = "http://127.0.0.1:$port"
$out = Join-Path $app "manager.out.log"
$err = Join-Path $app "manager.err.log"
$pidFile = Join-Path $app "manager.pid"

function Test-PortOpen {
    param([int]$Port)
    $client = New-Object Net.Sockets.TcpClient
    try {
        $iar = $client.BeginConnect("127.0.0.1", $Port, $null, $null)
        if (-not $iar.AsyncWaitHandle.WaitOne(300, $false)) { return $false }
        $client.EndConnect($iar)
        return $true
    } catch {
        return $false
    } finally {
        $client.Close()
    }
}

if (Test-PortOpen -Port $port) {
    Start-Process $url
    exit 0
}

$python = Get-Command python -ErrorAction SilentlyContinue
if (-not $python) {
    throw "python was not found in PATH."
}

Set-Content -Path $out -Value "" -Encoding UTF8
Set-Content -Path $err -Value "" -Encoding UTF8

$env:PROFILE_MANAGER_PORT = [string]$port
$process = Start-Process `
    -FilePath $python.Source `
    -ArgumentList "`"$app\server.py`"" `
    -WorkingDirectory $app `
    -WindowStyle Hidden `
    -RedirectStandardOutput $out `
    -RedirectStandardError $err `
    -PassThru

Set-Content -Path $pidFile -Value $process.Id -Encoding ASCII

for ($i = 0; $i -lt 20; $i++) {
    if (Test-PortOpen -Port $port) {
        Start-Process $url
        exit 0
    }
    Start-Sleep -Milliseconds 300
}

Get-Content -Path $err -Raw -ErrorAction SilentlyContinue
throw "Profile Manager did not start. Check $err"
