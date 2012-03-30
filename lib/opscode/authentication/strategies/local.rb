require 'opscode/authentication/strategies/base'

module Opscode
  module Authentication
    module Strategies
      class Local < Opscode::Authentication::Strategies::Base

        def initialize(user_mapper, options={})
          @user_mapper = user_mapper
        end

        # performs authentication against the local database
        def authenticate(login, password)
          user = nil
          u = @user_mapper.find_by_username(login)
          if u && u.correct_password?(password)
            user = u
          end
          user.for_json
        end

      end
    end
  end
end
