# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  # boot.loader.systemd-boot.enable = true;
  boot = {
    loader = {
      systemd-boot = {
        enable = false;
      };
      grub = {
        enable = true;
	device = "nodev";
	efiSupport = true;
	useOSProber = true;
      };
      efi = {
        canTouchEfiVariables = true;
      };
    };
  };

  networking.wg-quick.interfaces = {
    w0 = {
      configFile = "/etc/wireguard/wg0.conf";
    };
  };

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Bucharest";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ro_RO.UTF-8";
    LC_IDENTIFICATION = "ro_RO.UTF-8";
    LC_MEASUREMENT = "ro_RO.UTF-8";
    LC_MONETARY = "ro_RO.UTF-8";
    LC_NAME = "ro_RO.UTF-8";
    LC_NUMERIC = "ro_RO.UTF-8";
    LC_PAPER = "ro_RO.UTF-8";
    LC_TELEPHONE = "ro_RO.UTF-8";
    LC_TIME = "ro_RO.UTF-8";
  };

  # Configure keymap in X1r1
  services = {
    xserver = {
      enable = true;
      xkb = {
        layout = "us";
        variant = "";
      };
      wacom = {
        enable = true;
      };
      videoDrivers = [ "nvidia" ]; # Load nvidia drivers for Xorg and Wayland
    };
    displayManager = {
      # sddm = {
      #   enable = false;
      #   theme = "chili";
      # };
      ly = {
        enable = true;
	# wayland = true;
      };
    };
    blueman = {
      enable = true;
    };
    upower = {
      enable = true;
    };
    power-profiles-daemon = {
      enable = true;
    };
  };

  hardware = {
    graphics = {
      enable = true; # Enable OpenGL
      enable32Bit = true;
    };

    nvidia = {
      modesetting.enable = true; # Required
      powerManagement.enable = false;
      powerManagement.finegrained = false;

      # Use the NVidia open source kernel module (not the 'nouveau' third party open source driver)
      # Should only be set to false if you have a GPU with an older architecture than Turing (older than the RTX 20-Series).
      open = false; 

      # Enable the Nvidia settings menu, accessible via `nvidia-settings`.
      nvidiaSettings = true;

      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    # messes up on hyprland i think
    # but it needs to run for osu!lazer to detect tablet in game and handle it.. as well as 'input' and 'floppy' groups for user to be in
    # xd?!
    opentabletdriver = {
      enable = true;
      # then, to start the otd-daemon
      # systemctl --user enable opentabletdriver.service
      # systemctl --user start opentabletdriver.service
    };
   
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.stefan = {
    isNormalUser = true;
    description = "stefan";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "input" # for opentabletdriver to have rights to access tablet
      "floppy" # line above doesn't work.. tablet is assigned at /dev/hidraw* to floppy(id=18) and udev rule doesn't change it so have to do this for otd to have rights to access it
    ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  programs = {
    hyprland = {
      enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    (writeShellScriptBin "wg-toggle" ''
      CONFIG_NAME="wg0"
      if wg show "$CONFIG_NAME" &>/dev/null; then
          echo "VPN is active. Bringing it down..."
          wg-quick down "$CONFIG_NAME"
      else
          echo "VPN is inactive. Bringing it up..."
          wg-quick up "$CONFIG_NAME"
      fi
    '')
    sddm-chili-theme # login screen sddm theme

    # general commands
    git
    git-filter-repo
    eza
    pulseaudio # audo: pactl
    pavucontrol # pulse audio volume control
    efibootmgr
    wget
    acpi # check battery power
    usbutils
    wev # check code of a pressed key
    libnotify
    ripgrep # for nvim grep
    killall
    fastfetch

    # programming languages interpretors/compilers
    python3
    gcc # also for nvim.treesitter
    nodejs_24 # also for nvim Mason:pyright
    go

    # terminal
    ghostty
    lazygit
    lazydocker
    zellij

    # required for nvim
    neovim
    unzip
    fzf # for fuzzy finder
    wl-clipboard # for clipboard provider

    # hypr ecosystem
    hyprpaper # wallpaper
    hyprsunset # blue-light filter
    hyprpolkitagent # polkit auth agent
    grim
    slurp
    brightnessctl
    playerctl
    # sound
    pipewire
    wireplumber
    # notification daemon
    dunst
    adwaita-icon-theme
    waybar
    btop
    walker

    # my apps
    firefox
    discord
    spotify
    calibre
    obsidian

    # job apps
    teams-for-linux # ew
    wireguard-tools
    pgadmin4

    # osu
    zenity
    osu-lazer-bin
    osu-lazer
    libwacom
    libinput
  ];

  fonts.packages = with pkgs; [
    inter
    noto-fonts
    nerd-fonts.noto
  ];

  virtualisation.docker = {
    enable = true;
  };
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
