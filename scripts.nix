{
  perSystem =
    { self', pkgs, ... }:
    {
      packages = {
        edict = pkgs.writeShellApplication {
          name = "edict";
          runtimeInputs = [
            pkgs.nix
            pkgs.jq
          ];

          text = ''
            if nix flake metadata --json 2>/dev/null | jq -e '.locks.nodes.monarch' >/dev/null; then
              echo "🦋 Updating monarch input..."
              nix flake update monarch --no-warn-dirty
              echo "✅ Monarch input updated successfully!"
            else
              echo "❌ Error: This flake does not have a \`monarch' input" >&2
              echo "Please add monarch to your flake inputs and add the \`edict' app to the \`apps' output." >&2
              exit 1
            fi
          '';
        };
      };

      apps = {
        edict = {
          type = "app";
          program = "${self'.packages.edict}/bin/edict";
          meta.description = "Script for updating monarch flake input. Only intended to be used by contributors.";
        };
      };
    };
}
