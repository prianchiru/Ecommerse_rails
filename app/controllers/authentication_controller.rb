class AuthenticationController < ApplicationController
    def login
        @user = User.find_by_username(params[:username])
        if @user.authenticate(params[:password])
            token = JsonWebToken.encode(user_id: @user.id)
            exp_time = 24.hours.from_now
            render json: {
                token: token,
                username: params[:username],
                exp: exp_time.strftime("%m-%d-%y %H-%M")
            }
        else
            render json: { error: 'unauthorized' }, status: :unauthorized
        end
    end
end
