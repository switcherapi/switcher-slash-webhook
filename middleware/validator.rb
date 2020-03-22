class Validator
    def initialize(app)
        @app = app
    end

    def call(env)
        if Rack::Request.new(env).params['token'] == @app.settings.slack_hook_token
            @app.call(env)
        else
            Rack::Response.new([], 401, {}).finish
        end
    end
end