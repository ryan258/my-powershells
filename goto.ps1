param(
    [Parameter(Position=0)]
    [string]$Action,

    [Parameter(Position=1)]
    [string]$BookmarkName
)

$BOOKMARKS_FILE = "$env:USERPROFILE\.dir_bookmarks.txt"

switch ($Action.ToLower()) {
    "save" {
        if (-not $BookmarkName) {
            Write-Host "Usage: goto save <bookmark_name>" -ForegroundColor Red
            exit 1
        }

        $currentDir = Get-Location
        Add-Content -Path $BOOKMARKS_FILE -Value "$BookmarkName`:$currentDir"
        Write-Host "Saved '$currentDir' as bookmark '$BookmarkName'" -ForegroundColor Green
    }

    "list" {
        Write-Host "=== Directory Bookmarks ===" -ForegroundColor Cyan
        if (Test-Path $BOOKMARKS_FILE) {
            Get-Content $BOOKMARKS_FILE | ForEach-Object {
                $parts = $_ -split ':', 2
                Write-Host "$($parts[0]) -> $($parts[1])" -ForegroundColor White
            }
        } else {
            Write-Host "No bookmarks saved yet." -ForegroundColor Yellow
        }
    }

    "remove" {
        if (-not $BookmarkName) {
            Write-Host "Usage: goto remove <bookmark_name>" -ForegroundColor Red
            exit 1
        }

        if (Test-Path $BOOKMARKS_FILE) {
            $bookmarks = Get-Content $BOOKMARKS_FILE | Where-Object { -not ($_ -match "^$BookmarkName`:") }
            $bookmarks | Set-Content $BOOKMARKS_FILE
            Write-Host "Removed bookmark '$BookmarkName'" -ForegroundColor Green
        } else {
            Write-Host "No bookmarks file found." -ForegroundColor Yellow
        }
    }

    default {
        if (-not $Action) {
            Write-Host "Usage:" -ForegroundColor Yellow
            Write-Host "  goto save <name>   : Save current directory" -ForegroundColor White
            Write-Host "  goto list          : List all bookmarks" -ForegroundColor White
            Write-Host "  goto remove <name> : Remove bookmark" -ForegroundColor White
            Write-Host "  goto <name>        : Jump to bookmark" -ForegroundColor White
            exit 1
        }

        if (Test-Path $BOOKMARKS_FILE) {
            $bookmark = Get-Content $BOOKMARKS_FILE | Where-Object { $_ -match "^$Action`:" } | Select-Object -First 1

            if ($bookmark) {
                $targetPath = ($bookmark -split ':', 2)[1]

                if (Test-Path $targetPath) {
                    try {
                        Set-Location $targetPath
                        Write-Host "Jumped to: $targetPath" -ForegroundColor Green
                    } catch {
                        Write-Host "Failed to change directory to: $targetPath" -ForegroundColor Red
                        Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
                    }
                } else {
                    Write-Host "Path no longer exists: $targetPath" -ForegroundColor Red
                    Write-Host "Consider removing this bookmark with: goto remove $Action" -ForegroundColor Yellow
                }
            } else {
                Write-Host "Bookmark '$Action' not found. Use 'goto list' to see available bookmarks." -ForegroundColor Yellow
            }
        } else {
            Write-Host "No bookmarks file found." -ForegroundColor Yellow
        }
    }
}