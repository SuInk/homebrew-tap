cask "sleepcat" do
  version "1.6.9"
  sha256 "1338b7a83f924ac961d36000a90e52fd275de5e1060fb5ecc7c8878036e4e984"

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
