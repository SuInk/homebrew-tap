cask "sleepcat" do
  version "1.6.15"
  sha256 "3d5aee9260971dd0edb4eb3ec511dc431d1e2823e78f3d50aaa21c2eba300483"

  url "https://github.com/SuInk/sleepcat/releases/download/v#{version}/SleepCat-#{version}.zip"
  name "SleepCat"
  desc "Menu bar cat that keeps the computer awake, even with the lid closed"
  homepage "https://github.com/SuInk/sleepcat"

  depends_on macos: :ventura

  app "SleepCat.app"

  # The app is ad-hoc signed, not notarized, so Gatekeeper would block the first
  # launch of the quarantined download. Clearing it here saves users a manual step.
  postflight_steps do
    run "/usr/bin/xattr",
        args:           ["-dr", "com.apple.quarantine", "{{appdir}}/SleepCat.app"],
        writable_paths: ["SleepCat.app"],
        writable_base:  :appdir
  end

  # zap rather than uninstall: uninstall also runs on every upgrade, which
  # would force re-authorization after each update.
  zap delete: "/etc/sudoers.d/sleepcat",
      trash:  [
        "~/Library/Application Support/SleepCat",
        "~/Library/Logs/SleepCat.log",
        "~/Library/Preferences/cn.suink.sleepcat.plist",
        "~/Library/Preferences/com.earlyso.sleepcat.plist",
        "~/Library/Preferences/com.suink.sleepcat.plist",
      ]

  caveats <<~EOS
    Lid-close mode installs a scoped sudoers rule at /etc/sudoers.d/sleepcat
    on first use. Remove it with `brew uninstall --zap --cask sleepcat`.

    To pick up new versions with a plain `brew upgrade`, trust the tap once:
      brew trust suink/tap
  EOS
end
