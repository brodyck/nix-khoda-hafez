{ config, lib, pkgs, options, ... }:
with builtins;
with lib.strings;
with lib.attrsets;
let
# This gets a list of all '.nix' files in a given folder (excludes '.nix~')
nixInFolder = dir: map (x: dir + "/" + x) (attrNames (filterAttrs (name: _: hasSuffix ".nix" name) (readDir dir)));
in
{
  imports = nixInFolder "/etc/nixos/cfg/net-interfaces";
  networking = {
    hostName = "khoda-hafez";
    hostId = "beef0dad";
    # global dhcp while im working on it as the interface names change.
    useDHCP = true;
    nameservers = [ "192.168.69.1" "8.8.8.8" "1.1.1.1" ];    
    firewall = {
      # this is just for while im working on it.
      enable = false;
#      allowedTCPPorts = [      ];
#      allowedUDPPorts = [      ];
     allowPing = true;
    };
    iproute2 = {
      enable = true;
    };

    defaultGateway = {
      address = "192.168.69.1";
      interface = "br-net0";
      metric = 100;
    };
#    localCommands = '' ''    
  };
  environment = {
    systemPackages = with pkgs; [
      iproute
      ethtool
      lldpd
    ];
  };
}