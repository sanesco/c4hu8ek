class Api::V1::PinsController < ApplicationController
  before_action :authenticate

  def index
    render json: Pin.all.order('created_at DESC')
  end
  def create
    pin = Pin.new(pin_params)
    if pin.save
      render json: pin, status: 201
    else
      render json: { errors: pin.errors }, status: 422
    end
  end
  private
    def pin_params
      params.require(:pin).permit(:title, :image_url)
    end

    def authenticate
      email_auth = request.headers["X-User-Email"]
      token_auth = request.headers["X-Api-Token"]
      head 401 unless User.find_by_email(email_auth) && User.find_by_api_token(token_auth)
    end
end
