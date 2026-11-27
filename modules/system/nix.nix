{ ... }:

{
  # Cache
  nix.settings = {      
    substituters = [
      "https://nix-cache.duxlabs.dev"
      "https://nix-community.cachix.org"
    ];

    trusted-public-keys = [
      "dux-1:lrBykuzHKu9F6WsCbK83C9/uOrfqUY1kflRZtrUcMF0="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  # Truster user
  nix.settings.trusted-users = [
    "root"
    "azcos"
  ];

  
}