class Findlargedir < Formula
  desc "find all blackhole directories with a huge amount of filesystem entries in a flat structure"
  homepage "https://github.com/dkorunic/findlargedir"
  version "0.14.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dkorunic/findlargedir/releases/download/0.14.0/findlargedir-aarch64-apple-darwin.tar.xz"
      sha256 "ea3883934f069f4f285581157f6b337a3d9412f08b9ca59df6330b608a99ddb3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dkorunic/findlargedir/releases/download/0.14.0/findlargedir-x86_64-apple-darwin.tar.xz"
      sha256 "6c26b953b3fa68ec2d78d0e8bc9285c32441afbcaf5e54cd71f20d03f019d939"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/dkorunic/findlargedir/releases/download/0.14.0/findlargedir-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3b0c3c8e70c9e5e3072b85d51c685ad1883dbe458ee9359ee9c8d447468b6245"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dkorunic/findlargedir/releases/download/0.14.0/findlargedir-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "32c104cbe1da8112d788befeb0e5baaaa34a6a8d723fd675043d1a1c582344b6"
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
