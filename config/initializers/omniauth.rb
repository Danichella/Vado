# frozen_string_literal: true

OmniAuth.config.on_failure = proc do |env|
  'Users::OmniauthCallbacksController'.constantize.action(:failure).call(env)
end
