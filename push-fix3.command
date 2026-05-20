#!/bin/bash
cd ~/Dev/psionic/psionictraining-site

echo "=== Rebasing local onto remote main ==="
git rebase origin/main

echo "=== Pushing to origin main ==="
git push origin main

echo ""
echo "=== DONE! You can close this window ==="
read -p "Press Enter to close..."
