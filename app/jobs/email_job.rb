class EmailJob < ApplicationJob
  queue_as :default

  def perform(user_details, product_name)
    UserMailer.with(user: user_details, product_name: product_name).purchase_email.deliver_now
  end
end
