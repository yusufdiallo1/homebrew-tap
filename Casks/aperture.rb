cask "aperture" do
  version "2.03"
  sha256 "1d9a1c97378932892bac9d62d85e5b6a2662c65c39b0986a693566d5aa2edad2"

  url "https://github.com/yusufdiallo1/cappture/releases/download/v#{version}/Cappture-#{version}.dmg"
  name "Cappture"
  desc "Camera for the Mac, wearing the iPhone's interface"
  homepage "https://github.com/yusufdiallo1/cappture"

  # The app is called Cappture. This name is kept so that anyone who ran
  # `brew install aperture` before the rename still gets updates rather
  # than silently stopping at the last version under the old name.
  #
  # It installs the same app from the same image; only the token differs.
  depends_on macos: :sonoma
  depends_on arch: :arm64

  app "Cappture.app"

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
