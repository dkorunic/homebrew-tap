class Findlargedir < Formula
  desc "find all blackhole directories with a huge amount of filesystem entries in a flat structure"
  homepage "https://github.com/dkorunic/findlargedir"
  version "0.13.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dkorunic/findlargedir/releases/download/0.13.0/findlargedir-aarch64-apple-darwin.tar.xz"
      sha256 "927a1ef9c3d7ba351854c46dfb03c89a233c8feaf332880d122bd48d0c727902"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dkorunic/findlargedir/releases/download/0.13.0/findlargedir-x86_64-apple-darwin.tar.xz"
      sha256 "a3a3be8d7049777c9cd8020bd35607041a45180e9e5f32e5edd34717719eab14"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/dkorunic/findlargedir/releases/download/0.13.0/findlargedir-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6910080bece4977471e18648270c73f8e83611157217b85a9764082e3070bfc0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dkorunic/findlargedir/releases/download/0.13.0/findlargedir-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "378df0d383549d053dc6dced2860731cd2b2e34dc8b7119de6dc8cd24fdf0929"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
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
    bin.install "findlargedir" if OS.mac? && Hardware::CPU.arm?
    bin.install "findlargedir" if OS.mac? && Hardware::CPU.intel?
    bin.install "findlargedir" if OS.linux? && Hardware::CPU.arm?
    bin.install "findlargedir" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
