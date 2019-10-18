class BooksController < ApplicationController
    before_action :authorize_request
    before_action :set_book, only: [:show, :update, :destroy]
    before_action :isAdmin, only: [:create, :update, :destroy, :add]
    before_action :validate_params, only: [:create, :update]
    # before_action :validate_params_update, only: :update
    # validates :name, presence: true
    # validates :price, numericality: true
    # validates :count, numericality: { integer_only: true }
    

    BOOKS_CATEGORY = 'books'
    # /books
    # get
    def index
        @books = Book.all
        render json: { data: @books }
    end

    # /books/:id
    # get
    def show
        render json: { data: @book }
    end

    # /books
    # post
    def create
        @book = Book.new(get_params)
        if @book.save
            render json: { message: "Book was successfully created" }
        else
            render json: { message: "There is problem with book creation", errors: @book.errors }, status: 500
        end
    end

    def add
        begin
            ProductTrading.add_product(BOOKS_CATEGORY, params[:product], params[:count])  
            render json: { message: "#{params[:product]} has been added to stock" }
        rescue => e
            render json: { message: e.message }, status: 500
        end
    end

    def buy
        begin
            ProductTrading.buy_product(BOOKS_CATEGORY, params[:product], params[:count])
            @user_details = logged_in_user
            EmailJob.perform_later(@user_details, params[:product])
            render json: { message: "you bought product: #{params[:product]}" }
        rescue => e
            render json: { error: e.message }, status: 500
        end
    end

    # /books/:id
    # post
    def update
        if @book.update(get_params_update)
            render json: { message: "Book was successfully updated" }, status: 200
        else
            render json: { error: "There is problem with book updation" }, status: 500
        end
    end

    # /books/:id
    # delete
    def destroy
        @book.destroy
        render json: { error: "Book was successfully deleted" }, status: 200
    end


    private

    def set_book
        if params[:id] =~ /^(\d+)$/
            @book = Book.find(params[:id])
        else
            @book = Book.find_by(name: params[:id])
        end
    end

    def get_params
        params.permit(:id, :name, :price, :count, :author, :published)
    end

    def get_params_update
        params.permit(:id, :name, :price, :count, :author, :published)
    end

    def validate_params
        book = BooksValidator.new(params)
        if !book.valid?
            render json: { errors: book.errors }, status: 500
        end
    end
end
