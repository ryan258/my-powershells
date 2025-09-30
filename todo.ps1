param(
    [Parameter(Position=0)]
    [string]$Action = "list",

    [Parameter(Position=1, ValueFromRemainingArguments=$true)]
    [string[]]$TaskText
)

$TODO_FILE = "$env:USERPROFILE\.todo_list.txt"
$DONE_FILE = "$env:USERPROFILE\.todo_done.txt"

if (!(Test-Path $TODO_FILE)) { New-Item -Path $TODO_FILE -ItemType File -Force | Out-Null }
if (!(Test-Path $DONE_FILE)) { New-Item -Path $DONE_FILE -ItemType File -Force | Out-Null }

switch ($Action.ToLower()) {
    "add" {
        if (-not $TaskText) {
            Write-Host "Usage: todo add <task>" -ForegroundColor Red
            exit 1
        }
        $task = $TaskText -join " "
        Add-Content -Path $TODO_FILE -Value $task
        Write-Host "Added: '$task'" -ForegroundColor Green
    }

    "list" {
        Write-Host "--- TODO ---" -ForegroundColor Cyan
        if (Test-Path $TODO_FILE) {
            $tasks = Get-Content $TODO_FILE
            for ($i = 0; $i -lt $tasks.Count; $i++) {
                Write-Host "$($i + 1). $($tasks[$i])"
            }
        }
    }

    "done" {
        if (-not $TaskText -or -not ($TaskText[0] -as [int])) {
            Write-Host "Error: Please specify the task number to complete." -ForegroundColor Red
            Write-Host "Usage: todo done <task_number>" -ForegroundColor Yellow
            exit 1
        }

        $taskNum = [int]$TaskText[0]
        $tasks = Get-Content $TODO_FILE -ErrorAction SilentlyContinue

        if ($taskNum -le 0 -or $taskNum -gt $tasks.Count) {
            Write-Host "Error: Invalid task number." -ForegroundColor Red
            exit 1
        }

        $completedTask = $tasks[$taskNum - 1]
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        Add-Content -Path $DONE_FILE -Value "[$timestamp] $completedTask"

        $remainingTasks = $tasks | Where-Object { $_ -ne $completedTask }
        $remainingTasks | Set-Content $TODO_FILE

        Write-Host "Completed: $completedTask" -ForegroundColor Green
    }

    "clear" {
        if (Test-Path $TODO_FILE) {
            $tasks = Get-Content $TODO_FILE -ErrorAction SilentlyContinue
            if ($tasks) {
                $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
                foreach ($task in $tasks) {
                    if ($task.Trim()) {
                        Add-Content -Path $DONE_FILE -Value "[$timestamp] $task"
                    }
                }
            }
        }
        Clear-Content $TODO_FILE
        Write-Host "All tasks cleared." -ForegroundColor Yellow
    }

    default {
        Write-Host "Usage: todo {add|list|done|clear}" -ForegroundColor Yellow
        Write-Host "  add <'task text'> : Add a new task" -ForegroundColor White
        Write-Host "  list              : Show all current tasks" -ForegroundColor White
        Write-Host "  done <task_number>: Mark a task as complete" -ForegroundColor White
        Write-Host "  clear             : Clear all tasks" -ForegroundColor White
    }
}