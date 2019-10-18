require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    UsersController.any_instance.stubs(:authorize_request).returns(true)
  end

  test "should get users" do
    ApplicationController.any_instance.stubs(:isAdmin).returns(true)
    get '/users'
    assert_response :success
  end

  test "should get user by name" do
    ApplicationController.any_instance.stubs(:isAdmin).returns(true)
    get '/users/test1'
    assert_response :success
  end

  test "should create user if only the user is admin" do
    ApplicationController.any_instance.stubs(:isAdmin).returns(true)
    post '/users', params: {
      id: 9, name: :user1, username: :user1, password: 654321
    }
    assert_response :success
  end

  test "should update user if only the user is admin" do
    ApplicationController.any_instance.stubs(:isAdmin).returns(true)
    put '/users/test1', params: {
      name: :user1
    }
    assert_response :success
  end

  test "should destroy user if only the user is admin" do
    ApplicationController.any_instance.stubs(:isAdmin).returns(true)
    delete '/users/test1'
    assert_response :success
  end

  test "should not create user if the user is not admin" do
    post '/users', params: {
      id: 9, name: :user1, username: :user1, password: 654321
    }
    
    @response.server_error?
    assert_equal(@response.parsed_body, {"message"=>"permission denied"})
  end

  test "should not update user if the user is not admin" do
    put '/users/test1', params: {
      name: :user1
    }
    @response.server_error?
    assert_equal(@response.parsed_body, {"message"=>"permission denied"})
  end

  test "should not destroy user if the user is not admin" do
    delete '/users/test1'
    @response.server_error?
    assert_equal(@response.parsed_body, {"message"=>"permission denied"})
  end
end
