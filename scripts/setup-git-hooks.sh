#!/bin/bash

echo "╔══════════════════════════════════════════════════════╗"
echo "║   Git Commit Template and Hooks Setup (Linux/macOS)  ║"
echo "╚══════════════════════════════════════════════════════╝"
echo ""

# Create .git-hooks directory if it doesn't exist
if [ ! -d ".git-hooks" ]; then
    echo "Creating .git-hooks directory..."
    mkdir -p .git-hooks
fi

# Set commit message template
echo "Configuring commit template..."
git config commit.template .gitmessage

# Configure git to use custom hooks directory
echo "Configuring hooks path..."
git config core.hooksPath .git-hooks

# Make hooks executable
if [ -d ".git-hooks" ]; then
    echo "Making hooks executable..."
    chmod +x .git-hooks/* 2>/dev/null
    
    # Check if hooks exist
    if [ -f ".git-hooks/prepare-commit-msg" ]; then
        echo "✅ prepare-commit-msg hook found"
    else
        echo "⚠️  prepare-commit-msg hook not found in .git-hooks"
    fi
    
    if [ -f ".git-hooks/commit-msg" ]; then
        echo "✅ commit-msg hook found"
    else
        echo "⚠️  commit-msg hook not found in .git-hooks"
    fi
else
    echo "⚠️  .git-hooks directory not found!"
fi

# Check if .gitmessage exists
if [ -f ".gitmessage" ]; then
    echo "✅ Commit message template configured!"
else
    echo "⚠️  .gitmessage template file not found"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Git configuration complete!"
echo ""
echo "Usage:"
echo "  git add <files>       # Stage your changes"
echo "  git commit            # Opens editor with AUTO-POPULATED file list!"
echo ""
echo "Features:"
echo "  📝 Commit template with structured format"
echo "  ✨ Auto-populated 'Files changed' section"
echo "  ✅ Automatic validation of commit messages"
echo ""
echo "Commit Message Format:"
echo "  1. Subject line (max 50 chars)"
echo "  2. Files changed: AUTO-POPULATED ✨"
echo "  3. Purpose of the change: Why? (min 50 chars)"
echo "  4. How does it affect the application: Impact? (min 50 chars)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
