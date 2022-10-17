{
  description = "taskobs: a tool to export taskwarrior info into an Obsidian page";

  inputs.nixpkgs.url = "nixpkgs/nixos-22.05";

  outputs = { self, nixpkgs }:
    let
      supportedSystems =
        [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
    in {
      overlay = final: prev: {
        taskobs = self.packages.${prev.system}.taskobs;
      };
      packages = forAllSystems (system:
        let pkgs = nixpkgsFor.${system};
        in {
          taskobs = pkgs.stdenv.mkDerivation {
            pname = "taskobs";
            version = "v0.0.1";
            src = ./.;
            buildInputs = with pkgs.perlPackages; [ perl PerlTidy ];
            nativeBuildInputs = with pkgs.perlPackages; [ perl JSON ];

            installPhase = ''
              mkdir -p $out/bin
              install taskobs.pl $out/bin/taskobs
            '';
          };
        });

      defaultPackage = forAllSystems (system: self.packages.${system}.taskobs);
      devShells = forAllSystems (system:
        let pkgs = nixpkgsFor.${system};
        in {
          default = pkgs.mkShell {
            shellHook = ''
              PS1='\u@\h:\@; '
              echo "Perl `${pkgs.perl}/bin/perl --version`"
            '';
            buildInputs = with pkgs.perlPackages; [ PerlTidy ];
            nativeBuildInputs = with pkgs.perlPackages; [ perl JSON ];
          };
        });
    };
}

