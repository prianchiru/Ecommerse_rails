class ApplicationController < ActionController::API
    include ActionController::MimeResponds

    before_action :testing
    before_action :add_headers
    
    def testing
        puts "parent testing"
    end

    def add_headers
        response.set_header('Access-Control-Allow-Origin', '*')
    end
    
    def not_found
        render json: { error: 'not found' }
    end

    def authorize_request
        auth_header = request.headers['Authorization']
        begin
            token = auth_header.split(' ')[1]
            @decoded = JsonWebToken.decode(token)
            @current_user = User.find(@decoded[:user_id])
        rescue ActiveRecord::RecordNotFound => exception
            render json: { message: exception.message, status: :unauthorized }, status: 401
        rescue JWT::DecodeError => exception
            render json: { message: exception.message, status: :unauthorized }, status: 401
        rescue
            render json: { message: exception, status: :unauthorized }, status: 401
        end
    end

    def isAdmin
        render json: { message: 'permission denied' }, status: 401 if !@current_user || !@current_user.admin     
    end

    def logged_in_user
        @current_user
    end
end
