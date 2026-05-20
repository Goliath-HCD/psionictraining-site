#!/bin/bash
cd ~/Dev/psionic/psionictraining-site

echo "=== Adding all files ==="
git add -A

echo "=== Amending commit to include everything ==="
git commit --amend -m "Fix voice playback: use AudioContext for browser autoplay

The playVoiceSample function failed silently because audio.play() was
called after an async fetch, losing the user gesture context. Switched
to AudioContext API which unlocks on click and stays unlocked for
subsequent async audio decoding and playback."

echo "=== Force pushing to origin main ==="
git push --force origin main

echo ""
echo "=== DONE! You can close this window ==="
read -p "Press Enter to close..."
