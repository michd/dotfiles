set -g PATH $PATH $HOME/.cargo/bin

function readprobelog --description 'make probe-rs json logs human-readable'

    if test (count $argv) -gt 0
        set logfile $argv
    else
        set logfile (ls -r ~/.local/share/probe-rs/*.log | head -n1)
    end

    cat $logfile | jq -r '[.timestamp, .level, .fields.message] | join(" ")' | less
end

