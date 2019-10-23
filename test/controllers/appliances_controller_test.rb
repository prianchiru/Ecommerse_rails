require 'test_helper'
require 'yaml'

class AppliancesControllerTest < ActionController::TestCase
  # def the_truth
  #   assert true
  # end
  def setup
    AppliancesController.any_instance.stubs(:authorize_request).returns(true)
    @test_data = YAML.load(File.read('test/fixtures/appliances.yml'))
    @test_data_array = @test_data.values
    @test_data_keys = @test_data_array[0].keys
  end

  def format_response(response)
    result = response.map do |hash|
      hash.select do |key, value|
        @test_data_keys.include? key
      end
    end

    return result
  end

  def test_should_get_appliances
    get :index
    assert_response :success
    result = format_response(@response.parsed_body["data"])
    assert_equal(result, @test_data_array)
  end

  def test_should_get_appliance_by_name
    get :show, params: { id: @test_data_array[0]["name"] }
    assert_response :success
    result = format_response([@response.parsed_body["data"]])
    assert_equal(result[0], @test_data_array[0])
  end

  def test_should_get_appliance_by_id
    get :show, params: { id: @test_data_array[0]["id"] }
    assert_response :success
    result = format_response([@response.parsed_body["data"]])
    assert_equal(result[0], @test_data_array[0])
  end

  def test_should_create_appliance_if_only_the_user_is_admin
    ApplicationController.any_instance.stubs(:isAdmin).returns(true)
    input_data = {
      "id" => 3, "name" => "appliance1", "price" => 12, "count" => 10, "brand" => "someone", "model" => "m1"
    }
    post :create, params: input_data
    assert_response :success
    result = format_response([Appliance.find(3).serializable_hash])
    assert_equal(result[0], input_data)
  end

  def test_should_update_appliance_if_only_the_user_is_admin
    ApplicationController.any_instance.stubs(:isAdmin).returns(true)
    put :update, params: {
      "id" => "MyString1", "name" => "test"
    }
    assert_response :success
    result = format_response([Appliance.find(1).serializable_hash])
    assert_equal("test", result[0]["name"])
  end

  def test_should_destroy_appliance_if_only_the_user_is_admin
    ApplicationController.any_instance.stubs(:isAdmin).returns(true)
    delete :destroy, params: { "id" => 1 }
    assert_response :success
    result = Appliance.all.map { |app| app[:id] }
    assert_not result.include? 1
  end

  def test_should_add_appliance_if_only_the_user_is_admin
    ApplicationController.any_instance.stubs(:isAdmin).returns(true)
    post :add, params: { product: 'MyString1', count: 2 }
    assert_response :success
    result = format_response([Appliance.find(1).serializable_hash])
    assert_equal(@test_data_array[0]["count"] + 2, result[0]["count"])
  end

  def test_should_buy_appliance
    ApplicationController.any_instance.stubs(:isAdmin).returns(true)
    post :buy, params: { product: 'MyString1', count: 1 }
    assert_response :success
    result = format_response([Appliance.find(1).serializable_hash])
    assert_equal(@test_data_array[0]["count"] - 1, result[0]["count"])
  end

  def test_should_not_create_appliance_if_the_user_is_not_admin
    post :create, params: {
      id: 3, name: :appliance1, price: 12, count: 10, brand: :someone, model: :m1, admin: false
    }
    
    assert @response.server_error?
    assert_equal(@response.parsed_body, {"message"=>"permission denied"})
  end

  def test_should_not_update_appliance_if_the_user_is_not_admin
    put :update, params: {
      id: :test
    }
    assert @response.server_error?
    assert_equal(@response.parsed_body, {"message"=>"permission denied"})
  end

  def test_should_not_destroy_appliance_if_the_user_is_not_admin
    delete :destroy, params: { "id" => 1 }
    assert @response.server_error?
    assert_equal(@response.parsed_body, {"message"=>"permission denied"})
  end

  def test_should_not_add_appliance_if_the_user_is_not_admin
    post :add, params: { product: 'MyString', count: 2 }
    assert @response.server_error?
    assert_equal(@response.parsed_body, {"message"=>"permission denied"})
  end

  def test_should_not_create_appliance_without_name
    ApplicationController.any_instance.stubs(:isAdmin).returns(true)
    post :create, params: {
      id: 3, price: 12, count: 10, brand: :someone, model: :m1, admin: false
    }
    assert @response.server_error?
    assert_equal(@response.parsed_body["errors"], {"name"=>["can't be blank"]})
  end

  def test_should_not_create_appliance_without_price
    ApplicationController.any_instance.stubs(:isAdmin).returns(true)
    post :create, params: {
      id: 3, name: :test, count: 10, brand: :someone, model: :m1, admin: false
    }
    assert @response.server_error?
    assert_equal(@response.parsed_body["errors"], {"price"=>["can't be blank"]})
  end

  def test_should_not_create_appliance_without_count
    ApplicationController.any_instance.stubs(:isAdmin).returns(true)
    post :create, params: {
      id: 3, name: :test, price: 12, brand: :someone, model: :m1, admin: false
    }
    assert @response.server_error?
    assert_equal(@response.parsed_body["errors"], {"count"=>["can't be blank"]})
  end

  def test_should_not_create_appliance_without_brand
    ApplicationController.any_instance.stubs(:isAdmin).returns(true)
    post :create, params: {
      id: 3, name: :test, price: 12, count: 10, model: :m1, admin: false
    }
    assert @response.server_error?
    assert_equal(@response.parsed_body["errors"], {"brand"=>["can't be blank"]})
  end

  def test_should_not_create_appliance_if_price_is_not_number
    ApplicationController.any_instance.stubs(:isAdmin).returns(true)
    post :create, params: {
      id: 3, name: :test, price: :non, count: 10, brand: :someone, model: :m1, admin: false
    }
    assert @response.server_error?
    assert_equal(@response.parsed_body["errors"], {"price"=>["is not a number"]})
  end

  def test_should_not_create_appliance_if_count_is_not_number
    ApplicationController.any_instance.stubs(:isAdmin).returns(true)
    post :create, params: {
      id: 3, name: :test, price: 12, count: :non, brand: :someone, model: :m1, admin: false
    }
    assert @response.server_error?
    assert_equal(@response.parsed_body["errors"], {"count"=>["is not a number"]})
  end

  def test_should_not_create_appliance_if_name_and_warrenty_in_years_together_not_unique
    ApplicationController.any_instance.stubs(:isAdmin).returns(true)
    post :create, params: {
      id: 3, name: :test, warrenty_in_years: 5, price: 12, count: 5, brand: :someone, model: :m1, admin: false
    }
    post :create, params: {
      id: 3, name: :test, warrenty_in_years: 5, price: 12, count: 5, brand: :someone, model: :m1, admin: false
    }
    assert @response.server_error?
    assert_equal(@response.parsed_body["errors"], {"name"=>["has already been taken"]})
  end
end
