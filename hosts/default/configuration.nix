
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
    ];

  # Bootloader.
  # boot.loader.systemd-boot.enable = true;
  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      devices = [ "nodev" ];
      efiSupport = true;
      useOSProber = true;
      gfxmodeEfi = "1920x1080";
      fontSize = 36;
      #font = "${pkgs.hack-font}/share/fonts/hack/Hack-Regular.ttf"; # I guess you can change the fonts? 
    };
  };
  
  networking.hostName = "GOD-KILLER"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Toronto";
  time.hardwareClockInLocalTime = true;  

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enabling Nix Flakes
  nix.settings.experimental-features = ["nix-command" "flakes" ];

  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  }; 

  # Enable Nvidia Drivers
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia= {
  	modesetting.enable = true;
        powerManagement.enable = false;
  	powerManagement.finegrained = false;
	open = false;
	nvidiaSettings = true;
	package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Enable Bluetooth support
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Enable the KDE Plasma Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;

  # Enable Gnome Desktop Environment
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Enabling Hyprland
  programs.hyprland = {
    enable = true;
   # nvidiaPatches = true; apparenetly no longer has an effect
    xwayland.enable = true; 
  };

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1"; # supposed to prevent cursor from going invisable but doesnt?
    NIXOS_OZONE_WL = "1"; # lets electron app use wayland
  };

  xdg.portal.enable = true;
  #xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ]; # add packages or tweak this if there is an issue

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.cairo = {
    isNormalUser = true;
    description = "Cairo Cristante";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox
    #  kate
    #  thunderbird
    ];
  };

  home-manager = {
    # also pass inputs to home-manager modules
    extraSpecialArgs = {inherit inputs;};
    users = {
      "cairo" = import ./home.nix;
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     
     # Terminals
     alacritty 
     kitty 
     starship

     # Terminal Stuff
     vim
     neovim
     wget
     neofetch
     git
     fzf
     fd
     bat
     delta
     eza
     zoxide
     nix-search-cli
    
     # Gnome Extensions/Tweaks
     gnome.gnome-shell-extensions
     gnome.gnome-tweaks
     gnomeExtensions.unite
     
     # hyprland -> TODO: MOVE TO home.nix along with hyprland configs in this file
     waybar 
     # if waybar workspaces dont work -> (pkgs.waybar.overrideAttrs (oldAttrs: { mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ]; }))
     dunst
     libnotify
     swww # wallpaper daemon, alternatives are hyprpaper, swaybg, wpaperd, mpvpaper     
     rofi-wayland # alternative is wofi   # Alternative App Launchers: bemenu, fuzzel, tofi
     wofi
     networkmanagerapplet
     blueman
     pamixer # hyprland audio control?, alernatively try osd
     brightnessctl # hyprland brightness control
     playerctl # hyprland media player control


     # Programs/Program Adjacent
     libsForQt5.dolphin #KDE file manger
     whatsapp-for-linux
     vscode
     obsidian
     libsForQt5.okular # KDE pdf reader
     audacity # audio editor
     gimp # photoshop but free
     steam
     brave
     openrgb # open source rgb control
     obs-studio

     # Libre Office
     libreoffice-qt # libre office
     hunspell # spell checker for libre office
     hunspellDicts.fr-any
     hunspellDicts.en_CA-large     
     
     # Trying out Discord Options
     discord
     vesktop # used to make discord screen sharing work
     armcord # alternative discord client
     betterdiscord-installer # another discord client
     betterdiscordctl    
     discordo # discord terminal client

     # Trying out Spotify Options
     spotify
     spotifyd # alternative spotify terminal client
     psst # alternative spotify client
     spot # alternative spotify client
     spicetify-cli # terminal modder for normal spotify     

     # Other
     nerdfonts

  ];

  # Fix discord force automatic update
  # nixpkgs.overlays = [(self: super: { discord = super.discord.overrideAttrs (_: { src = builtins.fetchTarball https://discord.com/api/download?platform=linux&format=tar.gz; });})];
 
  # Eletron is being weird because of obsidian so this should fix?
  nixpkgs.config.permittedInsecurePackages = [
   "electron-25.9.0"
  ];
  
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
  system.stateVersion = "23.11"; # Did you read the comment?

}
