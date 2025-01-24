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
                      clang.enable = true;
                      python.enable = true;
                      markdown.enable = true;
                    };
                    ui = {
                      borders.enable = true;
                      illuminate.enable = true;
                    };
                    comments = {
                      comment-nvim.enable = true;
                    };
                    statusline.lualine.enable = true;
                    autocomplete.nvim-cmp.enable = true;
                    telescope.enable = true;
                    options.conceallevel = 2;
                    startPlugins = with pkgs.vimPlugins; [
                      nvim-cmp
                      plenary-nvim
                    ];
                    lazy.plugins = {
                      "harpoon2" = {
                        package = pkgs.vimPlugins.harpoon2;
                        setupModule = "harpoon";
                      };
                      "obsidian.nvim" = {
                        package = pkgs.vimPlugins.obsidian-nvim;
                        setupModule = "obsidian";
                        setupOpts = {
                          workspaces = [
                            {
                              name = "docs";
                              path = "~/vaults/docs/";
                            }
                            {
                              name = "work";
                              path = "~/vaults/work";
                            }
                          ];
                          notes_subdir = "notes";
                        };
                      };
                      "no-neck-pain.nvim" = {
                        package = pkgs.vimPlugins.no-neck-pain-nvim;
                        setupModule = "no-neck-pain";
                        setupOpts = {
                          buffers = {
                            wo = {
                              fillchars = "eob: ";
                            };
                          };
                        };
                      };
                    };
                    keymaps = [
                      {
                        key = "<leader>nn";
                        mode = "n";
                        action = "<cmd>NoNeckPain<CR>";
                      }
                      {
                        key = "<leader>td";
                        mode = "n";
                        action = "<cmd>ObsidianToday<CR>";
                      }
                    ];
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
