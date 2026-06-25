{
  description = "A very basic flake adapted for Ubuntu (Non-NixOS)";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    ...
  }: let
    system = "x86_64-linux";
    user = "quang"; # Lưu ý: Đổi đúng theo username trên Ubuntu của anh

    hostMain = {
      hostname = "ubuntu-nix"; # Tên định danh cấu hình (không ảnh hưởng hostname thật của Ubuntu)
      stateVersion = "25.11"; # Hoặc 24.11 tùy thuộc vào config cũ của anh
    };
    # pkgs = nixpkgs.legacyPackages.${system};
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    # Thay thế nixosConfigurations bằng homeConfigurations độc lập
    homeConfigurations."${user}" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      # Truyền các tham số đặc biệt vào file home.nix y hệt cấu hình cũ của anh
      extraSpecialArgs = {
        inherit inputs hostMain user;
        catppuccin = inputs.catppuccin;
      };

      modules = [
        ./home.nix
      ];
    };
  };
}
