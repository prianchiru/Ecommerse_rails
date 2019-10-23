class UsersController < ApplicationController
    before_action :authorize_request
    before_action :set_user, except: [:create, :index]
    before_action :isAdmin

    # /users
    # get
    def index
        @users = User.all
        render json: { data: @users }
    end

    # /users/:username
    # get
    def show
        render json: { data: @user }
    end

    # /users
    # post
    def create
        @user = User.new(get_params)
        if @user.save
            render json: { message: "User was successfully created" }
        else
            render json: { message: "There is problem with user creation", errors: @user.errors }, status: 500
        end
    end

    # /users/:username
    # post
    def update
        if @user.update(get_params)
            render json: { message: "User was successfully updated" }
        else
            render json: { message: "There is problem with user updation" }, status: 500
        end
    end

    # /users/:username
    # delete
    def destroy
        @user.destroy
        render json: { message: "User was successfully deleted" }
    end


    private

    def set_user
        @user = User.find_by_username(params[:username])
    end

    def get_params
        params.permit(:id, :name, :email, :username, :password, :admin)
    end
end
