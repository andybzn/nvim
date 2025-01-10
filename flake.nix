{
  description = "Andy's Neovim Config";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nvf.url = "github:notashelf/nvf";
  };

  outputs =
    {
      self,
      nvf,
      nixpkgs,
      ...
    }:
    let
      supportedSystems = [
        "x86_64-linux"
        "x86_64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          configuredNvim =
            (nvf.lib.neovimConfiguration {
              inherit pkgs;
              modules = [
                {
                  vim = {
                    theme = {
                      enable = true;
                      name = "rose-pine";
                      style = "main";
                    };
                    languages = {
                      enableLSP = true;
                      enableTreesitter = true;
                      go.enable = true;
                      ts.enable = true;
                      nix.enable = true;
                      rust.enable = true;
                      python.enable = true;
                      markdown.enable = true;
                    };
                    statusline.lualine.enable = true;
                    autocomplete.nvim-cmp.enable = true;
                    telescope.enable = true;
                  };
                }
              ];
            }).neovim;
          default = self.packages.${system}.configuredNvim;
        }
      );
    in
    {
      packages = packages;
    };
}
