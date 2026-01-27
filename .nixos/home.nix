{ config, pkgs, inputs, ... }:

{
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
  programs.home-manager.enable = true;

  programs.bash = {
    enable = true;
    initExtra = ''
      source $HOME/.alias/init
    '';
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
      permittedInsecurePackages = [
        "openssl-1.1.1w"
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
    inputs.zen-browser.packages."${pkgs.stdenv.hostPlatform.system}".default
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
    settings.user.signingKey = "DDB51C1FD6A478F0";
    settings.commit.gpgSign = true;
  };

  programs.claude-code = {
    enable = true;
  };

  programs.direnv = {
    enable = true;
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

  # programs.atuin = {
  #   enable = true;
  #   settings = {
  #     daemon.enabled = true;
  #     daemon.systemd_socket = true;
  #    };
  #   enableBashIntegration = true;
  # };

}

