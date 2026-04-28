{pkgs, ...}: let
  kubectl-plugin-src = pkgs.fetchFromGitHub {
    owner = "ohmyzsh";
    repo = "ohmyzsh";
    rev = "a79b37b95461ea2be32578957473375954ab31ff";
    sha256 = "sha256-zkk+8BhoXPJcelJ0nua6Gpa603pg4cWWX0OurOxeElQ=";
  };
in {
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;

    # Make up and down keys do a substring search
    historySubstringSearch.enable = true;
    initExtra = ''
      bindkey "''${terminfo[kcuu1]}" history-substring-search-up
      bindkey "''${terminfo[kcud1]}" history-substring-search-down
    '';

    plugins = [
      {
        name = "kubectl";
        src = kubectl-plugin-src;
        file = "plugins/kubectl/kubectl.plugin.zsh";
      }
    ];

    initContent = ''
      # Add Pure prompt to fpath (Nix store path)
      fpath+=( "${pkgs.pure-prompt}/share/zsh/site-functions" )

      autoload -U promptinit; promptinit
      prompt pure
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
