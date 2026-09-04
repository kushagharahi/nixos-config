{...}: {
  networking = {
    hostName = "nixos";
    networkmanager = {
      enable = true;
      settings.main.rc-manager = "resolvconf";
    };
  };

  # Resolve homelab stuff with local DNS
  services.resolved = {
    enable = true;
    settings = {
      Resolve = {
        DNS = "192.168.1.241";
        Domains = "kusha.me";
      };
    };
  };
}
