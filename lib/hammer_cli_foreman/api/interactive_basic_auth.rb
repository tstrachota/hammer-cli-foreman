require 'highline/import'

module HammerCLIForeman
  module Api
    class InteractiveBasicAuth < ApipieBindings::Authenticators::BasicAuth

      def authenticate(request, args)
        if HammerCLI.interactive?
          get_user
          get_password
        end
        super
      end

      def error(ex)
        return UnauthorizedError.new(_("Invalid username or password")) if ex.is_a?(RestClient::Unauthorized)
      end

      def status
        unless @user.nil? || @password.nil?
          _("Using configured credentials for user '%s'.") % @user
        else
          _("Credentials are not configured.")
        end
      end

      def user
        @user
      end

      def set_credentials(user, password)
        @user = user
        @password = password
      end

      private

      def get_user
        @user ||= ask_user(_("[Foreman] Username: "))
      end

      def get_password
        @password ||= ask_user(_("[Foreman] Password for %s: ") % @user, true)
      end

      def ask_user(prompt, silent=false)
        if silent
          ask(prompt) {|q| q.echo = false}
        else
          ask(prompt)
        end
      end
    end
  end
end
