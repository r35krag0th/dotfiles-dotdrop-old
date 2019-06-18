# vim: ft=fish
# ==> WARNING!
# {{@@ header() @@}} -- {{@@ _dotfile_sub_abs_src @@}}

# ==> Debugging
# echo -e "\033[32m==>\033[0m 001-r35-path.fish"

# Delete the global shadow...
set --erase --global fish_user_paths
set --erase --global PATH

add_path_to_beginning $HOME/.local/bin

add_path_to_beginning /usr/local/bin
add_path_to_beginning $HOME/.poetry/bin
add_path_to_beginning $HOME/.krew/bin

add_path_to_beginning $HOME/go/bin
add_path_to_beginning $HOME/bin
add_path_to_beginning /usr/local/MacGPG2/bin
add_path_to_beginning /Library/TeX/texbin

add_path_to_end /usr/bin
add_path_to_end /bin

add_path_to_end /usr/sbin
add_path_to_end /sbin

removepath $HOME/.chefdk/gem/ruby/2.4.0/bin
removepath /opt/chefdk/embedded/bin
removepath /opt/chef-workstation/embedded/bin
removepath $HOME/.chefdk/gem/ruby/2.5.0/bin/

for a_path in $PATH
    if string match -q -i '*zplugin*' $a_path
        removepath $a_path
    end
end

# dump_paths

# echo -e "\033[36m===\033[0m 001-r35-path.fish"
