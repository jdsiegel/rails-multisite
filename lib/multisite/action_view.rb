module Multisite
  module ActionView
    module Helpers
      module AssetTagHelper
        def compute_public_path_with_multisite(source, dir, ext = nil, include_host = true)
          if @controller.current_site
            compute_public_path_without_multisite(source, "#{@controller.current_site}/#{dir}", ext, include_host)
          else
            compute_public_path_without_multisite(source, dir, ext, include_host)
          end
        end
        
        class << self
          def included(base)
            base.alias_method_chain :compute_public_path, :multisite
          end
        end
      end
    end
  end
end
    
if Object.const_defined?("ActionView")
  ActionView::Helpers::AssetTagHelper.send(:include, Multisite::ActionView::Helpers::AssetTagHelper)
end
