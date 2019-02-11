class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def twitter
    auth = request.env['omniauth.auth']
    @user = User.where(uid: auth.uid, provider: auth.provider).first_or_create!(
      uid: auth.uid,
      provider: auth.provider,
      email: auth.info.email,
      password: Devise.friendly_token
    )

    @user.update!(
      twitter_access_token: auth.credentials.token,
      twitter_access_secret: auth.credentials.secret
    )

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Twitter') if is_navigational_format?
    else
      session['devise.twitter_data'] = request.env['omniauth.auth']
      redirect_to new_user_registration_url
    end
  end

  def passthru
    render file: "#{Rails.root}/public/404.html", status: 404, layout: false
  end
end