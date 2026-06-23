class Minifind < Formula
  desc "minimal find reimplementation"
  homepage "https://github.com/dkorunic/minifind"
  version "0.10.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dkorunic/minifind/releases/download/0.10.0/minifind-aarch64-apple-darwin.tar.xz"
      sha256 "8b701861821d92f0e01f8431dd131bb116bee158b306f3a446edce572d6f1d0c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dkorunic/minifind/releases/download/0.10.0/minifind-x86_64-apple-darwin.tar.xz"
      sha256 "6baa7c1ad57d89483413df78821252b2964de11de2fe3d86ec5f343e881e7d60"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/dkorunic/minifind/releases/download/0.10.0/minifind-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7d6b17bac064693692145439ad4e3cb333353e78426d96c91a21696408c30d17"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dkorunic/minifind/releases/download/0.10.0/minifind-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "28754015f11b67a646a67fa25943259fb0f9e6393dd5bcf066dbbb7aaa14a9aa"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "minifind" if OS.mac? && Hardware::CPU.arm?
    bin.install "minifind" if OS.mac? && Hardware::CPU.intel?
    bin.install "minifind" if OS.linux? && Hardware::CPU.arm?
    bin.install "minifind" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
