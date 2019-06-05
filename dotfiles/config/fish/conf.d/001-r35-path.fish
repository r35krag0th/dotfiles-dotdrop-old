# vim: ft=fish

# Delete the global shadow...
set --erase --global fish_user_paths

add_path_to_beginning $HOME/.poetry/bin

for a_path in $PATH
    if string match -q -i '*zplugin*' $a_path
      removepath $a_path
    end
end

