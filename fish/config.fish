if status is-interactive
# Commands to run in interactive sessions can go here
# rbenv init - fish | source
end

set -U fish_greeting ""
export PATH="$HOME/.local/bin:$PATH"

# Flutter path confifg
fish_add_path /Users/david/Library/flutter/bin/

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :
set -gx VOLTA_HOME "$HOME/.volta"
set -gx PATH "$VOLTA_HOME/bin" $PATH

# pnpm
set -gx PNPM_HOME "/Users/david/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end


# abbr
abbr --set-cursor=@\$ -a tn cd ~/dev/terydin@\$
abbr --set-cursor=@\$ -a pb cd ~/Documents/obsidian/Playbook2026/@\$
abbr --set-cursor=@\$ -a me cd ~/dev/me@\$
abbr --set-cursor=@\$ -a bi cd ~/dev/bitovi@\$
abbr --set-cursor=@\$ -a ping cd ~/dev/me/ping@\$
# abbr end

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
