{ config, pkgs, ...}:

{
    home = {
        username = "kd";
        homeDirectory = "/home/kd";
        stateVersion = "24.05";
        shellAliases = {
           f = "nix run nixpkgs#fastfetch" 
        };
        packages = with pkgs; [
            # feel free to add here
        ];
        pointerCursor = {
            # name = "";
            # package = with pkgs; [ ];
            # size = 32;
            # gtk.enable = false;
            # x11 = {
            #    enable = false;
            #    defaultCursor = "left_ptr";
            # };
        };
    };
    programs = {
        eza = {                    # about eza - https://github.com/eza-community/eza
            enable = true;                  # enabling toggle
            enableBashIntegration = true;   # integration with bash
            enableFishIntegration = true;   # integration with fish
            enableZshIntegration = true;    # integration with zsh
            icons = true;
        };
        foot = {                    # about foot - https://codeberg.org/dnkl/foot
            enable = true;                   # enabling toggle
            settings = { };                  # settings for foot, or config itself 
        };
        helix = {                     # about helix - https://helix-editor.com/
            defaultEditor = true;              # toggle for making it default editor
            enable = true;
            ignores = [ "!.gitignore" ];                     # enabling toggle
            settings = {
                theme = "kanagawa";
                editor = {
                    line-number = "relative";
                    filepicker = {
                        hidden = true;
                        follow-symlinks	= true;
                        deduplicate-links = true;
                        parents	= true;
                        ignore = true;
                        git-ignore = true;
                        git-global = true;
                        git-exclude	= true;
                    };
                    lsp = {
                        enable = true;
                        display-messages = true;
                    };
                    indent-guides = {
                        render = true;
                    };
                    cursor-shape = {
                        normal = "block";
                        insert = "bar";
                        select = "underline";
                    };
                    statusline = {
                        mode.normal = "NORMALCOCK";
                        mode.insert = "ZHIDKOSRAL";
                        mode.select = "DVASTYLA";
                        left = ["mode", "spinner"];
                        center = ["read-only-indicator", "file-name"];
                        right = ["file-type",  "position", "position-percentage", "diagnostics", "file-encoding"];
                        separator = "│";
                    };
                };
            };
        };
        starship = {
            enable = true;                  # enabling toggle
            enableBashIntegration = true;   # integration with bash
            enableFishIntegration = true;   # integration with fish
            enableZshIntegration = true;
            enableTransience = true;    # integration with zsh
            settings = {
                # Get editor completions based on the config schema
                "$schema" = 'https://starship.rs/config-schema.json'
            
                # Inserts a blank line between shell prompts
                add_newline = true
            
                [hostname]
                ssh_only = false
                format = '[$ssh_symbol$hostname]($style) '
                style = 'bold purple'
            
                # Replace the '❯' symbol in the prompt with '➜'
                [character] # The name of the module we are configuring is 'character'
                success_symbol = '[ >_< ](bold green)' # The 'success_symbol' segment is being set to '➜' with the color 'bold green'
                error_symbol = '[ >_< ](bold red)'
            
                [username]
                show_always = true
                format = '[$user]($style)@'
            
                [directory]
                read_only = ' 🔒'
                truncation_symbol = '…/'
            
                # Disable the package module, hiding it from the prompt completely
                [package]
                disabled = true
            };                 
        };
        ungoogled-chromium = {
            enable = true;
        };      
    };
}
