module AuthHelper
  def basic_auth(user)
  { 'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Basic.encode_credentials(user.username, user.password) }
  end
end
