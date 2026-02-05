class Emacs < Formula
  desc "GNU Emacs text editor"
  homepage "https://www.gnu.org/software/emacs/"
  # TODO: Bump to use tree-sitter 0.26+ when new Emacs release supports it
  url "https://ftpmirror.gnu.org/gnu/emacs/emacs-30.2.tar.xz"
  mirror "https://ftp.gnu.org/gnu/emacs/emacs-30.2.tar.xz"
  sha256 "b3f36f18a6dd2715713370166257de2fae01f9d38cfe878ced9b1e6ded5befd9"
  license "GPL-3.0-or-later"
  revision 2

  bottle do
    root_url "https://github.com/z-aki/homebrew-tap/releases/download/v2/"
    rebuild 2
    sha256 arm64_tahoe:   "2b52cfbefd013562bbcd8dccff5ff299ac6b8c6258eda79c3647c75b82536d4d"
    sha256 arm64_sequoia: "1528137faaadf7a06d93d22ea18ccba86f12d2fe907e9124dbb3c71bc0e17636"
  end

  head do
    url "https://github.com/emacs-mirror/emacs.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "gnu-sed" => :build
  end

  depends_on "gcc" => :build
  depends_on "pkgconf" => :build
  depends_on "texinfo" => :build
  depends_on "gmp"
  depends_on "gnutls"
  depends_on "libgccjit"
  depends_on "tree-sitter@0.25"

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_linux do
    depends_on "jpeg-turbo"
  end

  conflicts_with cask: "emacs-app"
  conflicts_with cask: "emacs-app@nightly"
  conflicts_with cask: "emacs-app@pretest"

  def install
    gcc_lib="#{HOMEBREW_PREFIX}/lib/gcc/current"
    ENV.append "LDFLAGS", "-L#{gcc_lib}"
    args = %W[
      --disable-acl
      --disable-silent-rules
      --enable-locallisppath=#{HOMEBREW_PREFIX}/share/emacs/site-lisp
      --infodir=#{info}/emacs
      --prefix=#{prefix}
      --with-gnutls
      --without-x
      --with-xml2
      --without-dbus
      --with-modules
      --without-ns
      --without-imagemagick
      --without-selinux
      --with-tree-sitter
      --with-native-comp
    ]

    if build.head?
      ENV.prepend_path "PATH", Formula["gnu-sed"].opt_libexec/"gnubin"
      system "./autogen.sh"
    end

    File.write "lisp/site-load.el", <<~EOS
      (setq exec-path (delete nil
        (mapcar
          (lambda (elt)
            (unless (string-match-p "Homebrew/shims" elt) elt))
          exec-path)))
    EOS

    system "./configure", *args
    system "make", "NATIVE_FULL_AOT=1"
    system "make", "install"

    # Follow MacPorts and don't install ctags from Emacs. This allows Vim
    # and Emacs and ctags to play together without violence.
    (bin/"ctags").unlink
    (man1/"ctags.1.gz").unlink
  end

  service do
    run [opt_bin/"emacs", "--fg-daemon"]
    keep_alive true
  end

  test do
    assert_equal "4", shell_output("#{bin}/emacs --batch --eval=\"(print (+ 2 2))\"").strip
  end
end
