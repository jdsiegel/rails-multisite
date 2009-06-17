module Multisite
  class Config
    cattr_accessor :sites, :assets_dir, :stylesheets_dir
  end
end  

require 'multisite/action_controller'
require 'multisite/action_mailer'
require 'multisite/action_view'
