{
  self,
  config,
  lib,
  pkgs,
  ...
}:
let
  # wrapper for steam to force xwayland
  steamXwayland = pkgs.writeShellScriptBin "steam" ''
    export DISPLAY=:0
    exec ${pkgs.steam}/bin/steam "$@"
  '';
  wallpaper = ./wallpapers/fight_break_sphere.png;
  dotfiles = config.lib.file.mkOutOfStoreSymlink /persist/dotfiles;
  secrets = config.lib.file.mkOutOfStoreSymlink /persist/secrets;
  steam = config.lib.file.mkOutOfStoreSymlink /persist/steam;
  fonts = config.lib.file.mkOutOfStoreSymlink /persist/fonts;
in
{
  home.packages = with pkgs; [
    # media
    mpv
    firefox
    ani-cli
    cmus

    # fancy
    starship

    # dev
    neovim
    jujutsu
    universal-ctags
    nixfmt-rfc-style
    marksman

    # terminal
    foot
    yazi
    bat
    ripgrep
    eza
    fd

    # wm stuff
    # niri
    wl-clipboard
    grim
    satty
    slurp
    swayimg
    fuzzel
    steamXwayland

    # fonts
    recursive
    noto-fonts
    noto-fonts-emoji
    noto-fonts-cjk-sans
    font-awesome
    nerd-fonts.symbols-only
  ];

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.rose-pine-cursor;
    name = "BreezeX-RosePine-Linux";
    size = 100;
  };

  # theme
  stylix = {
    base16Scheme = "${pkgs.base16-schemes}/share/themes/kanagawa-dragon.yaml";
    image = "${wallpaper}";

    fonts = {
      serif = {
        package = pkgs.recursive;
        name = "Recursive Mono Casual";
      };

      sansSerif = {
        package = pkgs.recursive;
        name = "Recursive Mono Casual";
      };

      monospace = {
        package = pkgs.recursive;
        name = "Recursive Mono Casual";
      };

      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };

      sizes = {
        terminal = 22;
        applications = 18;
        desktop = 21;
      };
    };
  };

  stylix.targets.foot.enable = false;

  programs.direnv = {
      enable = true;
      enableBashIntegration = true;
  };

  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "Comic Code:size=32, PowerlineExtraSymbols:size=34, Symbols Nerd Font:size=32";
        dpi-aware = "no";
        box-drawings-uses-font-glyphs="yes";
      };

      mouse = {
        hide-when-typing = "yes";
      };

      cursor = {
        color = "dcd7ba dcd7ba";
      };

      colors = {
        foreground = "f0f0f0";
        background = "181616";

        regular0 = "0d0c0c"; # black
        regular1 = "c4746e"; # red
        regular2 = "8a9a7b"; # green
        regular3 = "c4b28a"; # yellow
        regular4 = "8ba4b0"; # blue
        regular5 = "a292a3"; # magenta
        regular6 = "8ea4a2"; # cyan
        regular7 = "c8c093"; # white

        bright0 = "a6a69c"; # bright black
        bright1 = "e46876"; # bright red
        bright2 = "87a987"; # bright green
        bright3 = "e6c384"; # bright yellow
        bright4 = "7fb4ca"; # bright blue
        bright5 = "a895c7"; # bright magenta
        bright6 = "7aa89f"; # bright cyan
        bright7 = "dcd7ba"; # bright white

        selection-foreground = "181616";
        selection-background = "c8c093";

        search-box-no-match = "11111b f38ba8";
        search-box-match = "cdd6f4 313244";

        jump-labels = "11111b fab387";
        urls = "89b4fa";
      };

    };
  };

  home.file.".local/share/fonts".source = "${fonts}";

  home.file.".config/niri".source = "${dotfiles}/niri";
  home.file.".config/nvim".source = "${dotfiles}/nvim";
  home.file.".config/git".source = "${dotfiles}/git";
  home.file.".config/jj".source = "${dotfiles}/jj";
  home.file.".config/starship.toml".source = "${dotfiles}/starship.toml";
  home.file.".config/cmus".source = "${dotfiles}/cmus";
  # home.file.".config/zellij".source = "${dotfiles}/zellij";

  home.file.".mozilla".source = "${secrets}/firefox";
  home.file.".ssh".source = "${secrets}/ssh";

  home.file.".steam".source = "${steam}/steam";
  home.file.".local/state/wireplumber".source = "${dotfiles}/wireplumber";

  xdg.mimeApps.defaultApplications = {
    enable = true;
    "image/*" = [ "swayimg.desktop" ];
    "video/*" = [ "mpv.desktop" ];
  };

  programs.bash = {
    enable = true;
    profileExtra = ''
      	if [ -z "''${WAYLAND_DISPLAY}" ] && [ "''${XDG_VTNR}" -eq 1 ] && [[ -z "$NIRI_STARTED" ]]; then
      	   export NIRI_STARTED=1;
      	   exec niri-session
      	fi
      	'';
    bashrcExtra = ''
      eval "$(starship init bash)"
    '';
  };

  home.sessionVariables = {
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
    EDITOR = "nvim";
    SHELL = "bash";

    ANI_CLI_HIST_DIR = "/persist/anime-history";
    MY_NIX_CONFIG = "/persist/nixconfig";
  };

  home.shellAliases = {
    # prevent accidents
    rm = "rm -I";

    # nice cli alternatives
    cat = "bat";
    find = "fd";
    ls = "eza --icons";
    grep = "rg";

    nixconfig = "sudo nixos-rebuild switch --flake $MY_NIX_CONFIG";
  };

  # wallpaper
  services.wpaperd = {
    enable = true;
    settings = {
      any = {
        path = config.stylix.image;
      };
    };
  };
  # notifications
  services.dunst = {
    enable = true;
  };

  xdg.portal = {
    enable = true;
    config.common.default = "*";
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  home.stateVersion = "25.05";
}
