class AuthenticationController < ApplicationController
  # Serves our authentication page
  def index; end

  # Will eventually receive authorization codes and trade them for access tokens.
  # For now, it's enough to just redirect to the success path to complete the user flow.
  def oauth_callback
    redirect_to oauth_success_path
  end

  # Renders the page that we'll redirect to from the procore login window. It will send
  # a message to the parent window that authentication was successful.
  def oauth_success; end
end
