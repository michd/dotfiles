# Folder bookmarking functions

set -g mark_path "$HOME/.marks"

function mark --description 'bookmark folders with short names'
    mkdir -p "$mark_path"
    ln -s (pwd) "$mark_path/$argv"
end

function m --description 'bookmark folders with short names'
    mark $argv
end

function jump --description 'jump to a bookmarked folder by name'
    set -l dest_path (readlink "$mark_path/$argv")

    if test -z $dest_path
        echo "No such mark: $argv"
        return 1
    else
        cd $dest_path
    end
end

function j --description 'jump to a bookmarked folder by name'
    jump $argv
end

function marks --description 'lists all directory bookmarks'
    ls -l "$mark_path" | sed 's/  / /g' | cut -d' ' -f9- | sed 's/ -/\t-/g'
    echo
end

function unmark --description 'remove a bookmark to a folder'
    rm -i "$mark_path/$argv"
end

complete -x -c j -a "(ls $mark_path)"
complete -x -c jump -a "(ls $mark_path)"
complete -x -c unmark -a "(ls $mark_path)"
