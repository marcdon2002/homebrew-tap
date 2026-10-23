class AmberShell < Formula
  desc "Compact inline Zsh assistant with ChatGPT authentication"
  homepage "https://github.com/marcdon2002/amber-shell"
  url "https://github.com/marcdon2002/amber-shell/releases/download/v0.8.1/amber-shell-0.8.1-aarch64-apple-darwin.tar.gz"
  sha256 "9ab434c5985b11157e0d3417ffe01fed060201a56f23acede304fdf37650a169"
  license "MIT"

  depends_on arch: :arm64
  depends_on macos: :ventura

  def install
    bin.install "bin/amber-shell"
    pkgshare.install Dir["share/amber-shell/*"]
    (bin/"amber-shell-setup").write <<~SH
      #!/bin/sh
      exec /bin/sh "#{opt_pkgshare}/install.sh" --shell-only --migrate --prefix "#{opt_prefix}" "$@"
    SH
    chmod 0755, bin/"amber-shell-setup"
  end

  def caveats
    <<~EOS
      Enable the Zsh integration once (backs up your startup files):
        amber-shell-setup

      Install the official Codex CLI if needed:
        brew install --cask codex

      Sign into Amber with ChatGPT after setup:
        amber-shell login
      Amber can reuse an existing Codex installation. Its login is separate
      from your personal Codex login; sign into Amber once even if Codex
      is already signed in. amber-shell logout signs out only Amber.

      Open a new terminal window, then press Ctrl-X followed by Ctrl-A.
    EOS
  end

  test do
    assert_equal "amber-shell #{version}\n", shell_output("#{bin}/amber-shell --version")
    assert_match "Inline chat", shell_output("#{bin}/amber-shell --help")
    system "/bin/zsh", "-n", pkgshare/"amber-shell.zsh"
    system "/bin/zsh", "-n", pkgshare/"amber-session.zsh"
    (testpath/"zsh").mkpath
    with_env(ZDOTDIR: testpath/"zsh") do
      system bin/"amber-shell-setup"
      system bin/"amber-shell-setup"
      assert_match opt_prefix.to_s, (testpath/"zsh/.zshenv").read
      assert_match opt_prefix.to_s, (testpath/"zsh/.zshrc").read
    end
  end
end
