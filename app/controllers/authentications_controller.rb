class AuthenticationsController < ActionController::Base
  # layout "application"
  # def index
  #   @authentications = current_user.authentications if current_user
  # end


  def create
    %w(auth origin params strategy).each do |x|
      puts x, request.env["omniauth.#{x}"].inspect
    end

    omniauth = request.env['omniauth.auth']

    # FIXME what error handling needs to go here?
    if omniauth[:provider] == :idpp
      token = omniauth[:credentials][:token]
      raise token
    end




    # authentication = Authentication.where(provider: omniauth['provider'], uid: omniauth['uid']).first

    # if authentication
    #   AuditLog.create(requester_info: authentication.user, event: "user_auth", description: "successful sign in")
    #   flash[:notice] = "Signed in successfully."
    #   sign_in_and_redirect(:user, authentication.user)
    # elsif current_user
    #   current_user.authentications.create!(:provider => omniauth['provider'], :uid => omniauth['uid'])
    #   AuditLog.create(requester_info: current_user.email, event: "user_auth2", description: "successful sign in")
    #   flash[:notice] = "Authentication successful."
    #   redirect_to authentications_url
    # else
    #   user = User.new
    #   user.apply_omniauth(omniauth)
    #   if user.save
    #     user.authentications[0].save
    #     AuditLog.create(requester_info: user.email, event: "user_auth3", description: "successful account create and sign in")
    #     flash[:notice] = "Signed in successfully."
    #     sign_in_and_redirect(:user, user)
    #   else
    #     session[:omniauth] = omniauth.except('extra')
    #     redirect_to new_user_registration_url
    #   end
    # end
  end

  def setup
    # byebug
    private_key = OpenSSL::PKey::RSA.new File.read Rails.root.join('config', 'client.key')
    now = Time.now.to_i
    claim = {
      iss: '030e247e-4b5c-4fe8-a7a1-ea1d583deee7', # Client ID
      sub: '030e247e-4b5c-4fe8-a7a1-ea1d583deee7', # Client ID
      aud: 'https://idp-p.mitre.org/token',
      iat: now,
      exp: now + 60,
      jti: "#{now}/#{SecureRandom.hex(18)}"
    }
    jws = JSON::JWT.new(claim).sign(private_key, 'RS256')
    request.env['omniauth.strategy'].options[:client_options][:client_assertion] = jws
    puts request.env['omniauth.strategy'].options.inspect
    render :text => "Omniauth setup phase.", :status => 404
  end

  # def destroy
  #   @authentication = current_user.authentications.find(params[:id])
  #   @authentication.destroy
  #   flash[:notice] = "Successfully destroyed authentication."
  #   redirect_to authentications_url
  # end


  protected

  # This is necessary since Rails 3.0.4
  # See https://github.com/intridea/omniauth/issues/185
  # and http://www.arailsdemo.com/posts/44
  # def handle_unverified_request
  #   true
  # end

end
