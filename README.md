# Rack Content-Type Validator middleware

Rack::ContentTypeValidator it's a **rack middleware** to validate the header **Content-Type** of requests.

## What does it do?

When a ruby webserver receives a request, it validates the Content-Type. Whenever validation fails, the middleware sends a response to client with 415 (Unsupported Media Type) HTTP error.
    
## Usage

### Rails apps

In your Gemfile:
 
    gem 'rack-content_type_validator'
In your environment.rb:

    require 'rack/content_type_validator'
    config.middleware.use Rack::ContentTypeValidator

### Non-Rails apps

Just 'use Rack::ContentTypeValidator' as any other middleware.

## Configuration Examples

#### POST requests at the path '/posts' should be 'application/json':
    config.middleware.use Rack::ContentTypeValidator, :post, '/posts', {:mime_type => "application/json"}

#### POST and PUT requests at the path '/users' should be 'application/json':
    config.middleware.use Rack::ContentTypeValidator, [:post, :put], '/users', {:mime_type => "application/json"}

#### POST requests at the path '/pages' should be 'application/xml' with charset UTF-8:
    config.middleware.use Rack::ContentTypeValidator, :post, '/pages', {:mime_type => "application/xml", :charset => "UTF-8"}

#### PUT requests at the path '/pages' should have charset ISO-8859-1:
    config.middleware.use Rack::ContentTypeValidator, :put, '/pages', {:charset => "ISO-8859-1"}

#### You can pass a Regexp on path:
    config.middleware.use Rack::ContentTypeValidator, :put, /\/pages\/.+/, {:charset => "ISO-8859-1"}
    
#### You can configure more the one:
    config.middleware.use Rack::ContentTypeValidator, :post, '/posts', {:mime_type => "application/json"}
    config.middleware.use Rack::ContentTypeValidator, :put, /\/posts\/.+/, {:mime_type => "application/json"}

## Report bugs and suggestions

  * [Issue Tracker](http://github.com/abril/rack-content_type_validator/issues)

## Authors

 * [Lucas Fais](http://github.com/lucasfais)
 * [Marcelo Manzan](http://github.com/kawamanza)
 
## References

 * [RFC 2616](http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.17)
 * [Rails on Rack](http://guides.rubyonrails.org/rails_on_rack.html)
 