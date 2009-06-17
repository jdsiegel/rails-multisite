module Multisite
  module ActionView
    module Helpers
      module AssetTagHelper
        def site_image_path(source)
          if @controller.current_site
            compute_public_path(source, "#{@controller.current_site}/images")
          else
            compute_public_path(source, "images")
          end
        end
      end
    end
  end
end
    
if Object.const_defined?("ActionView")
  ActionView::Helpers::AssetTagHelper.send(:include, Multisite::ActionView::Helpers::AssetTagHelper)
end
