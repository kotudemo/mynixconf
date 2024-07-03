# nixos config

{ config, lib, pkgs, inputs, modulesPath, ... }:

{
    imports =
    [ (modulesPath + "/installer/scan/not-detected.nix") ];

    boot = {      
        extraModulePackages = [ ];                                # boot options
        kernelPackages = pkgs.linuxPackages_cachyos;               # kernel version and type to boot
        kernelModules = ["nvidia"];                             # kernel modules, like drivers
        loader = {                              # options for bootloaders
            efi = {                             # basic efi options needed for UEFI systems
                canTouchEfiVariables = true;
                efiSysMountPoint = "/boot";
            };
            systemd-boot = {                    # systemd-boot options, see https://nixos.wiki/wiki/Bootloader for more
		        configurationLimit = 5;         # limits of generation
                enable = true;                  # toggle for enabling systemd-boot
                memtest86 = {                   # options for memtest86 or https://www.memtest86.com/
                    enable = true;              
                    sortKey = "o_memtest86";    
                };
                netbootxyz = {                  # options for netbootxyz or https://netboot.xyz/
                    enable = false;
                    sortKey = "o_netbootxyz";
                };
                sortKey = "nixos";              # https://uapi-group.org/specifications/specs/boot_loader_specification/#sorting
            };
        };
        initrd = {
            availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
            kernelModules = [ "kvm-intel" ];
            checkJournalingFS = false;
        };
        supportedFilesystems = [ ];     # supported FSes modules
    };
    fileSystems = {
        "/" = { 
            device = "/dev/disk/by-label/root";
            fsType = "f2fs";       # <= here i reccomend to choose either ext4 or f2fs
        };
        "/mnt/hdd" = {
            device = "/dev/disk/by-label/hdd";
            fsType = "ext4";  
        }
        "/boot" = {
            device = "/dev/disk/by-label/boot";
            fsType = "vfat";
        };

        swapDevices =
            [ { device = "/dev/disk/by-label/swap"; }];
    };
    services = {    # nixos service options
        desktopManager = {
            plasma6.enable = true;         # toggle for KDE Plasma 6
        };
        displayManager = {      
            sddm.enable = true;
        };                  
        printing = {                                 # printing, more here - https://wiki.nixos.org/wiki/Printing
            enable = true;                          # toggle for enabling printing service
        };
        openssh = {                                  # openssh options
            enable = false;                          # toggle for enabling openssh 
            allowSFTP = true;                        # toggle for enabling SFTP  
        };
        xserver = {                                  # xserver options
            enable = true;                           # toggle for enabling xserver
            videoDrivers = ["nvidia"];                      # drivers module
            excludePackages = [ ];                   # option for excluding some packages from basic xserver
            xkb = {                                  # xkb options
                layout = "us, ru";                   # layouts
                variant = "qwerty";                # if your keyboard isn't QWERTY - set it here
                options = "grp:caps_toggle";      # switching method for xkb
            };
        };
        libinput = {                             # libinput options
            enable = true;                          
            mouse = {                            # for mouse 
                accelProfile = "flat";
                accelSpeed = "-1.0";
                buttonMapping = "1 2 3 4 5 6 7 8 9"; # mapping for buttons
                horizontalScrolling = true;
                leftHanded = false;
                naturalScrolling = true;
            };
        };
        pipewire = {
	        enable = true;
	        audio.enable = true;
            alsa = {
                enable = true;
                support32Bit = true;
            };
            pulse = {
                enable = true;
            };
        };
        fstrim.enable = true;
        gvfs.enable = true;
        udisks2.enable = true;
	    automatic-timezoned.enable = true;
    };
    hardware = {
        cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
        bluetooth = { 
            enable = false; 
            powerOnBoot = false;
        };
	    opengl = {
            enable = true;
            driSupport = true;
            driSupport32Bit = true;   
        };
	    nvidia = {
            modesetting.enable = true;
            open = false;
            nvidiaSettings = true;
            package = config.boot.kernelPackages.nvidiaPackages.beta;
            nvidiaSettings = true;
            powerManagement = {
                enable = false;
                finegrained = false;
            };
        };
    };
    i18n = {                                  # basic locale config
        defaultLocale = "en_US.UTF-8";        # i prefer english or US / American 
        extraLocaleSettings = { };            # locale optinos, see https://wiki.archlinux.org/title/Locale
        inputMethod = {
        # enabled = ;
            # see https://search.nixos.org/options?channel=unstable&show=i18n.inputMethod.enabled&from=0&size=50&sort=alpha_asc&type=packages&query=i18n.
        };
        supportedLocales = [
            "en_US.UTF-8/UTF-8"
            "ru_RU.UTF-8/UTF-8"
        ];
    };
    console = {                               # vconsole locales
        colors = [  ];                        # vconsole colors, but i have starship for it
        enable = true;                        # toggle for enabling vconsole
        font = "JetbrainsMono-Regular";                # YES i love hack font
        keyMap = "us";                        # keymap for vconsole
        useXkbConfig = false;                 # toggle for using xkb config, do not use it
    };
    networking = {                              # networking options
        firewall = {                            # firewall options
            allowPing = false;                   # you can restrict ping to your host in case you'll need
            enable = true;                      # toggle for enabling firewall
        };
        hostName = "goidapc";                  # hostname for ur PC
        networkmanager = {                      # NM options
            enable = true;                      # toggle for NM
            dns = "default";                    # dns option for NM
            wifi = {                            # NM toggles for wireless
                backend = "wpa_supplicant";     # backend behind NM wireless
                macAddress = "preserve";        # you can set macaddress
            };
        };
        useDHCP = lib.mkDefault true;                       # DHCP setting. you MUST follow generated hardware-configuration.nix
    };
    security = { 
        polkit.enable = true; 
        rtkit.enable = true;
    };
    nixpkgs = {                             # nixpkgs options
        config = { 
            allowUnfree = true;             # allows unfree pkgs
            allowBroken = false;            # restricts broken pkgs
            config.permittedInsecurePackages = ["python-2.7.18.8" ];
        };
        overlays = [ inputs.polymc.overlay ];                     # overlays in case you have
        system = "x86_64-linux";            # system type
        hostPlatform = "x86_64-linux";      # platform type
    };
    nix = {
        gc = {                                                      # gc = garbage collecting, option for automatic nix-collect-garbage (or nix store gc..)
	     	automatic  = true;                                      # automatic GC
	 	    dates      = "weekly";                                  # how often
	 	    persistent = true;                                      # regulates time by saving it on disk
            randomizedDelaySec = "0";                               # randomize time before GCing 
        };
        settings = {                                                # nix settings, or declorative way to setup nix.conf in /etc/nix/
            allowed-users = [ "kd" "root" ];                    # allowed users to nix-daemon
            experimental-features = [ "nix-command" "flakes" ];     # experimental features, or "ah, now i can use nix store not nix-store"
            sandbox = true;                                         # sandbox, https://discourse.nixos.org/t/what-is-sandboxing-and-what-does-it-entail/15533
            trusted-users = [ "kd" "root" ];                    # trusted to nix-daemon users
        };
    };
    environment = {
        systemPackages = with pkgs; [               # system-wide packages
	        fish
            home-manager
	        gutenprint
	        zip
	        obs-studio
	        obsidian
	        mpv
	        gparted
	        cups
	        canon-cups-ufr2
	        cups-filters
            python3Full
            nodejs
            python.pkgs.pip
            gcc
            gnumake
            jq
            papirus-icon-theme
        ];
        shellAliases =                             # global aliases
            let
                flakeDir = "/etc/nixos";
            in { 
                cl = "clear";
                ls = "eza -aG --color=always";
      	        pf = "clear && nix run nixpkgs#pfetch";
	            ff = "clear && nix run nixpkgs#fastfetch";
	            nf = "clear && nix run nixpkgs#neofetch";
                #unzip = "nix run nixpkgs#unzip -- ";
                #unrar = "nix run nixpkgs#unrar -- ";
                #zip = "nix run nixpkgs#zip -- ";
                sv = "sudo hx";
                v = "hx";
                vi = "hx";
                vim = "hx";
                nvim = "hx";
                git = "nix run nixpkgs#git -- ";
	            btop = "clear && nix run nixpkgs#btop";
	            nsp = "nix-shell -p";
	            ncg = "nix store gc -v && nix-collect-garbage --delete-old";
	            upd = "sudo nix-channel --update nixos && sudo nixos-rebuild switch --upgrade-all --flake ${flakeDir}";
                hms = "home-manager switch --flake ${flakeDir}";
        };
        sessionVariables = {
            WLR_NO_HARDWARE_CURSORS = "1";
	        NIXOS_OZONE_WL = "1";
        };
        variables = {
            EDITOR = "nvim";
            VISUAL = "nvim";
            RANGER_LOAD_DEFAULT_RC = "FALSE";
            QT_QPA_PLATFORMTHEME = "qt5ct";
            #GSETTINGS_BACKEND = "keyfile";
        }; 
    };
    fonts.packages = with pkgs; [
        hack-font
	    noto-fonts
	    noto-fonts-emoji
	    twemoji-color-font
	    font-awesome
	    jetbrains-mono
	    powerline-fonts
        powerline-symbols
        nerdfonts
        miracode
        monocraft
    ];
    users = { 
        defaultUserShell = pkgs.fish;
	    mutableUsers = true;
        # if FALSE you'll need to add every new users with their passwords here.
        users = {
            kd = {
                description = "kotudemo aka GOIDALIZATOR BOL'SHIYE YAICA 777";
                extraGroups = [ "wheel" ]; 
                isSystemUser = false;
                isNormalUser = true;
                initialPassword = "password";
                packages = with pkgs; [
                    #discord
		            vesktop
			vscode
                    spotify
		            spicetify-cli
		            _64gram
                ];
            };
        };
    };
    programs = {
        steam = {
            enable = true;
            remotePlay = {
                openFirewall = true;
            };
            gamescopeSession = {
                enable = true;
            };
        };
        gamemode = {
            enable = true;
        };
        bash = {
 	        interactiveShellInit = ''
    		    if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
    		        then
      			shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
      			exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
    		    fi
  	        '';
        };
        fish = {
            enable = true;
            interactiveShellInit = ''
                set fish_greeting # Disable greeting
            '';
        }; 
    };
    system = {
        stateVersion = "24.11";
    };
}
