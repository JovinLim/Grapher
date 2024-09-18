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

  # Split the right pane vertically to create space for running the FastAPI server
  tmux split-window -v

  # In the upper right pane, navigate to the 'ui' folder and run 'npm run dev'
  tmux send-keys "cd packages/ui && VITE_API_URL=$API_URL npm run dev" C-m

  # Select the lower right pane for running the FastAPI server
  tmux select-pane -D

  # Navigate to the 'server/api' folder and run FastAPI server using uvicorn
  tmux send-keys "cd packages/server/api && uvicorn api:app --reload --host 0.0.0.0 --port 8080" C-m
fi

# Attach to the tmux session
tmux attach -t $SESSION_NAME
