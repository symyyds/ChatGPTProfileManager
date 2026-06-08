$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$python = Get-Command python -ErrorAction SilentlyContinue
if (-not $python) {
    throw "python was not found in PATH."
}

Set-Location $root
& $python.Source "$root\server.py"
