{ config, lib, ... }:

{
  options.hostSpec = {
    hostname = lib.mkOption {
      type = lib.types.str;
      description = "Name of the machine";
    };

    username = lib.mkOption {
      type = lib.types.str;
      description = "Primary user of the machine";
    };

    homeDirectory = lib.mkOption {
      type = lib.types.str;
      default = "/home/${config.hostSpec.username}";
      description = "Home directory of the primary user";
    };

    stateVersion = lib.mkOption {
      type = lib.types.str;
      default = "26.05";
      description = "State version of the system";
    };
  };
}