cask "sleepcat" do
  version "1.0.0"
  sha256 "ff962287aaea44aef8d300e1bf3ac00b341a59558dca258cccee802db8363d5b"

  url "https://github.com/SuInk/sleepcat/releases/download/v#{version}/SleepCat-#{version}.zip"
  name "SleepCat"
  desc "Menu bar cat that keeps your Mac awake, even with the lid closed"
  homepage "https://github.com/SuInk/sleepcat"

  depends_on macos: :ventura

  app "SleepCat.app"

  # The app is ad-hoc signed, not notarized, so Gatekeeper would block the first
  # launch of the quarantined download. Clearing it here saves users a manual step.
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/SleepCat.app"]
  end

  caveats <<~EOS
    Lid-close mode installs a scoped sudoers rule at /etc/sudoers.d/sleepcat
    on first use. Remove it with `brew uninstall --zap --cask sleepcat`.

    To pick up new versions with a plain `brew upgrade`, trust the tap once:
      brew trust suink/tap
  EOS

  # zap rather than uninstall: uninstall also runs on every upgrade, which
  # would force re-authorization after each update.
  zap delete: "/etc/sudoers.d/sleepcat",
      trash:  [
        "~/Library/Logs/SleepCat.log",
        "~/Library/Preferences/cn.suink.sleepcat.plist",
        "~/Library/Preferences/com.earlyso.sleepcat.plist",
        "~/Library/Preferences/com.suink.sleepcat.plist",
      ]
end
