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
      pkgs = nixpkgs.legacyPackages."x86_64-linux";
    in
    {
      packages."x86_64-linux".configuredNvim =
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

      packages."x86_64-linux".default = self.outputs.packages."x86_64-linux".configuredNvim;
    };
}
