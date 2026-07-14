class Sshscan < Formula
  include Language::Python::Virtualenv

  desc "SSH algorithm security scanner for auditing and compliance checking"
  homepage "https://github.com/rtulke/sshscan"
  url "https://github.com/rtulke/sshscan/archive/refs/tags/v3.7.2.tar.gz"
  sha256 "7c34ba2fd7436bda502d796a6fbee018ee9a921d1f394edb6edf738279d3c2df"
  license "MIT"

  head "https://github.com/rtulke/sshscan.git", branch: "main"

  depends_on "python@3.12"

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  def install
    venv = virtualenv_create(libexec, "python3")
    venv.pip_install resource("pyyaml")

    libexec.install "sshscan.py"

    (bin/"sshscan").write <<~SHELL
      #!/bin/bash
      exec "#{libexec}/bin/python3" "#{libexec}/sshscan.py" "$@"
    SHELL
    chmod 0755, bin/"sshscan"
  end

  test do
    assert_match "3.6.4", shell_output("#{bin}/sshscan --version")
    assert_match "NIST", shell_output("#{bin}/sshscan --list-frameworks")
    assert_match "weak", shell_output("#{bin}/sshscan --list-filter")
  end
end
