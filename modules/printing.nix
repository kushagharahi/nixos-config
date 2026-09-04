{pkgs, ...}: {
  services.printing = {
    enable = true;
    drivers = [pkgs.brlaser];
  };

  hardware.printers = {
    ensurePrinters = [
      {
        name = "Brother_HL-2070N";
        location = "Local Printer";
        # Use 'socket' for the most reliable connection
        deviceUri = "socket://192.168.1.56:9100";
        model = "drv:///brlaser.drv/br2140.ppd";
        description = "Brother HL-2070N (Static IP)";
      }
    ];
  };
}
