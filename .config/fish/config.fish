if status is-interactive
    # Commands to run in interactive sessions can go here

    # Get machine type from file installed by dotfiles install.sh
    # This defaults to "desktop" The value determines which colors are used
    # in the prompt and in tmux bottom bar
    set -l machine_type (cat ~/.machine-type 2>/dev/null || echo desktop)

    set -g fish_host_color "00ffff"
    set -g tmux_status_bg "light cyan"
    set -g tmux_status_fg "black"

    switch $machine_type
        case desktop
            set -g fish_host_color "00ffff"
            set -g tmux_status_bg "cyan"
            set -g tmux_status_fg "black"
        case server
            set -g fish_host_color "FCE94F"
            set -g tmux_status_bg "yellow"
            set -g tmux_status_fg "black"
        case home-server
            set -g fish_host_color "8AE234"
            set -g tmux_status_bg "green"
            set -g tmux_status_fg "black"
        case android
            set -g fish_host_color "AD7FA8"
            set -g tmux_status_bg "magenta"
            set -g tmux_status_fg "white"
    end

    set -g fish_at_color "555753"
    set -g fish_vcs_status_color "C4A000"

    # Tweak colors of TMUX if we're within it
    if set -q TMUX
        tmux set-option -g status-bg "$tmux_status_bg"
        tmux set-option -g status-fg "$tmux_status_fg"
        tmux set-option -g pane-active-border-style "fg=$tmux_status_bg"
        tmux set-option -g window-status-current-format "#[bg=$tmux_status_fg,fg=$tmux_status_bg] #I:#W "
    end

    # Remove greeting
    set -U fish_greeting 

    # Load functions we want available by default (not autoloaded)
    for f in $HOME/.config/fish/functions/default/*.fish
        source $f
    end

    # Same with completions
    for f in $HOME/.config/fish/completions/default/*.fish
        source $f
    end

    # Add some bash utilities I wrote to PATH
    set -x PATH $PATH /opt/bash-util
end
