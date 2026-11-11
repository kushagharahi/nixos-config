{...}: {
  services.flatpak = {
    enable = true;
    packages = [
      "org.mozilla.firefox"
    ];
    update.auto = {
      enable = true;
      onCalendar = "daily";
    };
    overrides.settings = {
      "org.mozilla.firefox" = {
        Context.filesystems = [
          "xdg-download"
          "~/Downloads"
        ];
      };
    };
  };
}
