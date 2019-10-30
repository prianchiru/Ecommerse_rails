require 'test_helper'

class BooksControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert false
  # end
  def setup
    BooksController.any_instance.stubs(:authorize_request).returns(true)
    @test_data = YAML.load(File.read('test/fixtures/books.yml'))
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

  def test_should_get_books
    get :index
    assert_response :success
    result = format_response(@response.parsed_body["data"])
    assert_equal(result, @test_data_array)
  end

  def test_should_get_book_by_name
    get :show, params: { id: @test_data_array[0]["name"] }
    assert_response :success
    result = format_response([@response.parsed_body["data"]])
    assert_equal(result[0], @test_data_array[0])
  end

  def test_should_get_book_by_id
    get :show, params: { id: @test_data_array[0]["id"] }
    assert_response :success
    result = format_response([@response.parsed_body["data"]])
    assert_equal(result[0], @test_data_array[0])
  end

  def test_should_create_book_if_only_the_user_is_admin
    ApplicationController.any_instance.stubs(:isAdmin).returns(true)
    input_data = {
      "id" => 3, "name" => "book1", "price" => 12.0, "count" => 10, "author" => "someone", "published" => 1999
    }
    post :create, params: input_data
    assert_response :success
    result = format_response([Book.find(3).serializable_hash])
    assert_equal(result[0], input_data)
  end

  def test_should_update_book_if_only_the_user_is_admin
    ApplicationController.any_instance.stubs(:isAdmin).returns(true)
    put :update, params: {
      "id" => "MyString1", "name" => "test"
    }
    assert_response :success
    result = format_response([Book.find(1).serializable_hash])
    assert_equal("test", result[0]["name"])
  end

  def test_should_destroy_book_if_only_the_user_is_admin
    ApplicationController.any_instance.stubs(:isAdmin).returns(true)
    delete :destroy, params: { "id" => 1 }
    assert_response :success
    result = Book.all.map { |app| app[:id] }
    assert_not result.include? 1
  end

  def test_should_add_book_if_only_the_user_is_admin
    ApplicationController.any_instance.stubs(:isAdmin).returns(true)
    post :add, params: { product: 'MyString1', count: 2 }
    assert_response :success
    result = format_response([Book.find(1).serializable_hash])
    assert_equal(@test_data_array[0]["count"] + 2, result[0]["count"])
  end

  def test_should_buy_book
    ApplicationController.any_instance.stubs(:isAdmin).returns(true)
    post :buy, params: { product: 'MyString1', count: 1 }
    assert_response :success
    result = format_response([Book.find(1).serializable_hash])
    assert_equal(@test_data_array[0]["count"] - 1, result[0]["count"])
  end

  def test_should_not_create_book_if_the_user_is_not_admin
    post :create, params: {
      id: 3, name: :book1, price: 12, count: 10, author: :someone, published: 1999
    }
    
    assert_response 401
    assert_equal(@response.parsed_body, {"message"=>"permission denied"})
  end

  def test_should_not_update_book_if_the_user_is_not_admin
    put :update, params: {
      id: :test
    }
    assert_response 401
    assert_equal(@response.parsed_body, {"message"=>"permission denied"})
  end

  def test_should_not_destroy_book_if_the_user_is_not_admin
    delete :destroy, params: { "id" => 1 }
    assert_response 401
    assert_equal(@response.parsed_body, {"message"=>"permission denied"})
  end

  def test_should_not_add_book_if_the_user_is_not_admin
    post :add, params: { product: 'MyString', count: 2 }
    assert_response 401
    assert_equal(@response.parsed_body, {"message"=>"permission denied"})
  end

  def test_should_not_create_book_without_name
    ApplicationController.any_instance.stubs(:isAdmin).returns(true)
    post :create, params: {
      id: 3, price: 12, count: 10, author: :someone, published: 1999, admin: false
    }
    assert_response 400
    assert_equal(@response.parsed_body["errors"], {"name"=>["can't be blank"]})
  end

  def test_should_not_create_book_without_price
    ApplicationController.any_instance.stubs(:isAdmin).returns(true)
    post :create, params: {
      id: 3, name: :test, count: 10, author: :someone, published: 1999, admin: false
    }
    assert_response 400
    assert_equal(@response.parsed_body["errors"], {"price"=>["can't be blank"]})
  end

  def test_should_not_create_book_without_count
    ApplicationController.any_instance.stubs(:isAdmin).returns(true)
    post :create, params: {
      id: 3, name: :test, price: 12, author: :someone, published: 1999, admin: false
    }
    assert_response 400
    assert_equal(@response.parsed_body["errors"], {"count"=>["can't be blank"]})
  end

  def test_should_not_create_book_without_author
    ApplicationController.any_instance.stubs(:isAdmin).returns(true)
    post :create, params: {
      id: 3, name: :test, price: 12, count: 10, published: 1999, admin: false
    }
    assert_response 400
    assert_equal(@response.parsed_body["errors"], {"author"=>["can't be blank"]})
  end

  def test_should_not_create_book_if_price_is_not_number
    ApplicationController.any_instance.stubs(:isAdmin).returns(true)
    post :create, params: {
      id: 3, name: :test, price: :non, count: 10, author: :someone, published: 1999, admin: false
    }
    assert_response 400
    assert_equal(@response.parsed_body["errors"], {"price"=>["is not a number"]})
  end

  def test_should_not_create_book_if_count_is_not_number
    ApplicationController.any_instance.stubs(:isAdmin).returns(true)
    post :create, params: {
      id: 3, name: :test, price: 12, count: :non, author: :someone, published: 1999, admin: false
    }
    assert_response 400
    assert_equal(@response.parsed_body["errors"], {"count"=>["is not a number"]})
  end

  def test_should_not_create_book_if_published_is_not_number
    ApplicationController.any_instance.stubs(:isAdmin).returns(true)
    post :create, params: {
      id: 3, name: :test, price: 12, count: 10, author: :someone, published: :non, admin: false
    }
    assert_response 400
    assert_equal(@response.parsed_body["errors"], {"published"=>["is not a number"]})
  end

  def test_should_not_create_book_if_name_and_published_together_not_unique
    ApplicationController.any_instance.stubs(:isAdmin).returns(true)
    post :create, params: {
      id: 3, name: :test, journal: :studies, price: 12, count: 10, author: :someone, published: 1999, admin: false
    }
    post :create, params: {
      id: 3, name: :test, journal: :studies1, price: 12, count: 10, author: :someone, published: 1999, admin: false
    }
    assert_response 400
    assert_equal(@response.parsed_body["errors"], {"name"=>["has already been taken"]})
  end

  def test_should_create_book_if_name_and_published_together_is_unique
    ApplicationController.any_instance.stubs(:isAdmin).returns(true)
    post :create, params: {
      id: 3, name: :test, journal: :studies, price: 12, count: 10, author: :someone, published: 1999, admin: false
    }
    post :create, params: {
      id: 3, name: :test, journal: :studies1, price: 12, count: 10, author: :someone, published: 2000, admin: false
    }
    assert_response 200
    assert_nil @response.parsed_body["errors"]
  end
end
