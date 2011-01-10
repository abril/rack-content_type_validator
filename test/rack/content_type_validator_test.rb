require File.expand_path(File.dirname(__FILE__) + '/../test_helper.rb')

class ContentTypeValidatorTest < Test::Unit::TestCase
  
  App = lambda { |env| [200, {'Content-Type' => 'text/plain'}, Rack::Request.new(env)] }
  
  def build_env(method, path, content_type)
    env = Rack::MockRequest.env_for(path, {:method => method})
    env["CONTENT_TYPE"] = content_type
    env
  end
  
  def build_middleware(methods, path, expected_params)
    Rack::ContentTypeValidator.new(App, methods, path, expected_params)
  end
  
  def test_request_in_other_paths
    expected_params = {:mime_type => "application/xml"}
    middleware = build_middleware(:put, "/other/path", expected_params)
    
    env = build_env("PUT", "/request_path", 'application/json')
    status, headers, body = middleware.call(env)

    assert_equal 200, status
  end

  def test_incorrect_content_type
    path = "/users"

    expected_params = {:mime_type => "application/xml"}
    middleware = build_middleware([:put, :post], path, expected_params)
    
    env = build_env("PUT", path, 'application/json')
    status, headers, body = middleware.call(env)

    assert_equal 415, status
  end
  
  def test_correct_content_type
    path = "/posts"
    
    expected_params = {:mime_type => "application/json"}
    middleware = build_middleware(:post, path, expected_params)
    
    env = build_env("POST", path, 'application/json')
    status, headers, body = middleware.call(env)

    assert_equal 200, status
  end

  def test_correct_content_type_scope
    path = "/posts"

    expected_params = {:mime_type => ["application/json", "application/xml"]}
    middleware = build_middleware(:post, path, expected_params)

    env = build_env("POST", path, 'application/json')
    status, headers, body = middleware.call(env)
    assert_equal 200, status

    env = build_env("POST", path, 'application/xml')
    status, headers, body = middleware.call(env)
    assert_equal 200, status
  end
  
  def test_correct_content_type_and_incorrect_charset
    path = "/comments"
    
    expected_params = {:mime_type => "text/plain", :charset => "iso-8859-x"}
    middleware = build_middleware(:post, path, expected_params)
    
    env = build_env("POST", path, 'text/plain; charset=us-ascii')
    status, headers, body = middleware.call(env)

    assert_equal 415, status
  end
  
  def test_correct_content_type_and_charset
    path = "/posts"
    
    expected_params = {:mime_type => "application/json", :charset => "UTF-8"}
    middleware = build_middleware("POST", path, expected_params)
    
    env = build_env("POST", path, 'application/json; charset=UTF-8')
    status, headers, body = middleware.call(env)

    assert_equal 200, status
  end
  
  def test_correct_content_type_and_charset_not_given
    path = "/posts"
    
    expected_params = {:mime_type => "application/json"}
    middleware = build_middleware([:post], path, expected_params)
    
    env = build_env("POST", path, 'application/json; charset=UTF-8')
    status, headers, body = middleware.call(env)

    assert_equal 200, status
  end
  
  def test_regexp_on_path
    expected_params = {:mime_type => "application/json", :charset => "UTF-8"}
    middleware = build_middleware(:post, /comments/, expected_params)
    
    env = build_env("POST", "/content/1/comments", 'application/json; charset=UTF-8')
    status, headers, body = middleware.call(env)

    assert_equal 200, status
  end
  
  def test_charset_with_quotes
    expected_params = {:charset => "UTF-8"}
    middleware = build_middleware(:post, /comments/, expected_params)
    
    env = build_env("POST", "/content/1/comments", 'application/xml; charset="UTF-8"')
    status, headers, body = middleware.call(env)

    assert_equal 200, status
  end
  
  def test_others_params_like_type
    expected_params = {:type => "application/xml"}
    middleware = build_middleware(:post, /comments/, expected_params)
    
    env = build_env("POST", "/content/1/comments", 'multipart/related; type="application/json"')
    status, headers, body = middleware.call(env)

    assert_equal 415, status
  end
  
end
