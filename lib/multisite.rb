module Multisite
  mattr_accessor :current_site
  
  class Config
    cattr_accessor :sites, :assets_dir, :stylesheets_dir
  end
end  

require 'multisite/action_controller'
require 'multisite/action_controller/routing'
require 'multisite/action_mailer'
require 'multisite/action_view/helpers/asset_tag_helper'
require 'multisite/active_record'

class ActiveRecord::SiteNotFound < Exception; end
