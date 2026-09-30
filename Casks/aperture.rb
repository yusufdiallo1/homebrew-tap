cask "aperture" do
  version "1.64"
  sha256 "769f178ec3c669479bf7f53d7ed71495819cccae462dda4b38cb372436e93272"

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
