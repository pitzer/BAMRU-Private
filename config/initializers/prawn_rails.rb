require 'prawn'

if Prawn::VERSION == "0.8.4"
  require 'prawn/layout'
  require 'prawn/security'
end

module Prawn
  module Rails
    
    module PrawnHelper
      
      def prawn_document(opts={})
        download = opts.delete(:force_download)
        filename = opts.delete(:filename)
        pdf = (opts.delete(:renderer) || Prawn::Document).new(opts)
        yield pdf if block_given?
        
        disposition(download, filename) if (download || filename)
        
        pdf
      end
      
      def disposition(download, filename)
        download = true if (filename && download == nil)
        disposition = download ? "attachment;" : "inline;"
        disposition += " filename=#{filename}" if filename
        headers["Content-Disposition"]=disposition
      end
      
    end
    
    class TemplateHandler

      def self.call(template)
        "#{template.source.strip}.render"        
      end
      
    end
    
  end
end

#commented this for rails 3.2.8
#Mime::Type.register_alias "application/pdf", :pdf
ActionView::Template.register_template_handler(:prawn, Prawn::Rails::TemplateHandler)
ActionView::Base.send(:include, Prawn::Rails::PrawnHelper)
