# DatabaseSize.ps1

Icinga/Nagios PowerShell plugin to monitor Exchange mailbox database size.

## Features

- Checks Exchange database size in MiB
- Configurable critical threshold
- Nagios-compatible output and exit codes
- Performance data output for graphing

## Requirements

- Windows PowerShell
- Exchange Management Shell / snap-in available

## Usage

```powershell
.\DatabaseSize.ps1 -DatabaseName "DB01" -MaxSizeMB 280000
```

Optional custom snap-in:

```powershell
.\DatabaseSize.ps1 -DatabaseName "DB01" -MaxSizeMB 280000 -ExchangeSnapIn "Microsoft.Exchange.Management.PowerShell.E2010"
```

## Exit Codes

- `0` OK
- `2` CRITICAL
- `3` UNKNOWN

## License

GNU General Public License v2.0 (see repository license selection).