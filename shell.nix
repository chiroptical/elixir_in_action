{pkgs, ...}:
pkgs.mkShell {
  buildInputs =
    (with pkgs; [
      alejandra
    ])
    ++ (with pkgs.beam.packages.erlang_27; [
      erlang
      elixir
    ]);
}
