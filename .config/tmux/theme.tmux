#!/usr/bin/env bash

set -e

PLUGINS=$(tmux show-options -g | grep @tpm_plugins)

# Determine whether the tmux-cpu plugin should be installed
SHOW_CPU=false
if [[ $PLUGINS == *"tmux-cpu"* ]]; then
    SHOW_CPU=true
fi
SHOW_ONLINE_STATUS=false
if [[ $PLUGINS == *"tmux-online-status"* ]]; then
    SHOW_ONLINE_STATUS=true
fi

TMUX_THEME_BG_COLOR=colour255
TMUX_THEME_BG_COLOR_WINDOW_NUMBER=colour249
TMUX_THEME_BG_COLOR_WINDOW_NAME=colour250

if [[ $(defaults read -g AppleInterfaceStyle) == "Dark" ]]; then
TMUX_THEME_BG_COLOR=colour232
TMUX_THEME_BG_COLOR_WINDOW_NUMBER=colour233
TMUX_THEME_BG_COLOR_WINDOW_NAME=colour234
fi

# Online status icons
tmux set -g @online_icon "online"
tmux set -g @offline_icon "offline"

# Optional prefix highlight plugin
tmux set -g @prefix_highlight_fg 'colour232'
tmux set -g @prefix_highlight_bg 'yellow'
tmux set -g @prefix_highlight_show_copy_mode 'on'
tmux set -g @prefix_highlight_copy_mode_attr "bg=yellow,fg=colour232,nobold"
tmux set -g @prefix_highlight_copy_icon "  "
tmux set -g @prefix_highlight_prefix_icon "  "
tmux set -g @prefix_highlight_visual_mode "icon"

# panes
tmux set -g pane-border-style fg=colour239 \; set -g pane-active-border-style fg=colour4
tmux set -g display-panes-active-colour colour4 \; set -g display-panes-colour colour4

# messages
tmux set -g message-style fg=colour16,bg=colour11,bold
tmux set -g message-command-style fg=colour16,bg=colour160,bold

# windows mode
tmux setw -g mode-style fg=colour16,bg=colour11,bold
tmux set -g status-style fg=colour253,bg=$TMUX_THEME_BG_COLOR

status_left="#[fg=colour16,bg=colour250,nobold]  #[fg=colour16,bg=colour254,nobold] #S #[bg=$TMUX_THEME_BG_COLOR,nobold] "
if [ x"`tmux -q -L tmux_theme_status_left_test -f /dev/null new-session -d \; show -g -v status-left \; kill-session`" = x"[#S] " ] ; then
    status_left="$status_left "
fi

tmux set -g status-justify left
tmux set -g status-left-length 32 \; set -g status-left "$status_left"
tmux setw -g window-status-style fg=colour239,bg=$TMUX_THEME_BG_COLOR
tmux setw -g window-status-format "#[fg=colour241,bg=$TMUX_THEME_BG_COLOR_WINDOW_NUMBER,nobold] #I #[fg=colour241,bg=$TMUX_THEME_BG_COLOR_WINDOW_NAME,nobold] #W #[bg=$TMUX_THEME_BG_COLOR,nobold] "
tmux setw -g window-status-current-format "#[fg=colour16,bg=colour29,bold] #I #[fg=colour16,bg=colour35,bold] #W #[bg=$TMUX_THEME_BG_COLOR,nobold] "
tmux setw -g window-status-activity-style fg=default,bg=default,underscore
tmux setw -g window-status-bell-style fg=colour11,bg=default,blink,bold
tmux setw -g window-status-last-style default,fg=colour4

empty_space="#[bg=$TMUX_THEME_BG_COLOR,nobold] "

if [ "$SHOW_CPU" = true ]; then
    status_icons="$status_icons$empty_space#[fg=colour16,bg=colour250,nobold]  #[fg=colour16,bg=colour254,nobold] #{cpu_percentage} "
fi

if [ "$SHOW_ONLINE_STATUS" = true ]; then
    status_icons="$status_icons$empty_space#[fg=colour16,bg=colour250,nobold]  #[fg=colour16,bg=colour254,nobold] #{online_status} "
fi

status_right="#{prefix_highlight}$status_icons$empty_space#[fg=colour16,bg=colour250,nobold]  #[fg=colour16,bg=colour254,nobold] #{ssh_status} "

tmux set -g status-right-length 64 \; set -g status-right "$status_right"
