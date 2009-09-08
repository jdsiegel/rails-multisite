module Multisite
  module ActionView
    module Helpers
      module AssetTagHelper
        def compute_public_path_with_multisite(source, dir, ext = nil, include_host = true)
          if @controller.current_site
            if ext
              filename = "#{source}.#{ext}"
            else
              filename = source
            end

            if File.exist?(File.join(Multisite::Config.assets_dir, dir, filename))
              return compute_public_path_without_multisite(source, File.join(@controller.current_site, dir), ext, include_host)
            end
          end

          compute_public_path_without_multisite(source, dir, ext, include_host)
        end

        def expand_stylesheet_sources_with_multisite(sources, recursive)
          if sources.first == :site
            collect_asset_files(Multisite::Config.stylesheets_dir, ('**' if recursive), '*.css')
          else
            expand_stylesheet_sources_without_multisite(sources, recursive)
          end
        end

        class << self
          def included(base)
            base.alias_method_chain :compute_public_path, :multisite
            base.alias_method_chain :expand_stylesheet_sources, :multisite
          end
        end
      end
    end
  end
end
    
if Object.const_defined?("ActionView")
  puts "!! including"
  ActionView::Helpers::AssetTagHelper.send(:include, Multisite::ActionView::Helpers::AssetTagHelper)
end
