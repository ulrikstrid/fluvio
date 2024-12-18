{ pkgs, lib, config, inputs, ... }:

{
  # https://devenv.sh/basics/
  env.CARGO_MANIFEST_DIR = "crates/fluvio-version-manager";

  # https://devenv.sh/packages/
  packages = with pkgs; [ git kubernetes-helm openssl ];

  # https://devenv.sh/languages/
  languages.rust.enable = true;
  languages.zig.enable = true;

  # https://devenv.sh/processes/
  # processes.cargo-watch.exec = "cargo-watch";

  # https://devenv.sh/services/
  # services.postgres.enable = true;

  # https://devenv.sh/scripts/
  scripts.hello.exec = ''
    echo hello from $GREET
  '';

  enterShell = ''
    hello
    git --version
  '';

  # https://devenv.sh/tasks/
  # tasks = {
  #   "myproj:setup".exec = "mytool build";
  #   "devenv:enterShell".after = [ "myproj:setup" ];
  # };

  # https://devenv.sh/tests/
  enterTest = ''
    echo "Running tests"
    make build-{cli,cluster,test,channel,smdk,cdk,fbm,fvm}

    cargo fmt -- --check
    cargo test --all-features
    cargo build --all-features
    cargo clippy --all-targets --all-features -- -D warnings
    cargo doc --no-deps

    make run-all-{doc-test,unit-test}

    cargo run --manifest-path release-tools/check-crate-version/Cargo.toml -- --crates-dir crates --publish-list-path release-tools/check-crate-version/publish-list.toml

    ./release-tools/check-publish-crates.sh
  '';

  # https://devenv.sh/pre-commit-hooks/
  # pre-commit.hooks.shellcheck.enable = true;

  # See full reference at https://devenv.sh/reference/options/
}
