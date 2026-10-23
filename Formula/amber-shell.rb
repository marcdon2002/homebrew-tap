class AmberShell < Formula
  desc "Compact inline Zsh assistant with ChatGPT authentication"
  homepage "https://github.com/marcdon2002/amber-shell"
  url "https://github.com/marcdon2002/amber-shell/releases/download/v0.7.3/amber-shell-0.7.3-aarch64-apple-darwin.tar.gz"
  sha256 "0e3e68edc6fff34b2cf73a98337a78a56eeadfe4b1052db1d577ebaea6edce09"
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
      Open a new terminal window, then press Ctrl-X followed by Ctrl-A.

      Amber uses the official Codex CLI with your ChatGPT login:
        brew install --cask codex
        amber-shell login
      Existing Codex installations and logins can be reused.
    EOS
  end

  test do
    assert_equal "amber-shell #{version}\n", shell_output("#{bin}/amber-shell --version")
    assert_match "Inline-Dialog", shell_output("#{bin}/amber-shell --help")
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
