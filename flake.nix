#https://github.com/Gerschtli/dwm/blob/master/flake.nix
{
  description = "Customized dwm";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ overlay ];
      };
      overlay = final: prev: {
        dwm = prev.dwm.overrideAttrs (old: {
          version = "6.4";
          src = builtins.path { path = ./.; name = "dwm"; };
          buildInputs = with pkgs;[ playerctl i3lock pamixer autorandr ] ++ old.buildInputs;
        });
      };
    in
    {
      overlays.default = overlay;
      packages.${system}.default = pkgs.dwm;
      nixosModules.default = {
        config = {
          services.xserver.windowManager.dwm.enable = true;
          services.xserver.windowManager.dwm.package = pkgs.dwm;
          services.xserver.windowManager.session = pkgs.lib.singleton {
            name = "dwm+aiden";
            start =
              ''
                startdwm &
                waitPID=$!
              '';
          };
        };
      };
    };
}
