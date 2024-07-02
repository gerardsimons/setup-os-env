
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /Users/gerard/.miniconda3/bin/conda
    eval /Users/gerard/.miniconda3/bin/conda "shell.fish" "hook" $argv | source
end
# <<< conda initialize <<<

# Path stuff
set -gx PATH $PATH:/opt/homebrew/bin
set -gx PATH $PATH:/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH
# GNU grep
set -gx PATH $PATH:/opt/homebrew/opt/grep/libexec/gnubin

set -gx TELEGRAM_BOT_TOKEN 7128149860:AAE2YoENbtSHKIm2PRHHqYyY5DSZQr4pcLs
set -gx TELEGRAM_BOT_CHANNEL -1002146125733

source ~/.aliases

# Functions
function telegram_notify
  # Lol 
  set encoded_text (python -c "import urllib.parse, sys; print(urllib.parse.quote(sys.argv[1]))" "$argv")
  curl "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage?chat_id=$TELEGRAM_BOT_CHANNEL&text=$encoded_text"
end

