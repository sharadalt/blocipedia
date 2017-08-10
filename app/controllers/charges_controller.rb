class ChargesController < ApplicationController
  
  def create
    # Creates a Stripe Customer object, for associating
    # with the charge
    customer = Stripe::Customer.create(
      email: params[:stripeEmail],
      card: params[:stripeToken]
    )
 
    # Where the real magic happens
    charge = Stripe::Charge.create(
      customer: customer.id, # Note -- this is NOT the user_id in your app
      amount: params[:amount],
      description: "Wikis Premium Membership - #{current_user.email}",
      currency: 'usd'
    )
  
    flash[:notice] = "Thanks for all the money, #{current_user.email}! Feel free to pay me again."
    #redirect_to user_path(current_user) # or wherever
    current_user.role = :premium
    current_user.save
    redirect_to wikis_path
   
    # Stripe will send back CardErrors, with friendly messages
    # when something goes wrong.
    # This `rescue block` catches and displays those errors.
    rescue Stripe::CardError => e
      flash[:alert] = e.message
      redirect_to new_charge_path
  end

  def new
   # @stripe_btn_data = {
     # key: "#{ Rails.configuration.stripe[:publishable_key] }",
     # description: "Wikis Premium Membership - #{current_user.name}",
     # amount: Amount.default
   # }
  end
end
