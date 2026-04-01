[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$DatabaseName,

    [Parameter(Mandatory = $false)]
    [double]$MaxSizeMB = 280000,

    [Parameter(Mandatory = $false)]
    [string]$ExchangeSnapIn = "Microsoft.Exchange.Management.PowerShell.E2010"
)

$ErrorActionPreference = "Stop"

function Exit-Plugin {
    param(
        [Parameter(Mandatory = $true)]
        [int]$Code,
        [Parameter(Mandatory = $true)]
        [string]$Message
    )

    Write-Output $Message
    exit $Code
}

try {
    if (-not (Get-PSSnapin -Name $ExchangeSnapIn -ErrorAction SilentlyContinue)) {
        Add-PSSnapin $ExchangeSnapIn
    }

    $db = Get-MailboxDatabase -Status $DatabaseName | Select-Object -First 1 Name, DatabaseSize

    if (-not $db) {
        Exit-Plugin -Code 3 -Message "UNKNOWN - Database '$DatabaseName' not found"
    }

    $sizeMB = [double]$db.DatabaseSize.ToMB()
    $perf = "'db_size_mib'=$sizeMB;$MaxSizeMB;;;"

    if ($sizeMB -gt $MaxSizeMB) {
        Exit-Plugin -Code 2 -Message "CRITICAL - Database '$($db.Name)' size is ${sizeMB} MiB (max ${MaxSizeMB} MiB) | $perf"
    }

    Exit-Plugin -Code 0 -Message "OK - Database '$($db.Name)' size is ${sizeMB} MiB | $perf"
}
catch {
    Exit-Plugin -Code 3 -Message "UNKNOWN - $($_.Exception.Message)"
}
