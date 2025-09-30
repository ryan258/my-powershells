param(
    [Parameter(Position=0)]
    [string]$Action,

    [Parameter(Position=1)]
    [string]$ClipName
)

$CLIP_DIR = "$env:USERPROFILE\.clipboard_history"

if (!(Test-Path $CLIP_DIR)) {
    New-Item -Path $CLIP_DIR -ItemType Directory -Force | Out-Null
}

switch ($Action.ToLower()) {
    "save" {
        $name = if ($ClipName) { $ClipName } else { "clip_$(Get-Date -Format 'HHmmss')" }

        try {
            $clipContent = Get-Clipboard -Raw
            if ($clipContent) {
                $clipContent | Out-File -FilePath "$CLIP_DIR\$name" -Encoding UTF8
                Write-Host "Saved clipboard as '$name'" -ForegroundColor Green
            } else {
                Write-Host "Clipboard is empty" -ForegroundColor Yellow
            }
        } catch {
            Write-Host "Failed to save clipboard: $($_.Exception.Message)" -ForegroundColor Red
        }
    }

    "load" {
        if (-not $ClipName) {
            Write-Host "Available clips:" -ForegroundColor Cyan
            $clips = Get-ChildItem -Path $CLIP_DIR -File -ErrorAction SilentlyContinue
            if ($clips) {
                $clips | ForEach-Object { Write-Host "  $($_.Name)" -ForegroundColor White }
            } else {
                Write-Host "No clips saved yet" -ForegroundColor Yellow
            }
            exit 1
        }

        $clipFile = "$CLIP_DIR\$ClipName"
        if (Test-Path $clipFile) {
            try {
                $content = Get-Content $clipFile -Raw
                $content | Set-Clipboard
                Write-Host "Loaded '$ClipName' to clipboard" -ForegroundColor Green
            } catch {
                Write-Host "Failed to load clip: $($_.Exception.Message)" -ForegroundColor Red
            }
        } else {
            Write-Host "Clip '$ClipName' not found" -ForegroundColor Red
        }
    }

    "list" {
        Write-Host "=== Saved Clips ===" -ForegroundColor Cyan
        $clips = Get-ChildItem -Path $CLIP_DIR -File -ErrorAction SilentlyContinue

        if ($clips) {
            foreach ($clip in $clips) {
                $preview = (Get-Content $clip.FullName -Raw -ErrorAction SilentlyContinue)
                if ($preview) {
                    $shortPreview = if ($preview.Length -gt 50) {
                        $preview.Substring(0, 50) + "..."
                    } else {
                        $preview
                    }
                    $shortPreview = $shortPreview -replace "`n", " " -replace "`r", ""
                    Write-Host "$($clip.Name): $shortPreview" -ForegroundColor White
                } else {
                    Write-Host "$($clip.Name): [Empty or binary content]" -ForegroundColor Gray
                }
            }
        } else {
            Write-Host "No clips saved yet" -ForegroundColor Yellow
        }
    }

    "peek" {
        Write-Host "=== Current Clipboard ===" -ForegroundColor Cyan
        try {
            $clipContent = Get-Clipboard -Raw
            if ($clipContent) {
                $preview = if ($clipContent.Length -gt 200) {
                    $clipContent.Substring(0, 200) + "..."
                } else {
                    $clipContent
                }
                Write-Host $preview -ForegroundColor White
            } else {
                Write-Host "[Empty]" -ForegroundColor Yellow
            }
        } catch {
            Write-Host "Failed to read clipboard: $($_.Exception.Message)" -ForegroundColor Red
        }
    }

    "clear" {
        if ($ClipName) {
            $clipFile = "$CLIP_DIR\$ClipName"
            if (Test-Path $clipFile) {
                Remove-Item $clipFile -Force
                Write-Host "Deleted clip '$ClipName'" -ForegroundColor Green
            } else {
                Write-Host "Clip '$ClipName' not found" -ForegroundColor Red
            }
        } else {
            $confirm = Read-Host "Clear all saved clips? (y/n)"
            if ($confirm -eq 'y' -or $confirm -eq 'Y') {
                Remove-Item "$CLIP_DIR\*" -Force -ErrorAction SilentlyContinue
                Write-Host "Cleared all clips" -ForegroundColor Green
            }
        }
    }

    default {
        Write-Host "Usage:" -ForegroundColor Yellow
        Write-Host "  clipboard_manager save [name]  : Save current clipboard" -ForegroundColor White
        Write-Host "  clipboard_manager load <name>  : Load clip to clipboard" -ForegroundColor White
        Write-Host "  clipboard_manager list         : Show all saved clips" -ForegroundColor White
        Write-Host "  clipboard_manager peek         : Show current clipboard content" -ForegroundColor White
        Write-Host "  clipboard_manager clear [name] : Clear clip(s)" -ForegroundColor White
    }
}