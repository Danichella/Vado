class Api::V1::ApplicationController < ApplicationController
  before_action :authenticate_user_session!
  skip_forgery_protection
end
