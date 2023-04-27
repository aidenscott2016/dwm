# https://github.com/Gerschtli/dwm/blob/master/flake.nix
{
  description = "Customized dwm";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
  inputs.maimpick = {
    url = "github:aidenscott2016/larbs-flake";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, maimpick }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ overlay ];
      };
      overlay = final: prev: {
        dwm = prev.dwm.overrideAttrs (old: {
          version = "6.4";
          src = builtins.path {
            path = ./.;
            name = "dwm";
          };
        });
      };
    in {
      overlays.default = overlay;
      packages.${system}.default = pkgs.dwm;
      nixosModules.default = {
        config = {
          environment.sessionVariables = {
            AIDEN = "COOL";
            _JAVA_AWT_WM_NONREPARENTING = "1";
            AWT_TOOLKIT = "MToolkit";
          };

          services.picom = {
            enable = true;
            vSync = true;
          };
          services.xserver.windowManager = {
            dwm.enable = true;
            dwm.package = pkgs.dwm;
            session = pkgs.lib.singleton {
              name = "dwm+aiden";
              start = ''
                startdwm &
                waitPID=$!
              '';
            };
          };

          programs.light.enable = true;
          environment.systemPackages = with pkgs; [
            maimpick.packages."${system}".maimpick
            arandr
            st
            pavucontrol
            pinentry-gtk2
            pcmanfm
            libnotify
            dunst
            pamixer
            cbatticon
            networkmanagerapplet
            dmenu
            i3lock
            playerctl
            pamixer
            autorandr
            light
          ];
        };
      };
    };
}
