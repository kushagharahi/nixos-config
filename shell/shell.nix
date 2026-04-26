{pkgs, ...}: let
  # 2. The "Let" block (Define your variables/pins here)
  kubectl-plugin-src = pkgs.fetchFromGitHub {
    owner = "ohmyzsh";
    repo = "ohmyzsh";
    rev = "a79b37b95461ea2be32578957473375954ab31ff"; # Example commit hash for pinning
    sha256 = "sha256-zkk+8BhoXPJcelJ0nua6Gpa603pg4cWWX0OurOxeElQ=";
  };
in {
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    initContent = ''
      # Enable prompt substitution (crucial!)
      setopt prompt_subst
      # Load the built-in Version Control info module
      autoload -Uz vcs_info
      # Tell vcs_info to check for staged (+) and unstaged (*) changes
      zstyle ':vcs_info:*' check-for-changes true
      zstyle ':vcs_info:*' unstagedstr '%F{red}*%f'
      zstyle ':vcs_info:*' stagedstr '%F{green}+%f'

      # 2. Set the format: (Branch|Action StagedUnstaged)
      # %b = branch
      # %a = action (merge/rebase/etc)
      # %u = unstaged (*)
      # %c = staged (+)
      zstyle ':vcs_info:git:*' formats '%F{yellow}(%b%u%c)%f '
      zstyle ':vcs_info:git:*' actionformats '%F{yellow}(%b|%F{red}%a%F{yellow}%u%c)%f '
      # Update the info before every prompt display
      precmd() { vcs_info }

      # %n = username | %~ = current directory (shortened) | %# = '%' for users, '#' for root
      PROMPT='%F{green}%n%f:%F{blue}%~%f ''${vcs_info_msg_0_}%# '

      source ${kubectl-plugin-src}/plugins/kubectl/kubectl.plugin.zsh
      source <(kubectl completion zsh)
    '';
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    historyWidgetOptions = [
      "--sort"
      "--exact"
      "--height=40%"
      "--layout=reverse"
      "--border"
    ];
  };

  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 11;
    };
    settings = {
      scrollback_lines = 10000;
    };
    extraConfig = ''
      # Any raw kitty.conf text goes here
      background_opacity 0.9
      tab_bar_edge top
      tab_bar_style powerline
      tab_powerline_style slanted
      remember_window_size  yes
      remember_window_position yes
    '';
    settings = {
      shell = "zsh"; # Explicitly tells Kitty to use Zsh
    };
  };

  programs.bash = {
    enable = true;
  };

  home.shellAliases = {
    "code" = "codium";
  };
}
