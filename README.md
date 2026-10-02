# Homebrew tap

```bash
brew tap yusufdiallo1/tap
brew install cappture
```

The first line is needed once. After it, `brew install cappture` and
`brew upgrade cappture` work on their own.

## Cappture

A camera for the Mac wearing the iPhone's interface, with screenshots,
screen recording, and editing. It saves to its own library and, if you
ask it to, to Photos.

**[Repository and releases →](https://github.com/yusufdiallo1/cappture)**

The cask clears the quarantine flag as it installs, so the app opens
without the right-click dance an unnotarized app would otherwise need.

## Updating

```bash
brew upgrade cappture
```

The app also updates itself: it checks hourly and offers the new version
when one appears.

## Uninstalling

```bash
brew uninstall --cask cappture
```

Your captures are not touched — they live in your captures folder, not in
the app.

## Why a tap and not `brew install cappture` on its own

A bare name resolves only for casks in homebrew/cask, Homebrew's own
repository. Getting in needs a pull request there and clearing a
notability bar that a new, unnotarized app does not. A tap is the
ordinary way to ship outside it.
