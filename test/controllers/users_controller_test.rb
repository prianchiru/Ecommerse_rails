require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  def setup
    UsersController.any_instance.stubs(:authorize_request).returns(true)
    ApplicationController.any_instance.stubs(:isAdmin).returns(true)
    @test_data = YAML.load(File.read('test/fixtures/users.yml'))
    @test_data_array = @test_data.values
    @test_data_keys = @test_data_array[5].keys
  end

  def format_response(response)
    result = response.map do |hash|
      hash.select do |key, value|
        @test_data_keys.include? key
      end
    end

    return result
  end

  def test_should_get_users
    get :index
    assert_response :success
    result = format_response(@response.parsed_body["data"])
    assert_equal(result, @test_data_array)
  end

  def test_should_get_user_by_username
    get :show, params: { username: @test_data_array[0]["name"] }
    assert_response :success
    result = format_response([@response.parsed_body["data"]])
    assert_equal(result[0], @test_data_array[0])
  end

  def test_should_create_user_if_only_the_user_is_admin
    ApplicationController.any_instance.stubs(:isAdmin).returns(true)
    input_data = {
      "id" => 9, "name" => "user1", "username" => "user1", "password" => 654321, "admin" => false 
    }
    post :create, params: input_data
    assert_response :success
    result = format_response([User.find(9).serializable_hash])
    result[0].delete('password_digest')
    input_data.delete('password')
    assert_equal(result[0], input_data)
  end

  def test_should_update_user_if_only_the_user_is_admin
    ApplicationController.any_instance.stubs(:isAdmin).returns(true)
    put :update, params: {
      "username" => "test1", "name" => "test"
    }
    assert_response :success
    result = format_response([User.find(1).serializable_hash])
    assert_equal("test", result[0]["name"])
  end

  def test_should_destroy_user_if_only_the_user_is_admin
    ApplicationController.any_instance.stubs(:isAdmin).returns(true)
    delete :destroy, params: { "username" => "test1" }
    assert_response :success
    result = User.all.map { |app| app[:id] }
    assert_not result.include? 1
  end
end
