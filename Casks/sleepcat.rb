cask "sleepcat" do
  version "1.0.0"
  sha256 "ff962287aaea44aef8d300e1bf3ac00b341a59558dca258cccee802db8363d5b"

  url "https://github.com/SuInk/sleepcat/releases/download/v#{version}/SleepCat-#{version}.zip"
  name "SleepCat"
  desc "Menu bar cat that keeps your Mac awake, even with the lid closed"
  homepage "https://github.com/SuInk/sleepcat"

  depends_on macos: ">= :ventura"

  app "SleepCat.app"

  caveats <<~EOS
    SleepCat is ad-hoc signed (not notarized). If macOS blocks it, run:
      xattr -dr com.apple.quarantine /Applications/SleepCat.app

    Lid-close mode installs a scoped sudoers rule at /etc/sudoers.d/sleepcat
    on first use. Remove it with `brew uninstall --zap --cask sleepcat`.
  EOS

  # zap rather than uninstall: uninstall also runs on every upgrade, which
  # would force re-authorization after each update.
  zap delete: "/etc/sudoers.d/sleepcat",
      trash:  [
        "~/Library/Logs/SleepCat.log",
        "~/Library/Preferences/com.suink.sleepcat.plist",
      ]
end
