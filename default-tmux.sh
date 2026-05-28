#!/bin/zsh

session_name='DEFAULT'

tmux has-session -t $session_name
if [ $? != 0 ]; then

    ### Create session ###
    tmux new-session -ds $session_name
	tmux new-window -t $session_name:0
	tmux rename-window -t $session_name:0 ZETTLEKASTEN
	tmux send-keys -t $session_name:0 'cd ~/zettlekasten' C-m 
	tmux send-keys -t $session_name:0 'clear' C-m

	tmux new-window -t $session_name:1
	tmux rename-window -t $session_name:1 MUSIC
	tmux send-keys-t $session_name:1 'jellyfin-tui' C-m
	tmux send-keys-t $session_name:1 'jellyfin-tui' C-m
	
	tmux new-window -t $session_name:2
fi

tmux attach -t $session_name
