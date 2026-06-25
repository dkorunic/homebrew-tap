class Minifind < Formula
  desc "minimal find reimplementation"
  homepage "https://github.com/dkorunic/minifind"
  version "0.10.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dkorunic/minifind/releases/download/0.10.1/minifind-aarch64-apple-darwin.tar.xz"
      sha256 "53e7fc37740a9877bae7c67089bd11a4134818e808b291bdd93a3d20e7e814ba"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dkorunic/minifind/releases/download/0.10.1/minifind-x86_64-apple-darwin.tar.xz"
      sha256 "d34f8c2e01e44f021274c91a9b4009e0fc1b1a0dfb3924bbd7a65db8e130d5dc"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/dkorunic/minifind/releases/download/0.10.1/minifind-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5cf4dbc9440743b845b9327dce2a82462a323decdb9dd31ab68371532a2499e7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dkorunic/minifind/releases/download/0.10.1/minifind-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f41b1113fde9e04d1f77daf364f5b4d88ed453d51b4603536a53764a9a5b972b"
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
