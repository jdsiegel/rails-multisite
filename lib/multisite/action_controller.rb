module Multisite
  module ActionController
    class << self    
      def included base #:nodoc:
        base.extend ClassMethods
      end
    end
  
    module ClassMethods
      def acts_as_multisite(options={})
        include InstanceMethods

        def self.page_cache_directory
          read_inheritable_attribute("site_page_cache_directory") || super
        end

        write_inheritable_attribute("site", options[:site]) if options[:site]
        before_filter :setup_site
        helper_method :current_site
      end
    end
  
    module InstanceMethods
      # Retrieves the currently set site
      def current_site
        @current_site ||= self.class.read_inheritable_attribute("site") || determine_site_from_request_host
      end

      protected
      def determine_site_from_request_host
        Multisite::Config.sites.each do |site, config|
          return site if config['host'] == request.host
        end      
        nil
      end

      def set_site_page_cache_directory(app_path)
        self.class.write_inheritable_attribute("site_page_cache_directory", 
                            app_path ? File.join(RAILS_ROOT, app_path, 'cache') : nil)
      end

      def set_site_view_paths(app_path)
        prepend_view_path(File.join(RAILS_ROOT, app_path, 'views')) if app_path
      end

      def setup_site
        return unless current_site and Config.sites[current_site]
      
        logger.info "Activating site: #{current_site}"
      
        app_path = Config.sites[current_site]['app_path']

        set_site_page_cache_directory(app_path)
        set_site_view_paths(app_path)

        asset_host = Config.sites[current_site]['asset_host']
        
        if RAILS_ENV != 'development' and asset_host
          self.class.asset_host = asset_host
        end

        Config.assets_dir = File.join((defined?(Rails.public_path) ? Rails.public_path : "public"), current_site)
        Config.stylesheets_dir = "#{Config.assets_dir}/stylesheets"

        return true
      end    
    end
  end
end

if Object.const_defined?("ActionController")
  ActionController::Base.send(:include, Multisite::ActionController)
end
