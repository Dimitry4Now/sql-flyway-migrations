@echo off
setlocal enabledelayedexpansion

echo ╔══════════════════════════════════════════════════════╗
echo ║   Git Commit Template and Hooks Setup (Windows)      ║
echo ╚══════════════════════════════════════════════════════╝
echo.

REM Create .git-hooks directory if it doesn't exist
if not exist .git-hooks (
    echo Creating .git-hooks directory...
    mkdir .git-hooks
)

REM Set commit message template
echo Configuring commit template...
git config commit.template .gitmessage

REM Configure git to use custom hooks directory
echo Configuring hooks path...
git config core.hooksPath .git-hooks

REM Check if hooks exist
set HOOKS_EXIST=1
if not exist .git-hooks\prepare-commit-msg (
    echo ⚠️  prepare-commit-msg hook not found in .git-hooks
    set HOOKS_EXIST=0
)
if not exist .git-hooks\commit-msg (
    echo ⚠️  commit-msg hook not found in .git-hooks
    set HOOKS_EXIST=0
)

if !HOOKS_EXIST! equ 1 (
    echo ✅ Git hooks found and configured!
) else (
    echo.
    echo ⚠️  Some hooks are missing. Please ensure you have:
    echo    - .git-hooks/prepare-commit-msg
    echo    - .git-hooks/commit-msg
)

REM Check if .gitmessage exists
if not exist .gitmessage (
    echo ⚠️  .gitmessage template file not found
) else (
    echo ✅ Commit message template configured!
)

echo.
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo ✅ Git configuration complete!
echo.
echo Usage:
echo   git add ^<files^>       # Stage your changes
echo   git commit             # Opens editor with AUTO-POPULATED file list!
echo.
echo Features:
echo   📝 Commit template with structured format
echo   ✨ Auto-populated 'Files changed' section
echo   ✅ Automatic validation of commit messages
echo.
echo Commit Message Format:
echo   1. Subject line (max 50 chars)
echo   2. Files changed: AUTO-POPULATED ✨
echo   3. Purpose of the change: Why? (min 50 chars)
echo   4. How does it affect the application: Impact? (min 50 chars)
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.
pause
