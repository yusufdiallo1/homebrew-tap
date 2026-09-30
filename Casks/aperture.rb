cask "aperture" do
  version "1.65"
  sha256 "3b51db145ce7e3ece86c52c5ef74b9f1e385b3ec77dd25884e34acf47f51274c"

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
