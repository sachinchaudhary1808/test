#my nixos config
{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    # <home-manager/nixos>
    # ./home-manager.nix
  ];

  # Bootloader.
  # boot.loader.systemd-boot.enable = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.loader.grub.useOSProber = true;
  # networking
  networking.hostName = "nixos"; # Define your hostname.
  networking.wireless.enable = true; # Enables wireless support via wpa_supplicant.
  networking.networkmanager.unmanaged = ["wlan0"]; # Replace with actual interface names

  # Dns server
  services.gnome.at-spi2-core.enable = true;

  # what to do when lid is closed
  services.logind.lidSwitch = "suspend";

  #kernel settings
  boot.kernelPackages = pkgs.linuxPackages_latest;

  #zram settings
  zramSwap.enable = true;
  zramSwap.memoryPercent = 200;
  boot.kernel.sysctl."vm.page-cluster" = 0;

  # Gpu settings

  #boot.initrd.kernelModules = [ "amdgpu" ];
  hardware = {
    opengl = {
      enable = true;
      driSupport = true; # amd
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        rocm-opencl-icd # amd
        rocm-opencl-runtime # amd
        rocmPackages.clr.icd
        vaapiVdpau
        libvdpau
        amdvlk
        libva-utils
      ];
      extraPackages32 = with pkgs; [
      ];
    };
  };

  # Swaylock screem
  security.pam.services.waylock = {
    text = ''
      auth include login
    '';
  };

  #power savings
  services.power-profiles-daemon.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_IN";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };

  # Configure keymap in X11
  # services.xserver = {
  #  xkb.layout = "us";
  # xkb.variant = "";
  # enable = true;
  # };

  #systemd.services."getty@tty1".enable = false;
  #systemd.services."autovt@tty1".enable = false;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.coco = {
    isNormalUser = true;
    description = "sachin chaudhary";
    extraGroups = ["networkmanager" "wheel" "video" "kvm" "input"];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowInsecure = true;
  nixpkgs.config.PermittedInsecurePakages = [
    "python-2.7.18.6"
  ];

  services.blueman.enable = true;
  services.gnome.gnome-keyring.enable = true;

  sound.enable = true;

  hardware = {
    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };

  services.xserver.libinput.enable = true;

  services.locate = {
    enable = true;
    localuser = null;
    package = pkgs.mlocate;
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --time-format '%I:%M %p | %a • %h | %F' --cmd sway";
        user = "greeter";
      };
    };
  };
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    swayidle
    greetd.tuigreet
    wlogout
    swaylock-effects
    alejandra
    swaylock
    gnome.cheese
    kitty
    alacritty
    xorg.xmodmap
    libinput
    blueman
    wl-clipboard
    brightnessctl
    android-tools
    playerctl
    xorg.xev
    go-mtpfs
    scrcpy
    cmake
    wbg
    acpi
    xarchiver
    baobab
    transmission-gtk
    cinnamon.warpinator
    tor-browser
    fish
    slurp
    grim
    fzf
    gcc
    htop
    powertop
    git
    gnome.gnome-keyring
    lxqt.lxqt-policykit
    xorg.xhost
    gparted
    qimgv
    dunst
    libnotify
    gtk3
    amdgpu_top
    appimage-run
    pcmanfm
    mpv
    meson
    nitch
    ninja
    networkmanagerapplet
    pavucontrol
    pipewire
    pkg-config
    sddm
    python311
    python311Packages.pip
    qt5.qtwayland
    qt5.qmake
    qt6.qtwayland
    rofi-wayland
    trash-cli
    wlroots
    xdg-desktop-portal-gtk
    xdg-utils
    nodejs_21
    ripgrep
    unzip
    obs-studio
    v4l-utils
  ];

  #polkit service
  security.polkit.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  #Fonts:
  fonts.packages = with pkgs; [
    nerdfonts
    meslo-lgs-nf
  ];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

  #nixpkgs.overlays = [
  #(self: super: {
  # waybar = super.waybar.overrideAttrs (oldAttrs: {
  #	mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
  #	});
  # })
  # ];

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";

    NIXOS_OZONE_WL = "1";
    ACCESSIBILITY_ENABLED = "1";
  };

  #experimantlal features
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # settings of obs
  boot = {
    kernelModules = ["v4l2loopback"];

    extraModulePackages = [
      config.boot.kernelPackages.v4l2loopback
    ];
  };

  home-manager.useGlobalPkgs = true;

  #masked services
  systemd.services.NetworkManager-wait-online.enable = false;
  #xwayland
  programs.xwayland.enable = true;

  #sway

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true; # so that gtk works properly
    extraPackages = with pkgs; [
      sway-audio-idle-inhibit
    ];
    extraSessionCommands = ''
      export MOZ_ENABLE_WAYLAND=1    '';
  };

  security.pam.loginLimits = [
    {
      domain = "@users";
      item = "rtprio";
      type = "-";
      value = 1;
    }
  ];
  # programs.waybar.enable = true;

  environment.variables = {
  };

  virtualisation.waydroid.enable = true;

  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  # Automatic Garbage Collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
}
