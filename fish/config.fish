set fish_greeting

if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -x GOPATH ~/go

fish_add_path /opt/homebrew/bin /opt/homebrew/sbin ~/.cargo/bin ~/go/bin ~/.local/bin /usr/local/bin

starship init fish | source
