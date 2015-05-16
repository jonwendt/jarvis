class SessionsController < ApplicationController
  layout false

  def new
  end

  def create
    @auth = request.env['omniauth.auth']['credentials']
    Token.create(
      user_id: current_user.id,
      access_token: @auth['token'],
      refresh_token: @auth['refresh_token'],
      expires_at: Time.at(@auth['expires_at']).to_datetime)

    respond_to do |format|
      format.html { redirect_to alarms_path, notice: 'Your Google account has successfully been linked to Jarvis! I can now tell you about upcoming events in your calendar.' }
    end
  end
end