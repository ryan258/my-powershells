# Future Roadmap

This document outlines potential new scripts and aliases to expand the functionality and convenience of this PowerShell productivity system. These are ideas to be explored and implemented over time.

---

## New Script Ideas (Top 50)

#### Development & API

1.  **`docker-manager`**: A script to quickly manage Docker containers (start, stop, list, logs, prune).
2.  **`db-backup`**: A tool to backup local databases (e.g., MySQL, PostgreSQL, SQLite) to a timestamped file.
3.  **`new-project-js`**: A script similar to `mkproject_py` but for Node.js projects (e.g., with `package.json`, `index.js`, and `eslint` setup).
4.  **`api-tester`**: A simple CLI to make API requests (a lightweight Postman for GET, POST, etc.).
5.  **`dependency-check`**: Check for outdated dependencies in a project (`npm outdated`, `pip list --outdated`, etc.) and provide an interactive upgrade option.
6.  **`code-metrics`**: Calculate code statistics for a project (lines of code, file count, complexity) using a tool like `cloc`.
7.  **`ssh-manager`**: Manage SSH connections from a predefined list, allowing you to connect with a simple name.
8.  **`gcp-helper` / `aws-helper`**: Scripts to simplify common cloud CLI tasks (e.g., listing instances, connecting to a VM).
9.  **`license-generator`**: Add a common open-source license (MIT, GPL, Apache) to a project.
10. **`changelog-generator`**: Generate a `CHANGELOG.md` file from conventional git commit messages.

#### File & Directory Management

11. **`file-watcher`**: Watch a directory for file changes and run a specified command automatically.
12. **`batch-rename`**: Rename multiple files in a directory based on a pattern (e.g., add a prefix, change extension).
13. **`image-optimizer`**: Compress and optimize all JPG/PNG images in a folder using a tool like `imagemin`.
14. **`exif-reader`**: Read and display EXIF metadata from image files.
15. **`deduplicate-lines`**: Remove duplicate lines from a text file, optionally sorting it.
16. **`sort-file`**: Sort the contents of a text file alphabetically or numerically.
17. **`encrypt-file` / `decrypt-file`**: Use a tool like GPG or built-in Windows features to encrypt/decrypt sensitive files.
18. **`serve-dir`**: Quickly serve the current directory over HTTP with a single command.
19. **`find-and-replace`**: Search for and replace a string of text across multiple files in a directory.
20. **`tree-view`**: Generate a more advanced directory tree view, showing file sizes and depth control.

#### System & Network Administration

21. **`port-manager`**: See what process is using a specific port and provide an option to kill it.
22. **`firewall-manager`**: A simple interface to add or remove rules from the Windows firewall.
23. **`service-manager`**: A friendly CLI to start, stop, and restart Windows services by name.
24. **`startup-manager`**: List, enable, or disable applications that run on system startup.
25. **`env-manager`**: A script to permanently add, edit, or remove system or user environment variables.
26. **`sound-control`**: Control system volume and switch between audio devices from the command line.
27. **`bluetooth-manager`**: Scan for, connect to, and disconnect from Bluetooth devices.
28. **`wifi-password`**: Show the password for a previously connected Wi-Fi network.
29. **`caffeine`**: A script to prevent the computer from going to sleep for a specified duration.
30. **`web-health-check`**: Ping a list of URLs from a config file and report their status codes.

#### Productivity & Utilities

31. **`pomodoro`**: A Pomodoro timer (e.g., 25 min work, 5 min break) that sends notifications.
32. **`habit-tracker`**: A simple CLI to track the completion of daily habits.
33. **`expense-tracker`**: Log daily expenses to a CSV file with categories and amounts.
34. **`stock-ticker`**: Get the current price and daily change of a stock symbol from a public API.
35. **`crypto-ticker`**: Get the current price of a cryptocurrency.
36. **`password-generator`**: Generate a strong, random password with options for length and complexity.
37. **`qr-code-generator`**: Generate a QR code from text or a URL and save it as an image.
38. **`shorten-url`**: Use a service like TinyURL to shorten a long URL.
39. **`dictionary`**: Look up the definition of a word.
40. **`thesaurus`**: Find synonyms and antonyms for a word.
41. **`movie-info`**: Get details about a movie from an API like OMDB.
42. **`book-search`**: Search for books using an API like the Google Books API.
43. **`daily-quote`**: Show a random quote of the day.
44. **`xkcd`**: Show a random or the latest XKCD comic in the terminal or browser.
45. **`spotify-control`**: Basic control for the Spotify desktop client (play, pause, next, previous, current song).
46. **`timer`**: A simple countdown timer that notifies you when done.
47. **`stopwatch`**: A simple stopwatch with lap functionality.
48. **`world-clock`**: Show the current time in several configured time zones.
49. **`calendar`**: Show a calendar for the current month or a specified year.
50. **`schedule`**: A simple script to view your daily schedule from a local calendar file or Google Calendar.

---

## New Alias Ideas (Top 50)

These aliases focus on reducing keystrokes for common, built-in commands.

#### General & PowerShell

1.  `h` -> `Get-History`
2.  `r` -> `Invoke-History`
3.  `edprof` -> `code $PROFILE` (Edit PowerShell profile in VS Code)
4.  `refprof` -> `.` `$PROFILE` (Reload PowerShell profile)
5.  `paths` -> `$env:Path -split ';'` (List all PATH entries on new lines)
6.  `admin` -> `Start-Process powershell -Verb runAs` (Open an admin PowerShell)
7.  `psedit` -> `powershell_ise` (Open PowerShell ISE)
8.  `which` -> `Get-Command`
9.  `cat` -> `Get-Content`
10. `mount` -> `Get-PSDrive`

#### File System

11. `md` -> `mkdir`
12. `rd` -> `rmdir`
13. `del` -> `Remove-Item -Recurse -Force`
14. `copy` -> `Copy-Item`
15. `move` -> `Move-Item`
16. `cls` -> `Clear-Host` (already present, but good to formalize)
17. `..` -> `cd ..` (already present)
18. `...` -> `cd ../..` (already present)
19. `ls` -> `Get-ChildItem`
20. `lsa` -> `Get-ChildItem -Force`

#### Git

21. `gpull` -> `git pull`
22. `gpush` -> `git push`
23. `gstat` -> `git status`
24. `gadd` -> `git add .`
25. `gcom` -> `git commit -m`
26. `glog` -> `git log --oneline --graph --decorate` (more visual log)
27. `gbra` -> `git branch -a`
28. `gnew` -> `git checkout -b` (create new branch)
29. `gdel` -> `git branch -D` (delete branch)
30. `gundo` -> `git reset HEAD~` (undo last commit)

#### Docker

31. `dps` -> `docker ps`
32. `dpsa` -> `docker ps -a`
33. `drun` -> `docker run -it`
34. `dstop` -> `docker stop`
35. `dlogs` -> `docker logs -f`
36. `dexec` -> `docker exec -it`
37. `dbuild` -> `docker build . -t`
38. `dprune` -> `docker system prune -f`
39. `drmi` -> `docker rmi` (remove image)
40. `dnet` -> `docker network ls`

#### System & Network

41. `kill` -> `Stop-Process -Name`
42. `procs` -> `Get-Process`
43. `servs` -> `Get-Service`
44. `path` -> `echo $env:PATH`
45. `hosts` -> `Get-Content C:\Windows\System32\drivers\etc\hosts`
46. `ports` -> `netstat -anob`
47. `routes` -> `Get-NetRoute`
48. `shares` -> `Get-SmbShare`
49. `uptime` -> `(Get-Date) - (Get-CimInstance -ClassName Win32_OperatingSystem).LastBootUpTime`
50. `reboot` -> `Restart-Computer -Force`
