class AppliancesController < ApplicationController
    before_action :authorize_request
    before_action :set_appliance, only: [:show, :update, :destroy]
    before_action :isAdmin, only: [:create, :update, :destroy, :add]
    before_action :validate_params, only: [:create, :update]

    APPLIANCES_CATEGORY = 'appliances'
    # /appliances
    # get
    def index
        @appliances = Appliance.all
        render json: { data: @appliances }
    end

    # /appliances/:id
    # get
    def show
        render json: { data: @appliance }
    end

    def add
    end

    # /appliances
    # post
    def create
        @appliance = Appliance.new(get_params)
        if @appliance.save
            render json: { message: "Appliance was successfully created" }
        elsif @appliance.invalid?
            render json: { message: "There is problem with appliance creation", errors: @appliance.errors }, status: 400
        else
            render json: { message: "There is problem with appliance creation", errors: @appliance.errors }, status: 500
        end
    end

    # /appliances/:id
    # post
    def update
        if @appliance.update(get_params)
            render json: { message: "Appliance was successfully updated" }
        elsif @appliance.invalid?
            render json: { message: "There is problem with appliance updation", errors: @appliance.errors }, status: 400
        else
            render json: { message: "There is problem with appliance updation", errors: @appliance.errors }, status: 500
        end
    end

    # /appliances/:id
    # delete
    def destroy
        @appliance.destroy
        render json: { message: "Appliance was successfully deleted" }, status: 200
    end

    def add
        begin
            ProductTrading.add_product(APPLIANCES_CATEGORY, params[:product], params[:count])  
            render json: { status: :success, message: "#{params[:product]} has been added to stock" }
        rescue => e
            render json: { message: e.message }, status: 500
        end
    end

    def buy
        begin
            ProductTrading.buy_product(APPLIANCES_CATEGORY, params[:product], params[:count])
            # Send email to the user
            @user_details = logged_in_user
            EmailJob.perform_later(@user_details, params[:product])
            render json: { message: "you bought product: #{params[:product]}" }
        rescue => e
            render json: { status: :error, message: e.message }
        end
    end


    private

    def set_appliance
        if params[:id] =~ /^(\d+)$/
            @appliance = Appliance.find(params[:id])
        else
            @appliance = Appliance.find_by(name: params[:id])
        end
    end

    def get_params
        params.permit(:name, :price, :count, :model, :brand, :warrenty_in_years)
    end

    def validate_params
        appliance = AppliancesValidator.new(params)
        if !appliance.valid?
            render json: { errors: appliance.errors }, status: 400
        end
    end
end
