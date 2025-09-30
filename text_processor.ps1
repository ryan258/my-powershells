param(
    [Parameter(Position=0, Mandatory=$true)]
    [string]$Action,

    [Parameter(Position=1)]
    [string]$Parameter1,

    [Parameter(Position=2)]
    [string]$Parameter2,

    [Parameter(Position=3)]
    [string]$Parameter3
)

switch ($Action.ToLower()) {
    "count" {
        if (-not $Parameter1) {
            Write-Host "Usage: text_processor count <file>" -ForegroundColor Red
            exit 1
        }

        $file = $Parameter1
        if (!(Test-Path $file)) {
            Write-Host "File not found: $file" -ForegroundColor Red
            exit 1
        }

        try {
            $content = Get-Content $file -Raw
            $lines = (Get-Content $file).Count
            $words = ($content -split '\s+' | Where-Object { $_ -ne '' }).Count
            $characters = $content.Length
            $charactersNoSpaces = ($content -replace '\s', '').Length

            Write-Host "=== Text Statistics for $file ===" -ForegroundColor Cyan
            Write-Host "Lines: $lines" -ForegroundColor White
            Write-Host "Words: $words" -ForegroundColor White
            Write-Host "Characters: $characters" -ForegroundColor White
            Write-Host "Characters (no spaces): $charactersNoSpaces" -ForegroundColor White
        } catch {
            Write-Host "Error reading file: $($_.Exception.Message)" -ForegroundColor Red
        }
    }

    "search" {
        if (-not $Parameter1 -or -not $Parameter2) {
            Write-Host "Usage: text_processor search <pattern> <file>" -ForegroundColor Red
            exit 1
        }

        $pattern = $Parameter1
        $file = $Parameter2

        if (!(Test-Path $file)) {
            Write-Host "File not found: $file" -ForegroundColor Red
            exit 1
        }

        Write-Host "=== Searching for '$pattern' in $file ===" -ForegroundColor Cyan

        try {
            $matches = Select-String -Path $file -Pattern $pattern -SimpleMatch -CaseSensitive:$false

            if ($matches) {
                $matches | ForEach-Object {
                    Write-Host "Line $($_.LineNumber): $($_.Line)" -ForegroundColor White
                }
            } else {
                Write-Host "Pattern not found" -ForegroundColor Yellow
            }
        } catch {
            Write-Host "Error searching file: $($_.Exception.Message)" -ForegroundColor Red
        }
    }

    "replace" {
        if (-not $Parameter1 -or -not $Parameter2 -or -not $Parameter3) {
            Write-Host "Usage: text_processor replace <old_text> <new_text> <file>" -ForegroundColor Red
            Write-Host "Note: This creates a backup with .bak extension" -ForegroundColor Yellow
            exit 1
        }

        $oldText = $Parameter1
        $newText = $Parameter2
        $file = $Parameter3

        if (!(Test-Path $file)) {
            Write-Host "File not found: $file" -ForegroundColor Red
            exit 1
        }

        try {
            # Create backup
            $backupFile = "$file.bak"
            Copy-Item $file $backupFile -Force

            # Read file content
            $content = Get-Content $file -Raw -Encoding UTF8

            # Perform replacement
            $newContent = $content -replace [regex]::Escape($oldText), $newText

            # Write back to file
            $newContent | Out-File -FilePath $file -Encoding UTF8 -NoNewline

            Write-Host "Replaced '$oldText' with '$newText' in $file" -ForegroundColor Green
            Write-Host "Backup saved as $backupFile" -ForegroundColor Gray
        } catch {
            Write-Host "Error replacing text: $($_.Exception.Message)" -ForegroundColor Red
        }
    }

    "clean" {
        if (-not $Parameter1) {
            Write-Host "Usage: text_processor clean <file>" -ForegroundColor Red
            exit 1
        }

        $file = $Parameter1
        if (!(Test-Path $file)) {
            Write-Host "File not found: $file" -ForegroundColor Red
            exit 1
        }

        try {
            # Create backup
            $backupFile = "$file.bak"
            Copy-Item $file $backupFile -Force

            # Read and clean content
            $lines = Get-Content $file
            $cleanedLines = $lines | ForEach-Object {
                $_.TrimEnd()  # Remove trailing whitespace
            } | Where-Object {
                $_ -ne ''     # Remove empty lines
            }

            # Write cleaned content back
            $cleanedLines | Out-File -FilePath $file -Encoding UTF8

            Write-Host "Cleaned up $file (removed trailing spaces and empty lines)" -ForegroundColor Green
            Write-Host "Backup saved as $backupFile" -ForegroundColor Gray
        } catch {
            Write-Host "Error cleaning file: $($_.Exception.Message)" -ForegroundColor Red
        }
    }

    "lines" {
        if (-not $Parameter1) {
            Write-Host "Usage: text_processor lines <file> [start] [end]" -ForegroundColor Red
            exit 1
        }

        $file = $Parameter1
        $startLine = if ($Parameter2) { [int]$Parameter2 } else { 1 }
        $endLine = if ($Parameter3) { [int]$Parameter3 } else { $null }

        if (!(Test-Path $file)) {
            Write-Host "File not found: $file" -ForegroundColor Red
            exit 1
        }

        try {
            $lines = Get-Content $file

            if ($endLine) {
                $selectedLines = $lines[($startLine-1)..($endLine-1)]
            } else {
                $selectedLines = $lines[($startLine-1)..($lines.Count-1)]
            }

            Write-Host "=== Lines $startLine-$($endLine -or $lines.Count) from $file ===" -ForegroundColor Cyan
            for ($i = 0; $i -lt $selectedLines.Count; $i++) {
                $lineNum = $startLine + $i
                Write-Host "$lineNum`: $($selectedLines[$i])" -ForegroundColor White
            }
        } catch {
            Write-Host "Error reading lines: $($_.Exception.Message)" -ForegroundColor Red
        }
    }

    default {
        Write-Host "Usage: text_processor {count|search|replace|clean|lines}" -ForegroundColor Yellow
        Write-Host "  count <file>                    : Count lines, words, characters" -ForegroundColor White
        Write-Host "  search <pattern> <file>         : Search for text pattern" -ForegroundColor White
        Write-Host "  replace <old> <new> <file>      : Replace text (creates backup)" -ForegroundColor White
        Write-Host "  clean <file>                    : Remove extra whitespace" -ForegroundColor White
        Write-Host "  lines <file> [start] [end]      : Show specific lines" -ForegroundColor White
    }
}