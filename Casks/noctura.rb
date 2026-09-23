cask "noctura" do
  version "1.5"
  sha256 "72472b4474b42da3c46497d250709bc654952ed7fc7f7da902ef60cf7585dabe"

  url "https://github.com/yusufdiallo1/noctura-releases/releases/download/v#{version}/Noctura-#{version}.dmg"
  name "Noctura"
  desc "Camera for the Mac, wearing the iPhone's interface"
  homepage "https://github.com/yusufdiallo1/noctura-releases"

  depends_on macos: :sonoma
  depends_on arch: :arm64

  app "Noctura.app"

  # Homebrew quarantines what it downloads, and because this app is not
  # notarized Gatekeeper then refuses to launch it — silently, with no dialog
  # and nothing in the log. Clearing the flag here is what makes the installed
  # app open on the first try rather than appearing to do nothing.
  #
  # `must_succeed: false` because a missing flag makes xattr exit non-zero,
  # and that is not a reason to fail an otherwise good install.
  postflight_steps do
    run "/usr/bin/xattr",
        args: ["-dr", "com.apple.quarantine", "{{appdir}}/Noctura.app"],
        writable_paths: ["Noctura.app"], writable_base: :appdir,
        must_succeed: false
  end

  zap trash: [
    "~/Library/Containers/com.yusufdiallo.noctura",
    "~/Library/Application Support/Noctura",
  ]

  caveats <<~CAVEAT
    Noctura needs a few permissions, each asked for when it is first used:

      Camera and Microphone  capture
      Photos                 saving, add-only — it never reads your library
      Screen Recording       only for the Screen tab

    Screen Recording is read once at launch, so quit and reopen the app after
    granting it.
  CAVEAT
end
