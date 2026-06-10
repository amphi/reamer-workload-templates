# Rust Template

After initializing a project from this template:

1. Run `cargo init --name="user provided name"`
2. Run `cargo build` at least once to create `Cargo.lock`
3. Commit all files to git, otherwise `nix build` will not work

## Useful Commands

- `nix develop` to enter the development shell
- `nix build` to build the project with Nix
- `cargo check` for a fast Rust-only validation pass

## Project Layout

- Put your application code in `src/main.rs`
- Keep the flake at the repository root

## Notes

- This template expects the repository to be under git version control
- If you change the package name, make sure it stays consistent with the Cargo project name
