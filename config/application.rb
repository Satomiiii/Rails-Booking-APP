# config/application.rb
require_relative "boot"
require "rails/all"

Bundler.require(*Rails.groups)

module BookingApp
  class Application < Rails::Application
    # Rails 6.1 のデフォルト設定
    config.load_defaults 6.1

    # ▼ ここに置く！
    config.time_zone = 'Tokyo'                 # 表示はJST
    config.active_record.default_timezone = :utc  # DBはUTCのまま
  end
end
