{
  description = "Nix flake templates for Reamer";

  outputs =
    { ... }:
    {
      templates = {
        rust = {
          path = ./templates/rust;
          description = "Rust flake template";
        };
      };
    };
}
