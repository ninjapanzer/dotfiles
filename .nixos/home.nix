{ config, pkgs, inputs, ... }:
{

  imports = [ inputs.keepawake.homeModules.default ];

  # Home Manager needs a bit of information about you and the
  # paths it should manage.

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "25.11";

  # Let Home Manager install and manage itself.
  programs.home-manager = {
    enable = true;
  };

  programs.keepawake = {
    enable = true;
  };

  programs.bash = {
    enable = true;
    initExtra = ''
      export GPG_TTY=$(tty)
      source $HOME/.alias/init
      # Claude Code loads the burl mod, told which notebook's MCP server to use.
      claude() {
        local server=""
        case "$PWD" in
          "$HOME"/repos/burl*)        server=burl-burl ;;
          "$HOME"/repos/adaptive-ui*) server=burl-aperture ;;
          "$HOME"/repos/beamlet*)     server=burl-beamlet ;;
          "$HOME"/repos/solar*)       server=burl-solar ;;
        esac
        if [ -n "$server" ]; then
          BURL_MCP_SERVER=$server command claude --plugin-dir "$HOME/repos/burl/claude-mod" "$@"
        else
          command claude "$@"
        fi
      }
    '';
  };

  nixpkgs = {
    overlays = [
      inputs.claude-code.overlays.default
      inputs.codex-cli.overlays.default
    ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
      permittedInsecurePackages = [
        "openssl-1.1.1w"
        "electron-39.8.10"
      ];
    };
  };

  home.sessionPath = [
    "$HOME/.bin"
    "$HOME/.bin/zen"
  ];

  home.packages = [
    pkgs.vim
    pkgs.sublime4
    inputs.rhythmboxFixed.legacyPackages."${pkgs.stdenv.hostPlatform.system}".rhythmbox
    pkgs.picard
    pkgs.bitwarden-desktop
    pkgs.jetbrains-toolbox
    pkgs.vcsh
    pkgs.chromaprint
    pkgs.unzip
    pkgs.logseq
    pkgs.github-cli
    inputs.burl.packages.${pkgs.system}.default
    inputs.burl.packages.${pkgs.system}.burl-mcp
    inputs.burl.packages.${pkgs.system}.burl-backend
    inputs.beamlet.packages.${pkgs.system}.beamlet
    inputs.zen-browser.packages."${pkgs.stdenv.hostPlatform.system}".default
    inputs.kwike.packages."${pkgs.stdenv.hostPlatform.system}".default
    pkgs.bazelisk
    (pkgs.writeShellScriptBin "bazel" ''exec ${pkgs.bazelisk}/bin/bazelisk "$@"'')
    pkgs.binutils
    pkgs.gcc
  ];

  programs.gpg.enable = true;
  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 34560000;
    maxCacheTtl = 34560000;
    pinentry.package = pkgs.pinentry-tty;
  };

  xdg.desktopEntries = {};

  programs.git = {
    package = pkgs.gitFull;
    enable = true;
    settings.user.name = "Paul Scarrone";
    settings.user.email = "paul@scarrone.co";
    settings.user.signingKey = "BC3E62DF1F32BF65";
    settings.commit.gpgSign = true;
    settings.credential.helper = "libsecret";
    settings.sendemail = {
      from = "paul@scarrone.co";
      smtpserver = "127.0.0.1";
      smtpserverport = 1025;
      smtpencryption = "ssl";
      smtpuser = "paulscoder@tutanota.com";
      smtpsslcertpath = "";
    };
  };

  programs.claude-code = {
    enable = true;
  };

  programs.codex = {
    enable = true;
  };

  programs.direnv = {
    enable = true;
  };

  programs.zellij = {
    enable = true;
    package = inputs.nixpkgsUnstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.zellij;
  };

  programs.kitty = {
    enable = true;
    settings = {
      confirm_os_window_close = 0;
      dynamic_background_opacity = true;
      enable_audio_bell = false;
      mouse_hide_wait = "-1.0";
      window_padding_width = 10;
      background_opacity = "0.5";
      background_blur = 5;
    };
  };

  # Trading desk: unattended, read-only Claude runs. The script decides which
  # tools a run may use; what each run does is a runbook note in the burl
  # notebook (~/trading/trading-desk.burl, Research > Runbooks).
  systemd.user.services.desk-morning = {
    Unit.Description = "Trading desk morning run: dip check and daily report (read-only)";
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash %h/trading/bin/desk-run morning";
      # jq is for the failure note the script writes when a run dies.
      Environment = [ "PATH=${pkgs.lib.makeBinPath [ pkgs.jq pkgs.coreutils ]}:%h/.nix-profile/bin:/run/current-system/sw/bin" ];
    };
  };
  systemd.user.timers.desk-morning = {
    Unit.Description = "Trading desk morning run, weekdays 8:27 AM Eastern";
    Timer = {
      # Persistent: a run missed while the box was off happens at next start.
      OnCalendar = "Mon..Fri *-*-* 08:27:00 America/New_York";
      Persistent = true;
    };
    Install.WantedBy = [ "timers.target" ];
  };

  systemd.user.services.desk-watch = {
    Unit.Description = "Trading desk trade watch: order status into the burl notebook (read-only)";
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash %h/trading/bin/desk-run watch";
      Environment = [ "PATH=${pkgs.lib.makeBinPath [ pkgs.jq pkgs.coreutils ]}:%h/.nix-profile/bin:/run/current-system/sw/bin" ];
    };
  };
  systemd.user.timers.desk-watch = {
    Unit.Description = "Trading desk trade watch, weekdays hourly during market hours (Eastern)";
    Timer = {
      # Not persistent: a missed hourly check is not worth running late.
      OnCalendar = "Mon..Fri *-*-* 09..16:37:00 America/New_York";
    };
    Install.WantedBy = [ "timers.target" ];
  };

  # programs.atuin = {
  #   enable = true;
  #   settings = {
  #     daemon.enabled = true;
  #     daemon.systemd_socket = true;
  #    };
  #   enableBashIntegration = true;
  # };

}

