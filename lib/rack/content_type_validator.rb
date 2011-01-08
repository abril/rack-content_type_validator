require 'json'

module Rack
  class ContentTypeValidator
    autoload :VERSION, 'rack/content_type_validator/version.rb'

    def initialize(app, methods, path, expected_params)
      @app = app
      @methods = handle_methods(methods)
      @path = path
      @expected_params = expected_params
    end

    def call(env)
      if match_path?(env['PATH_INFO']) && match_method?(env['REQUEST_METHOD'])
        content_type = env['CONTENT_TYPE']
        
        unless valid_content_type?(content_type) && valid_charset?(content_type)
          response = Response.new
          response.status = 415
          response.write(error_message)
          response.headers["Content-Type"] = 'text/plain'
          
          return response.finish
        end
      end

      @app.call(env)
    end

    private
      def handle_methods(methods)
        methods = methods.is_a?(Array) ? methods : [methods]
        methods.collect {|m| m.to_s.upcase}
      end
      
      def match_path?(path)
        @path.is_a?(Regexp) ? @path.match(path.to_s) : @path == path.to_s
      end

      def match_method?(method)
        @methods.empty? || @methods.include?(method)
      end
      
      def valid_content_type?(content_type)
        return true unless @expected_params[:mime_type]
        
        type_and_subtype = content_type ? content_type[/^([\w\/]+)\b/, 1] : nil
        type_and_subtype == @expected_params[:mime_type]
      end
      
      def valid_charset?(content_type)
        return true unless @expected_params[:charset]
        
        charset = content_type ? content_type[/\bcharset=([^;\s]*)/, 1] : nil
        charset.gsub!('"', '') if charset
        charset == @expected_params[:charset]
      end
      
      def error_message
        charset = @expected_params[:charset] ? "; charset=#{@expected_params[:charset]}" : ""
        message = "Unsupported Media Type. It should be like this: "
        message += "\"#{@expected_params[:mime_type]}#{charset}\""
      end
  end
end
