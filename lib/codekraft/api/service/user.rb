module Codekraft
  module Api
    module Service
      class User < Base

        def initialize
          super(Codekraft::Api::Model::User)
        end

        def create params
          if params[:password]
            params[:salt] = ::BCrypt::Engine.generate_salt
            params[:encrypted_password] = encrypt_password(params[:password], params[:salt])
            params[:no_password] = false

            params.delete :password
            params.delete :password_confirm
          else
            params[:no_password] = true
            Codekraft::Api::Mailer::InvitationMailer.invite(user).deliver
          end
          params[:email] = params[:email].downcase
          super(params)
        end

        def update params
          if params.has_key? :password
            params[:salt] = BCrypt::Engine.generate_salt
            params[:encrypted_password] = encrypt_password(params[:password], params[:salt])
            params.delete :password
            params.delete :password_confirm
          end
          super(params)
        end

        def encrypt_password password, salt
          ::BCrypt::Engine.hash_secret(password, salt)
        end

      end
    end
  end
end
