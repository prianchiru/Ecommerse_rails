require 'test_helper'

class AppliancesControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  setup do
    AppliancesController.any_instance.stubs(:authorize_request).returns(true)
  end

  test "should get appliances" do
    get '/appliances'
    assert_response :success
  end

  test "should get appliance by name" do
    get '/appliances/MyString'
    assert_response :success
  end

  test "should get appliance by id" do
    get '/appliances/1'
    assert_response :success
  end

  test "should create appliance if only the user is admin" do
    ApplicationController.any_instance.stubs(:isAdmin).returns(true)
    post '/appliances', params: {
      id: 3, name: :appliance1, price: 12, count: 10, brand: :someone, model: :m1, admin: false
    }
    assert_response :success
  end

  test "should update appliance if only the user is admin" do
    ApplicationController.any_instance.stubs(:isAdmin).returns(true)
    put '/appliances/1', params: {
      name: :test
    }
    assert_response :success
  end

  test "should destroy appliance if only the user is admin" do
    ApplicationController.any_instance.stubs(:isAdmin).returns(true)
    delete '/appliances/1'
    assert_response :success
  end

  test "should add appliance if only the user is admin" do
    ApplicationController.any_instance.stubs(:isAdmin).returns(true)
    post '/appliances/add', params: { product: 'MyString', count: 2 }
    assert_response :success
  end

  test "should buy appliance" do
    ApplicationController.any_instance.stubs(:isAdmin).returns(true)
    post '/appliances/buy', params: { product: 'MyString', count: 2 }
    assert_response :success
  end

  test "should not create appliance if the user is not admin" do
    post '/appliances', params: {
      id: 3, name: :appliance1, price: 12, count: 10, brand: :someone, model: :m1, admin: false
    }
    
    @response.server_error?
    assert_equal(@response.parsed_body, {"message"=>"permission denied"})
  end

  test "should not update appliance if the user is not admin" do
    put '/appliances/1', params: {
      name: :test
    }
    @response.server_error?
    assert_equal(@response.parsed_body, {"message"=>"permission denied"})
  end

  test "should not destroy appliance if the user is not admin" do
    delete '/appliances/1'
    @response.server_error?
    assert_equal(@response.parsed_body, {"message"=>"permission denied"})
  end

  test "should not add appliance if the user is not admin" do
    post '/appliances/add', params: { product: 'MyString', count: 2 }
    @response.server_error?
    assert_equal(@response.parsed_body, {"message"=>"permission denied"})
  end

  test "should not create appliance without name" do
    ApplicationController.any_instance.stubs(:isAdmin).returns(true)
    post '/appliances', params: {
      id: 3, price: 12, count: 10, brand: :someone, model: :m1, admin: false
    }
    @response.server_error?
    assert_equal(@response.parsed_body["errors"], {"name"=>["can't be blank"]})
  end

  test "should not create appliance without price" do
    ApplicationController.any_instance.stubs(:isAdmin).returns(true)
    post '/appliances', params: {
      id: 3, name: :test, count: 10, brand: :someone, model: :m1, admin: false
    }
    @response.server_error?
    assert_equal(@response.parsed_body["errors"], {"price"=>["can't be blank"]})
  end

  test "should not create appliance without count" do
    ApplicationController.any_instance.stubs(:isAdmin).returns(true)
    post '/appliances', params: {
      id: 3, name: :test, price: 12, brand: :someone, model: :m1, admin: false
    }
    @response.server_error?
    assert_equal(@response.parsed_body["errors"], {"count"=>["can't be blank"]})
  end

  test "should not create appliance without brand" do
    ApplicationController.any_instance.stubs(:isAdmin).returns(true)
    post '/appliances', params: {
      id: 3, name: :test, price: 12, count: 10, model: :m1, admin: false
    }
    @response.server_error?
    assert_equal(@response.parsed_body["errors"], {"brand"=>["can't be blank"]})
  end

  test "should not create appliance if price is not number" do
    ApplicationController.any_instance.stubs(:isAdmin).returns(true)
    post '/appliances', params: {
      id: 3, name: :test, price: :non, count: 10, brand: :someone, model: :m1, admin: false
    }
    @response.server_error?
    assert_equal(@response.parsed_body["errors"], {"price"=>["is not a number"]})
  end

  test "should not create appliance if count is not number" do
    ApplicationController.any_instance.stubs(:isAdmin).returns(true)
    post '/appliances', params: {
      id: 3, name: :test, price: 12, count: :non, brand: :someone, model: :m1, admin: false
    }
    @response.server_error?
    assert_equal(@response.parsed_body["errors"], {"count"=>["is not a number"]})
  end
end
