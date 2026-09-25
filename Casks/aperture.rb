cask "aperture" do
  version "1.20"
  sha256 "5e4b9bc9f40bc8eb8218a535148cc20b93958dff9e04450f89a6f167a88e3e6e"

  url "https://github.com/yusufdiallo1/aperture/releases/download/v#{version}/Aperture-#{version}.dmg"
  name "Aperture"
  desc "Camera for the Mac, wearing the iPhone's interface"
  homepage "https://github.com/yusufdiallo1/aperture"

  depends_on macos: :sonoma
  depends_on arch: :arm64

  app "Aperture.app"

  # Homebrew quarantines what it downloads, and because this app is not
  # notarized Gatekeeper then refuses to launch it — silently, with no dialog
  # and nothing in the log. Clearing the flag here is what makes the installed
  # app open on the first try rather than appearing to do nothing.
  #
  # `must_succeed: false` because a missing flag makes xattr exit non-zero,
  # and that is not a reason to fail an otherwise good install.
  postflight_steps do
    run "/usr/bin/xattr",
        args: ["-dr", "com.apple.quarantine", "{{appdir}}/Aperture.app"],
        writable_paths: ["Aperture.app"], writable_base: :appdir,
        must_succeed: false
  end

  zap trash: [
    "~/Library/Containers/com.yusufdiallo.aperture",
    "~/Library/Application Support/Aperture",
  ]

  caveats <<~CAVEAT
    Aperture needs a few permissions, each asked for when it is first used:

      Camera and Microphone  capture
      Photos                 saving, add-only — it never reads your library
      Screen Recording       only for the Screen tab

    Screen Recording is read once at launch, so quit and reopen the app after
    granting it.
  CAVEAT
end
