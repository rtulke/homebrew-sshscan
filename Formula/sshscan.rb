class Sshscan < Formula
  desc "SSH algorithm security scanner for auditing and compliance checking"
  homepage "https://github.com/rtulke/sshscan"
  url "https://github.com/rtulke/sshscan/archive/refs/tags/v3.5.0.tar.gz"
  sha256 "4ff7ba9e81eb842be7d418d3a258e01d200085b85a37d18180df685b98a1147c"
  license "MIT"

  head "https://github.com/rtulke/sshscan.git", branch: "main"

  depends_on "python@3.12"
  depends_on "pyyaml"

  def install
    libexec.install "sshscan.py"

    (bin/"sshscan").write <<~SHELL
      #!/bin/bash
      exec "#{Formula["python@3.12"].opt_bin}/python3" "#{libexec}/sshscan.py" "$@"
    SHELL
    chmod 0755, bin/"sshscan"
  end

  test do
    assert_match "3.5.0", shell_output("#{bin}/sshscan --version")
    assert_match "NIST", shell_output("#{bin}/sshscan --list-frameworks")
    assert_match "weak", shell_output("#{bin}/sshscan --list-filter")
  end
end
