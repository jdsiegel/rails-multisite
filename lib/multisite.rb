module Multisite
  mattr_accessor :current_site, :assets_dir, :stylesheets_dir
  
  class Config
    cattr_accessor :sites#, :assets_dir, :stylesheets_dir
  end

  class SiteNotFound < Exception; end
end  

require 'multisite/action_controller/base'
#require 'multisite/action_controller/route_set'
#require 'multisite/action_mailer'
#require 'multisite/action_view/helpers/asset_tag_helper'
require 'multisite/active_record'

