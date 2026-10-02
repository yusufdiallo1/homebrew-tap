cask "cappture" do
  version "1.96"
  sha256 "391d4f16b84f487484cbd2b264871c4b637e396fa6cdc159376d7f90b2e1268b"

  url "https://github.com/yusufdiallo1/cappture/releases/download/v#{version}/Cappture-#{version}.dmg"
  name "Cappture"
  desc "Camera for the Mac, wearing the iPhone's interface"
  homepage "https://github.com/yusufdiallo1/cappture"

  depends_on macos: :sonoma
  depends_on arch: :arm64

  app "Cappture.app"

  # Homebrew quarantines what it downloads, and because this app is not
  # notarized Gatekeeper then refuses to launch it — silently, with no dialog
  # and nothing in the log. Clearing the flag here is what makes the installed
  # app open on the first try rather than appearing to do nothing.
  #
  # `must_succeed: false` because a missing flag makes xattr exit non-zero,
  # and that is not a reason to fail an otherwise good install.
  postflight_steps do
    run "/usr/bin/xattr",
        args: ["-dr", "com.apple.quarantine", "{{appdir}}/Cappture.app"],
        writable_paths: ["Cappture.app"], writable_base: :appdir,
        must_succeed: false

    # Reopen it, if it was open.
    #
    # brew replaces the files and leaves whatever was running alone, so
    # after an upgrade the old process carries on with its own bundle
    # gone — it offers updates it already has and behaves like the
    # version it no longer is. Quitting and reopening puts the app that
    # was just installed on screen.
    #
    # Only when it was already running: nobody wants an installer to
    # open an app they were not using.
    run "/bin/sh",
        args: ["-c",
               "if pgrep -x Cappture >/dev/null 2>&1; then " \
               "osascript -e 'quit app \"Cappture\"' >/dev/null 2>&1; " \
               "for i in 1 2 3 4 5 6 7 8 9 10; do " \
               "pgrep -x Cappture >/dev/null 2>&1 || break; sleep 0.5; done; " \
               "open -a '{{appdir}}/Cappture.app' >/dev/null 2>&1; fi"],
        must_succeed: false
  end

  zap trash: [
    "~/Library/Containers/com.yusufdiallo.aperture",
    "~/Library/Application Support/Aperture",
  ]

  caveats <<~CAVEAT
    Cappture needs a few permissions, each asked for when it is first used:

      Camera and Microphone  capture
      Photos                 saving; full access only if you delete from the app
      Screen Recording       only for the Screen tab

    Screen Recording is read once at launch, so quit and reopen the app after
    granting it.
  CAVEAT
end
