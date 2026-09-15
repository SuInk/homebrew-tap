cask "sleepcat" do
  version "1.2.2"
  sha256 "c86fbe553257312dcbd0c3e71696d5e54a1f7d070425f75829aadf8b120c26e5"

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
