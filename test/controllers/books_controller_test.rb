require 'test_helper'

class BooksControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert false
  # end
  setup do
    BooksController.any_instance.stubs(:authorize_request).returns(true)
  end

  test "should get books" do
    # BooksController.stub_any_instance(:authorize_request, true) do
    #   get '/books'
    #   assert_response :success
    # end
    get '/books'
    assert_response :success
  end

  test "should get book by name" do
    get '/books/MyString'
    assert_response :success
  end

  test "should get book by id" do
    get '/books/1'
    assert_response :success
  end

  test "should create book if only the user is admin" do
    ApplicationController.any_instance.stubs(:isAdmin).returns(true)
    post '/books', params: {
      id: 3, name: :book1, price: 12, count: 10, author: :someone, published: 1999, admin: false
    }
    assert_response :success
  end

  test "should update book if only the user is admin" do
    ApplicationController.any_instance.stubs(:isAdmin).returns(true)
    put '/books/1', params: {
      name: :test
    }
    assert_response :success
  end

  test "should destroy book if only the user is admin" do
    ApplicationController.any_instance.stubs(:isAdmin).returns(true)
    delete '/books/1'
    assert_response :success
  end

  test "should add book if only the user is admin" do
    ApplicationController.any_instance.stubs(:isAdmin).returns(true)
    post '/books/add', params: { product: 'MyString', count: 2 }
    assert_response :success
  end

  test "should buy book" do
    ApplicationController.any_instance.stubs(:isAdmin).returns(true)
    post '/books/buy', params: { product: 'MyString', count: 2 }
    assert_response :success
  end

  test "should not create book if the user is not admin" do
    post '/books', params: {
      id: 3, name: :book1, price: 12, count: 10, author: :someone, published: 1999, admin: false
    }
    
    @response.server_error?
    assert_equal(@response.parsed_body, {"message"=>"permission denied"})
  end

  test "should not update book if the user is not admin" do
    put '/books/1', params: {
      name: :test
    }
    @response.server_error?
    assert_equal(@response.parsed_body, {"message"=>"permission denied"})
  end

  test "should not destroy book if the user is not admin" do
    delete '/books/1'
    @response.server_error?
    assert_equal(@response.parsed_body, {"message"=>"permission denied"})
  end

  test "should not add book if the user is not admin" do
    post '/books/add', params: { product: 'MyString', count: 2 }
    @response.server_error?
    assert_equal(@response.parsed_body, {"message"=>"permission denied"})
  end

  test "should not create book without name" do
    ApplicationController.any_instance.stubs(:isAdmin).returns(true)
    post '/books', params: {
      id: 3, price: 12, count: 10, author: :someone, published: 1999, admin: false
    }
    @response.server_error?
    assert_equal(@response.parsed_body["errors"], {"name"=>["can't be blank"]})
  end

  test "should not create book without price" do
    ApplicationController.any_instance.stubs(:isAdmin).returns(true)
    post '/books', params: {
      id: 3, name: :test, count: 10, author: :someone, published: 1999, admin: false
    }
    @response.server_error?
    assert_equal(@response.parsed_body["errors"], {"price"=>["can't be blank"]})
  end

  test "should not create book without count" do
    ApplicationController.any_instance.stubs(:isAdmin).returns(true)
    post '/books', params: {
      id: 3, name: :test, price: 12, author: :someone, published: 1999, admin: false
    }
    @response.server_error?
    assert_equal(@response.parsed_body["errors"], {"count"=>["can't be blank"]})
  end

  test "should not create book without author" do
    ApplicationController.any_instance.stubs(:isAdmin).returns(true)
    post '/books', params: {
      id: 3, name: :test, price: 12, count: 10, published: 1999, admin: false
    }
    @response.server_error?
    assert_equal(@response.parsed_body["errors"], {"author"=>["can't be blank"]})
  end

  test "should not create book if price is not number" do
    ApplicationController.any_instance.stubs(:isAdmin).returns(true)
    post '/books', params: {
      id: 3, name: :test, price: :non, count: 10, author: :someone, published: 1999, admin: false
    }
    @response.server_error?
    assert_equal(@response.parsed_body["errors"], {"price"=>["is not a number"]})
  end

  test "should not create book if count is not number" do
    ApplicationController.any_instance.stubs(:isAdmin).returns(true)
    post '/books', params: {
      id: 3, name: :test, price: 12, count: :non, author: :someone, published: 1999, admin: false
    }
    @response.server_error?
    assert_equal(@response.parsed_body["errors"], {"count"=>["is not a number"]})
  end

  test "should not create book if published is not number" do
    ApplicationController.any_instance.stubs(:isAdmin).returns(true)
    post '/books', params: {
      id: 3, name: :test, price: 12, count: 10, author: :someone, published: :non, admin: false
    }
    @response.server_error?
    assert_equal(@response.parsed_body["errors"], {"published"=>["is not a number"]})
  end
end
