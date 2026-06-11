#!/bin/bash
cd ~/Dev/psionic/psionictraining-site

echo "=== Renaming branch master → main ==="
git branch -m master main

echo "=== Pulling remote main (allow unrelated histories) ==="
git pull origin main --allow-unrelated-histories --no-edit

echo "=== Pushing to origin main ==="
git push origin main

echo ""
echo "=== DONE! You can close this window ==="
read -p "Press Enter to close..."
