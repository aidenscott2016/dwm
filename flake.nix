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
        });
      };
    in
    {
      overlays.default = overlay;
      packages.${system}.default = pkgs.dwm;

      # checks.${system} = {
      #   build = dwm;

      #   version = nixpkgs.legacyPackages.${system}.runCommand "version-check" { } ''
      #     dwm_version="$(${dwm}/bin/dwm -v 2>&1 || :)"
      #     echo "package version: ${dwm.name}"
      #     echo "dwm version:     $dwm_version"
      #     [[ "${dwm.name}" == "$dwm_version" ]]
      #     touch ${placeholder "out"}
      #   '';
      # };
      nixosModules.default = {
        config = {
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
