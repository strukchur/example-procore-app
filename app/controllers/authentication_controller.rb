class AuthenticationController < ApplicationController
  # Serves our authentication page
  def index; end

  def oauth_callback
    # In a production app, we would store these elsewhere as app configurations
    # WARNING: do not commit these keys and then push to a public repository
    client_id = '<YOUR_CLIENT_ID>'
    client_secret = '<YOUR_CLIENT_SECRET>'

    # If successful, the exchange response will contain an access token which
    # allows us to make requests to the Procore API on behalf of the authenticated user.
    exchange_response = JSON.parse(Net::HTTP.post_form(
      URI('https://login-sandbox.procore.com/oauth/token'),
      {
        grant_type: 'authorization_code',
        client_id: client_id,
        client_secret: client_secret,
        code: params['code'],
        redirect_uri: 'http://localhost:3000/oauth_callback',
      }
    ).body)

    # The Procore Ruby SDK uses this class to make token management simpler.
    auth_token = Procore::Auth::Token.new(
      access_token: exchange_response['access_token'],
      refresh_token: exchange_response['refresh_token'],
      expires_at: Time.at(
        exchange_response['created_at'].to_i + exchange_response['expires_in'].to_i
      )
    )

    # We're storing the auth token in the user's session so that we can use it repeatedly.
    # In a production app, this is not recommended and you would want to store it somewhere
    # more reliable like in a database, key-value store, etc.
    auth_store = Procore::Auth::Stores::Session.new(session: session)
    auth_store.save(auth_token)

    # Now that we have the access token stored, we can use the Procore SDK to request
    # information about the authenticated user by querying the API!
    user_info = Procore::Client.new(
      client_id: client_id,
      client_secret: client_secret,
      store: auth_store
    ).get('/me', version: 'v1.0').body

    # Store this information in the user's session so we can access it later
    session.merge!({
      user_id: user_info['id'],
      user_email: user_info['login'],
      user_name: user_info['name']
    })

    redirect_to oauth_success_path
  end

  # Renders the page that we'll redirect to from the procore login window. It will send
  # a message to the parent window that authentication was successful.
  def oauth_success; end
end
