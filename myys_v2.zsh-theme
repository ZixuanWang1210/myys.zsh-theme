# Clean, simple, compatible and meaningful.
# Tested on Linux, Unix and Windows under ANSI colors.
# It is recommended to use with a dark background.
# Colors: black, red, green, yellow, *blue, magenta, cyan, and white.
#
# Mar 2013 Yad Smood
# Modified to add hostname, network status, and adjust layout

# --- Original VCS Settings ---
YS_VCS_PROMPT_PREFIX1=" %{$fg[white]%}on%{$reset_color%} "
YS_VCS_PROMPT_PREFIX2=":%{$fg[cyan]%}"
YS_VCS_PROMPT_SUFFIX="%{$reset_color%}"
YS_VCS_PROMPT_DIRTY=" %{$fg[red]%}x"
YS_VCS_PROMPT_CLEAN=" %{$fg[green]%}o"

# --- Original Conda info Function ---
local conda_info='$(conda_prompt_info)'
conda_prompt_info() {
  # Outputs (envname) or (base) - Format is suitable for target layout
  if [ -n "$CONDA_DEFAULT_ENV" ]; then
    echo -n "($CONDA_DEFAULT_ENV) "
  # Original script showed (base) even if conda wasn't installed.
  # Keeping original logic unless CONDA_DEFAULT_ENV is explicitly set.
  # Consider adding `elif command -v conda &> /dev/null; then echo -n "(base) "; fi`
  # if you only want (base) when conda is installed and no env is active.
  elif [[ -z "$CONDA_DEFAULT_ENV" ]] && command -v conda &>/dev/null; then
      # Let's slightly improve to show (base) only if conda exists and no env active
      echo -n "(base) "
  fi
}

# --- Original virtualenv info Function ---
local virtualenv_info='$(virtualenv_prompt_info)'
virtualenv_prompt_info() {
  # Outputs (envname) - Format is suitable for target layout
  if [ -n "$VIRTUAL_ENV" ]; then
    VIRTUAL_ENV_NAME=$(basename "$VIRTUAL_ENV")
    echo -n "($VIRTUAL_ENV_NAME) "
  fi
}

# --- Original Git info Settings ---
# Relies on Oh My Zsh's git_prompt_info() or similar
local git_info='$(git_prompt_info)'
ZSH_THEME_GIT_PROMPT_PREFIX="${YS_VCS_PROMPT_PREFIX1}git${YS_VCS_PROMPT_PREFIX2}"
ZSH_THEME_GIT_PROMPT_SUFFIX="$YS_VCS_PROMPT_SUFFIX"
ZSH_THEME_GIT_PROMPT_DIRTY="$YS_VCS_PROMPT_DIRTY"
ZSH_THEME_GIT_PROMPT_CLEAN="$YS_VCS_PROMPT_CLEAN"

# --- Original HG info Function ---
local hg_info='$(ys_hg_prompt_info)'
ys_hg_prompt_info() {
  # make sure this is a hg dir
  if [ -d '.hg' ]; then
    echo -n "${YS_VCS_PROMPT_PREFIX1}hg${YS_VCS_PROMPT_PREFIX2}"
    echo -n "$(hg branch 2>/dev/null)"
    if [ -n "$(hg status 2>/dev/null)" ]; then
      echo -n "$YS_VCS_PROMPT_DIRTY"
    else
      echo -n "$YS_VCS_PROMPT_CLEAN"
    fi
    echo -n "$YS_VCS_PROMPT_SUFFIX"
  fi
}

# --- Original Exit Code ---
local exit_code="%(?,,C:%{$fg[red]%}%?%{$reset_color%})"

# --- Original IP Address Acquisition (Using ifconfig) ---
# Kept as per requirement, ensure ifconfig is available and output format matches grep/awk
ipStr=$(
  ifconfig                        \
    | grep 'inet '                \
    | grep -v '127.0.0.1'         \
    | grep -v 'docker'            \
    | awk '{print $2}'            \
    | cut -d '/' -f1              \
    | paste -sd '|' - || echo "N/A" # Added fallback
)
# Ensure ipStr is not empty
if [ -z "$ipStr" ]; then
    ipStr="N/A"
fi


# --- Added: Network Status Check ---
# Uses ping; might cause slight delay (up to 1s). Needs font support for ✔/✘.
check_network_status() {
    if ping -c 1 -W 1 8.8.8.8 &> /dev/null; then
        # Online: Green check mark
        echo "%{$fg[green]%}✔%{$reset_color%}"
        # Alternative: echo "%{$fg[green]%}[O]%{$reset_color%}"
    else
        # Offline: Red X mark
        echo "%{$fg[red]%}✘%{$reset_color%}"
        # Alternative: echo "%{$fg[red]%}[X]%{$reset_color%}"
    fi
}
local network_status='$(check_network_status)'
# --- End Added: Network Status Check ---


# --- Modified PROMPT variable for Target Layout ---
# Target Layout: ✔ # USER @ HOSTNAME [IP] in DIR (PY_ENV) VCS [TIME] EXIT $
PROMPT="
${network_status} \
%{$terminfo[bold]$fg[blue]%}#%{$reset_color%} \
%(#,%{$bg[yellow]%}%{$fg[black]%}%n%{$reset_color%},%{$fg[cyan]%}%n) \
%{$fg[white]%}@ \
%{$fg[magenta]%}%m \
%{$fg[white]%}[%{$fg[cyan]%}${ipStr}%{$fg[white]%}] \
%{$fg[white]%}in \
%{$terminfo[bold]$fg[yellow]%}%~ \
%{$fg[green]%}${conda_info}\
%{$fg[green]%}${virtualenv_info}\
${hg_info}\
${git_info}\
 %{$fg[white]%}[%*] ${exit_code}
%{$terminfo[bold]$fg[red]%}$ %{$reset_color%}"


# --- Clean up temporary variables and functions ---
# Unset original and added variables/functions
unset YS_VCS_PROMPT_PREFIX1 YS_VCS_PROMPT_PREFIX2 YS_VCS_PROMPT_SUFFIX
unset YS_VCS_PROMPT_DIRTY YS_VCS_PROMPT_CLEAN
unset conda_prompt_info virtualenv_prompt_info ys_hg_prompt_info
unset git_info hg_info exit_code # These might be handled by Zsh/OMZ, unsetting defensively
unset ipStr # Keep the variable defined, but unset at end
unset check_network_status network_status # Unset added parts
