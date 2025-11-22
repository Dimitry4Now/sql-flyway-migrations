#!/bin/bash

# Set commit message template
git config commit.template .gitmessage

echo "✅ Git commit template configured!"
echo ""
echo "Usage:"
echo "  git commit        # Opens editor with template"
echo "  git commit -m ''  # Skip template (not recommended)"
echo ""
echo "Commit Message Format:"
echo "  1. Subject line (max 50 chars)"
echo "  2. Files changed: List modified files"
echo "  3. Purpose of the change: Why? (min 50 chars)"
echo "  4. How does it affect the application: Impact? (min 50 chars)"
