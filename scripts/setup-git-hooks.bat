@echo off
REM Set commit message template
git config commit.template .gitmessage

REM Configure git to use custom hooks directory
git config core.hooksPath .git-hooks

REM Make hooks executable (Windows doesn't need chmod, but we ensure they exist)
if exist .git-hooks (
    echo Hooks directory found.
) else (
    echo Warning: .git-hooks directory not found!
)

echo.
echo ✅ Git commit template and hooks configured!
echo.
echo Usage:
echo   git add ^<files^>   # Stage your changes
echo   git commit        # Opens editor with AUTO-POPULATED file list!
echo.
echo The 'Files changed:' section will be automatically filled with staged files.
echo.
echo Commit Message Format:
echo   1. Subject line (max 50 chars)
echo   2. Files changed: AUTO-POPULATED ✨
echo   3. Purpose of the change: Why? (min 50 chars)
echo   4. How does it affect the application: Impact? (min 50 chars)
echo.
pause
