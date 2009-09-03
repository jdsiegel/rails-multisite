module Multisite
  module ActionController
    module Base
      def self.included(base) #:nodoc:
        base.class_eval do
          prepend_before_filter :set_site
          helper_method :current_site
        end
      end
  
      # Retrieves the currently set site
      def current_site
        Multisite.current_site
      end

    protected
      def determine_site_from_request_host
        Config.sites.each do |site, config|
          return site if config['host'] == request.host
        end      
        raise SiteNotFound
      end
  
      def set_site
        current_site = determine_site_from_request_host
 
        logger.info "Activating site: #{current_site}"
    
        app_path = Config.sites[current_site]['app_path']
    
        if app_path
          [self, ::ActionController::Base].each do |o|
            o.page_cache_directory = File.join(RAILS_ROOT, app_path, 'cache') 
            o.view_paths = [File.join(RAILS_ROOT, app_path, 'views'), File.join(RAILS_ROOT, 'app', 'views')]
          end
        end

        asset_host = Config.sites[current_site]['asset_host']
      
        if RAILS_ENV != 'development' and asset_host
          self.class.asset_host = asset_host
        end

        Multisite.current_site = current_site
        Multisite.assets_dir = File.join((defined?(Rails.public_path) ? Rails.public_path : "public"), current_site)
        Multisite.stylesheets_dir = "#{Multisite.assets_dir}/stylesheets"

        return true
      end
    end
  end
end

ActionController::Base.send :include, Multisite::ActionController::Base
