# Homebrew tap

```bash
brew install --cask yusufdiallo1/tap/camera
```

## Camera

A camera for the Mac, wearing the iPhone's interface. Six capture modes,
screen recording, photo and video editing, and it saves straight to Photos.

**[Repository and documentation →](https://github.com/yusufdiallo1/noctura)**

The cask clears the quarantine flag as part of installing, so the app opens
without the right-click dance an un-notarized app would otherwise need.

## Uninstalling

```bash
brew uninstall --cask noctura          # removes the app
brew uninstall --zap --cask noctura    # also removes settings and cached captures
```

Captures already saved to your Photos library stay there either way.
