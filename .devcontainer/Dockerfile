ARG VERSION="37"
FROM fedora:${VERSION}
ARG VERSION

RUN dnf -y install git 'dnf-command(config-manager)'
RUN dnf config-manager --add-repo="https://raw.githubusercontent.com/terrapkg/subatomic-repos/main/tau1.repo"
RUN dnf -y install libhelium-devel gcc vala vala-devel meson desktop-file-utils starship tau-starship tau-hydrogen muon gdb blueprint-compiler tau-manrope-fonts libsoup3-devel json-glib-devel

# Temporary fix until we get nightly packages for vala-language-server in Terra
RUN git clone https://github.com/vala-lang/vala-language-server.git
RUN meson setup builddir vala-language-server
RUN meson compile -C builddir
RUN meson install -C builddir

RUN useradd -m vscode
RUN echo vscode ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/vscode
USER vscode
