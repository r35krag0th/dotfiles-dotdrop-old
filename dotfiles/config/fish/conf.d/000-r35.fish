# vim: ft=fish
# ==> WARNING!
# {{@@ header() @@}} -- {{@@ _dotfile_sub_abs_src @@}}

# ==> Debugging
# echo -e "\033[32m==>\033[0m 000-r35.fish"

set --export --universal EXPECTED_PIPENV_VERSION "2018.5.18"

# Utility functions
function add_path_to_beginning
    # Handle updating "fish_user_paths"
    if not contains -- $argv $fish_user_paths
        if test -d $argv
            set --universal fish_user_paths $argv $fish_user_paths
        end
    end

    # Handle updating "PATH"
    if not contains -- $argv $PATH
        if test -d $argv
            set --universal PATH $argv $PATH
        end
    end
end

function add_path_to_end
    # Handle updating "fish_user_paths"
    if not contains -- $argv $fish_user_paths
        if test -d $argv
            set --universal fish_user_paths $fish_user_paths $argv
        end
    end

    # Handle updating "PATH"
    if not contains -- $argv $PATH
        if test -d $argv
            set --universal PATH $PATH $argv
        end
    end
end

function add_to_completion_path
    if not contains -- $argv $fish_complete_path
        if test -d $argv
            set --global fish_complete_path $argv $fish_complete_path
        end
    end
end

function removepath
    if set --local index (contains -i $argv[1] $fish_user_paths)
        set --erase --universal fish_user_paths[$index]
        # echo -e "\033[31mDeleted[#$index]\033[0m ==> \033[35m$argv[1]\033[0m"
    end

    if set --local pindex (contains -i $argv[1] $PATH)
        set --erase --global PATH[$pindex]
        # echo -e "\033[31mDeleted[#$pindex]\033[0m ==> \033[35m$argv[1]\033[0m"
    end
end

function inc
    set $argv[1](expr $$argv[1] + 1)
end

function varclear --description 'Remove duplicates from environment variable'
    if test (count $argv) = 1
        set -l newvar
        set -l count 0
        for v in $$argv
            if contains -- $v $newvar
                # inc count
                set count (math $count+1)
                # echo -e "\033[32m[$v]\033[0m IS IN \033[36m[$newvar]\033[0m ..."
            else
                # echo -e "\033[33m[$v]\033[0m NOT IN \033[35m[$newvar]\033[0m ..."
                set newvar $newvar $v
            end
        end
        set $argv $newvar
        test $count -gt 0
        # and echo Removed $count duplicates from $argv
    else
        for a in $argv
            varclear $a
        end
    end
end

if status --is-interactive
    set -g fish_user_abbreviations

    # Kubernetes
    alias k8-aec="$HOME/bin/kubectl-1.2.6 --context=aec-primary"

    # App overrides with defaults
    # Hub is a RubyGem
    if test -n (which hub >/dev/null 1>/dev/null)
        alias git="hub"
        alias g="hub"
    end

    if test -x /usr/local/bin/vim
        alias vim="/usr/local/bin/vim -p"
    end

    if test -x /usr/local/bin/gsed
        alias sed="/usr/local/bin/gsed"
    end

    if test -x /usr/local/bin/ack
        alias grep="/usr/local/bin/ack"
    end

    if test -n (which colorls >/dev/null 1>/dev/null)
        # Replacing "ls" with better things
        alias ls="colorls"
        alias ll="colorls -A --gs --sd"
        # alias la="colorls -la"
        alias la="colorls -A -l --gs --sd"
        alias lt="colorls -A --tree --gs --sd"
    # else
    #     echo "ColorLS is not installed ..."
    end

    # Because I'm incredibly lazy
    alias h="heroku"
    alias k="kubectl"
    alias k8="kubectl"
    alias tf="terraform"

    # Quick app shortcuts 
    alias vsc="open -a 'Visual Studio Code'"
    alias pycharm="open -a 'PyCharm Professional'"
    alias webstorm="open -a 'WebStorm'"
    alias appcode="open -a 'AppCode'"
    alias rubymine="open -a 'RubyMine'"
    alias goland="open -a 'GoLand'"
    alias datagrip="open -a 'DataGrip'"

    # TODO.mdools
    alias fix-displays="$HOME/workspace/personal/macos-display-manager/fix_work_or_home_display.py"
end

function fix-pipenv-derps
    # This is to address the strange problems with pipenv and pip>=18.1
    #
    # Commonly you'll get a problem trying to parse requirements... because pipenv
    # hooked into internal pip functions... which is super shitty.
    command pip install "pipenv==$EXPECTED_PIPENV_VERSION" --upgrade --upgrade-strategy only-if-needed
    pipenv run pip install pip==18.0
    pipenv install
end

function tmux
    command tmux -2 $argv
end

function new-tmux
    # echo "Creating New Tmux with $argv"
    command tmux new -s $argv[1]
end

# Pretty version of tmux ls
function tls
    command tmux ls | tr ": " " " | tr " [" " " | tr "] " " " | awk '{ printf "\033[38;5;207m--> \033[1;32m%s \033[0;35m(\033[36m%s win \033[38;5;119m@\033[38;5;39m%s\033[35m)\033[0m \033[38;5;38m%s\033[0m\n", $1, $2, $12, $13 }'
end

function ta
    command tmux attach -t $argv
end

function tn
    command tmux new -s $argv
end

function us-west2-ssh
    command ssh -l ubuntu -i $X_WORK_SSH_KEY -o StrictHostKeyChecking=no -o PasswordAuthentication=no $argv
end

function tfv
    command blast-radius --serve .
end

function gfp
    command git fetch
    and git pull
end

# From CLI Improved...
# https://remysharp.com/2018/08/23/cli-improved

function cat
    command bat $argv
end

function du
    command ncdu --color dark -rr -x --exclude .git --exclude node_modules $argv
end

function ping
    command prettyping --nolegend $argv
end

function preview
    command fzf --preview 'bat --color \"always\" {}' $argv
end

function set_gempath_24
    # If there is a global shadowing the universal ...
    set --erase --global GEM_HOME
    set --erase --global GEM_PATH
    set --erase --global GEM_ROOT
    set --export --universal GEM_PATH "$HOME/.gem/ruby/2.4.0:$HOME/.rbenv/versions/2.4.2/lib/ruby/gems/2.4.0"
end

function set_gempath_25
    set --erase --global GEM_HOME
    set --erase --global GEM_PATH
    set --erase --global GEM_ROOT
    set --export --universal GEM_PATH "$HOME/.gem/ruby/2.5.0:$HOME/.rbenv/versions/2.5.3/lib/ruby/gems/2.5.0"
end

function set_gempath_26
    set --erase --global GEM_HOME
    set --erase --global GEM_PATH
    set --erase --global GEM_ROOT
    set --export --universal GEM_PATH "$HOME/.gem/ruby/2.6.0:$HOME/.rbenv/versions/2.6.3/lib/ruby/gems/2.6.0"
end

function pcard_statement
    command ps2pdf $argv $argv.pdf
end

function dump_paths
    echo -e "\033[36m===\033[0m [PATH DUMP -- fish_user_paths]"
    set -S fish_user_paths

    echo ""
    echo -e "\033[36m===\033[0m [PATH DUMP -- PATH]"
    set -S PATH
end

set --global --export KREW_ROOT "$HOME/.krew"

# INITIAL PATH MANAGEMENT
add_path_to_beginning /bin
add_path_to_beginning /usr/bin
add_path_to_beginning /usr/local/bin
add_path_to_beginning $HOME/.pyenv/bin
add_path_to_beginning $HOME/.pyenv/shims
add_path_to_beginning $HOME/.rbenv/shims
add_path_to_beginning $HOME/.goenv/shims
# add_path_to_beginning /opt/chefdk/bin
# add_path_to_beginning /opt/chef-workstation/bin
add_path_to_beginning $HOME/bin
add_path_to_beginning $KREW_ROOT/bin

# add support for ctrl+o to open selected file in VS Code
set --global FZF_DEFAULT_OPTS "--bind='ctrl-o:execute(code {})+abort'"

# Ensure the SHELL environment variable is correct
set --global SHELL (which fish)

# VirtualEnv Wrapper Setup
eval (python -m virtualfish)

### SETUP FISH COMPLETION PATH ###
add_to_completion_path $HOME/.config/fish/completions
add_to_completion_path $HOME/.local/share/omf/pkg/omf/completions
add_to_completion_path /usr/local/Cellar/fish/$FISH_VERSION/etc/fish/completions
add_to_completion_path /usr/local/share/fish/vendor_completions.d
add_to_completion_path /usr/local/Cellar/fish/$FISH_VERSION/share/fish/completions
add_to_completion_path $HOME/.local/share/fish/generated_completions
add_to_completion_path /usr/local/share/fish/completions/

# Setup TheFuck -- https://github.com/nvbn/thefuck
set --export FUCK_BIN (which fuck 2>&1)
test ! -z $FUCK_BIN -a -x $FUCK_BIN
and thefuck --alias | source

# dump_paths
# echo -e "\033[36m===\033[0m 000-r35.fish"
