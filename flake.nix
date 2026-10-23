{
  description = "Reproducible reference builds of frostdart's Rust library (hrf-api)";

  inputs.dnix.url = "github:slopbot9k/dnix";

  outputs = { self, dnix, ... }: dnix.lib.package {
    src = self;
    config = ./dnix.json;
  };
}
