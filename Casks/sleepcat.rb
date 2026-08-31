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
    SleepCat is ad-hoc signed (not notarized). If macOS blocks it, either
    install with --no-quarantine, or run:
      xattr -dr com.apple.quarantine /Applications/SleepCat.app

    The optional lid-close mode installs a scoped sudoers rule at
    /etc/sudoers.d/sleepcat (removable from the app's menu).
  EOS

  zap trash: [
    "~/Library/Logs/SleepCat.log",
    "~/Library/Preferences/com.suink.sleepcat.plist",
  ]
end
