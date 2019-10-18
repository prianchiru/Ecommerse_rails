class UserMailer < ApplicationMailer
    default from: 'prianchiru@gmail.com'

    def purchase_email
        @user = params[:user]
        @product_name = params[:product_name]
        mail(to: @user[:email], subject: "Purchasing product")
    end
end
