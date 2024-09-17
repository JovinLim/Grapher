#!/bin/bash

# Define the tmux session name
SESSION_NAME="grapher_webui_session"

# API URL environment variable
API_URL="http://localhost:8080"

# Start a new tmux session, or attach to the existing one if it already exists
tmux has-session -t $SESSION_NAME 2>/dev/null

if [ $? != 0 ]; then
  # Create a new tmux session
  tmux new-session -d -s $SESSION_NAME

  # Split the window horizontally
  tmux split-window -h

  # Navigate to the 'server' folder and run 'docker compose up -d' in the first pane
  tmux send-keys "cd packages/server && docker compose up -d" C-m

  # Select the pane to the right
  tmux select-pane -R

  # Navigate to the 'ui' folder and run 'npm run dev' in the second pane
  tmux send-keys "cd packages/ui && VITE_API_URL=$API_URL npm run dev" C-m
fi

# Attach to the tmux session
tmux attach -t $SESSION_NAME
